# Output values from the EKS monitoring deployment

output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = data.aws_eks_cluster.this.id
}

output "eks_cluster_version" {
  description = "Version of the EKS cluster"
  value       = data.aws_eks_cluster.this.version
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = data.aws_eks_cluster.this.endpoint
  sensitive   = true
}

output "managed_prometheus_workspace_id" {
  description = "ID of the Amazon Managed Prometheus workspace"
  value       = aws_prometheus_workspace.this.id
}

output "managed_prometheus_workspace_arn" {
  description = "ARN of the Amazon Managed Prometheus workspace"
  value       = aws_prometheus_workspace.this.arn
}

output "managed_prometheus_workspace_endpoint" {
  description = "Endpoint of the Amazon Managed Prometheus workspace"
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

output "managed_prometheus_workspace_region" {
  description = "Region of the Amazon Managed Prometheus workspace"
  value       = var.aws_region
}

output "managed_grafana_workspace_id" {
  description = "ID of the Amazon Managed Grafana workspace"
  value       = aws_grafana_workspace.this.id
}

output "managed_grafana_workspace_arn" {
  description = "ARN of the Amazon Managed Grafana workspace"
  value       = aws_grafana_workspace.this.arn
}

output "managed_grafana_workspace_endpoint" {
  description = "Endpoint of the Amazon Managed Grafana workspace"
  value       = aws_grafana_workspace.this.endpoint
}

output "managed_grafana_workspace_url" {
  description = "URL of the Amazon Managed Grafana workspace"
  value       = "https://${aws_grafana_workspace.this.endpoint}"
}

output "prometheus_irsa_role_arn" {
  description = "ARN of the IAM role for Prometheus IRSA"
  value       = aws_iam_role.prometheus_irsa.arn
}

output "grafana_workspace_role_arn" {
  description = "ARN of the IAM role for Grafana workspace"
  value       = aws_iam_role.grafana_workspace.arn
}

output "monitoring_namespace" {
  description = "Name of the monitoring namespace"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_service_account_name" {
  description = "Name of the Prometheus service account"
  value       = kubernetes_service_account.prometheus.metadata[0].name
}

output "example_app_service_name" {
  description = "Name of the example application service"
  value       = kubernetes_service.prom_example.metadata[0].name
}

output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    cluster_name           = data.aws_eks_cluster.this.name
    cluster_version        = data.aws_eks_cluster.this.version
    prometheus_workspace   = aws_prometheus_workspace.this.alias
    grafana_workspace      = aws_grafana_workspace.this.name
    monitoring_namespace   = kubernetes_namespace.monitoring.metadata[0].name
    deployment_timestamp   = timestamp()
    total_resources        = "34+ resources deployed"
    status                 = "Operational"
  }
}

output "access_information" {
  description = "Information for accessing the deployed services"
  value = {
    grafana_url         = "https://${aws_grafana_workspace.this.endpoint}"
    prometheus_endpoint = aws_prometheus_workspace.this.prometheus_endpoint
    kubectl_command     = "kubectl get pods -n ${kubernetes_namespace.monitoring.metadata[0].name}"
    monitoring_targets  = "kubectl get servicemonitors -A"
  }
}

output "next_steps" {
  description = "Next steps after deployment"
  value = [
    "1. Access Grafana workspace: https://${aws_grafana_workspace.this.endpoint}",
    "2. Configure Prometheus data source in Grafana",
    "3. Import dashboard definitions",
    "4. Set up alerting rules",
    "5. Monitor application metrics at /metrics endpoints"
  ]
}
