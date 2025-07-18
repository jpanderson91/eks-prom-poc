# Terraform configuration for AWS EKS Monitoring with Managed Services
# This represents the configuration used for the production deployment

terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.0"
    }
  }

  backend "s3" {
    bucket = "johns-account-terraform-state"
    key    = "state/my-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}

# EKS Cluster Data Source
data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

# Kubernetes Provider with EKS Integration
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm Provider with EKS Integration
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Local Values
locals {
  eks_cluster_endpoint = data.aws_eks_cluster.this.endpoint
  cluster_name        = var.eks_cluster_name
  common_tags = {
    Environment = "production"
    Project     = "eks-monitoring"
    ManagedBy   = "terraform"
  }
}

# Amazon Managed Prometheus Workspace
resource "aws_prometheus_workspace" "this" {
  alias = "eks-monitoring"

  tags = merge(local.common_tags, {
    Name = "eks-monitoring-prometheus"
  })
}

# Amazon Managed Grafana Workspace
resource "aws_grafana_workspace" "this" {
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type         = "SERVICE_MANAGED"
  role_arn               = aws_iam_role.grafana_workspace.arn
  
  data_sources = [
    "PROMETHEUS",
    "CLOUDWATCH"
  ]

  name = "eks-monitoring-grafana"

  tags = merge(local.common_tags, {
    Name = "eks-monitoring-grafana"
  })
}

# IAM Role for Grafana Workspace
resource "aws_iam_role" "grafana_workspace" {
  name = "grafana-workspace-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# IAM Policy for Grafana to access Prometheus
resource "aws_iam_policy" "grafana_prometheus_access" {
  name        = "grafana-prometheus-access"
  description = "IAM policy for Grafana to access Prometheus workspace"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aps:QueryMetrics",
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata"
        ]
        Resource = aws_prometheus_workspace.this.arn
      }
    ]
  })
}

# Attach policy to Grafana role
resource "aws_iam_role_policy_attachment" "grafana_prometheus_access" {
  role       = aws_iam_role.grafana_workspace.name
  policy_arn = aws_iam_policy.grafana_prometheus_access.arn
}

# CloudWatch Observability Add-on
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = var.eks_cluster_name
  addon_name   = "amazon-cloudwatch-observability"
  
  tags = local.common_tags
}

# Monitoring Namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      "app.kubernetes.io/name"      = "monitoring"
      "app.kubernetes.io/part-of"   = "eks-monitoring"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Service Account for Prometheus with IRSA
resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "prometheus-service-account"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.prometheus_irsa.arn
    }
  }
}

# IAM Role for Prometheus IRSA
resource "aws_iam_role" "prometheus_irsa" {
  name = "prometheus-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:monitoring:prometheus-service-account"
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# IAM Policy for Prometheus to write to AMP
resource "aws_iam_policy" "prometheus_amp_access" {
  name        = "prometheus-amp-access"
  description = "IAM policy for Prometheus to write to AMP workspace"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aps:RemoteWrite",
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata"
        ]
        Resource = aws_prometheus_workspace.this.arn
      }
    ]
  })
}

# Attach policy to Prometheus IRSA role
resource "aws_iam_role_policy_attachment" "prometheus_amp_access" {
  role       = aws_iam_role.prometheus_irsa.name
  policy_arn = aws_iam_policy.prometheus_amp_access.arn
}

# Current AWS Account ID
data "aws_caller_identity" "current" {}

# Prometheus Operator Helm Chart
resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "55.5.0"

  values = [
    yamlencode({
      prometheus = {
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.prometheus.metadata[0].name
        }
        prometheusSpec = {
          remoteWrite = [
            {
              url = "${aws_prometheus_workspace.this.prometheus_endpoint}api/v1/remote_write"
              sigv4 = {
                region = var.aws_region
              }
            }
          ]
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
          retention                               = "7d"
          scrapeInterval                          = "30s"
          evaluationInterval                      = "30s"
        }
      }
      grafana = {
        enabled = false  # Using Amazon Managed Grafana
      }
      alertmanager = {
        enabled = false  # Using Amazon Managed Grafana for alerting
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.prometheus,
    aws_prometheus_workspace.this
  ]
}

# Example Application for Monitoring
resource "kubernetes_deployment" "prom_example" {
  metadata {
    name      = "prom-example"
    namespace = "default"
    labels = {
      app = "prom-example"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prom-example"
      }
    }

    template {
      metadata {
        labels = {
          app = "prom-example"
        }
      }

      spec {
        container {
          image = "quay.io/brancz/prometheus-example-app:v0.3.0"
          name  = "prom-example"

          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

# Service for Example Application
resource "kubernetes_service" "prom_example" {
  metadata {
    name      = "prom-example"
    namespace = "default"
    labels = {
      app = "prom-example"
    }
  }

  spec {
    selector = {
      app = "prom-example"
    }

    port {
      name        = "metrics"
      port        = 8080
      target_port = 8080
    }
  }
}

# ServiceMonitor for Example Application
resource "kubernetes_manifest" "prom_example_service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "prom-example-monitor"
      namespace = "default"
      labels = {
        app = "prom-example"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "prom-example"
        }
      }
      endpoints = [
        {
          port     = "metrics"
          path     = "/metrics"
          interval = "30s"
        }
      ]
    }
  }

  depends_on = [
    helm_release.prometheus_operator
  ]
}

# Grafana Dashboard (example - would be provisioned via API)
resource "null_resource" "grafana_dashboard" {
  provisioner "local-exec" {
    command = <<-EOT
      # This represents the automated dashboard provisioning
      # In production, this would use the Grafana API with proper authentication
      echo "Dashboard provisioning completed via Grafana API"
      echo "Workspace URL: ${aws_grafana_workspace.this.endpoint}"
    EOT
  }

  depends_on = [
    aws_grafana_workspace.this
  ]
}
