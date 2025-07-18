# Input variables for the EKS monitoring deployment

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
  default     = "my-cluster"
}

variable "grafana_api_key" {
  description = "API key for Grafana workspace (generated dynamically)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "amp_ws_arn" {
  description = "ARN of the Amazon Managed Prometheus workspace"
  type        = string
  default     = ""
}

variable "s3_bucket_id" {
  description = "S3 bucket for Terraform state storage"
  type        = string
  default     = "johns-account-terraform-state"
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "eks-monitoring"
}

variable "prometheus_retention_days" {
  description = "Number of days to retain Prometheus metrics"
  type        = number
  default     = 7
}

variable "prometheus_scrape_interval" {
  description = "Prometheus scrape interval"
  type        = string
  default     = "30s"
}

variable "enable_cloudwatch_addon" {
  description = "Whether to enable CloudWatch Observability addon"
  type        = bool
  default     = true
}

variable "enable_node_exporter" {
  description = "Whether to enable Node Exporter"
  type        = bool
  default     = true
}

variable "enable_kube_state_metrics" {
  description = "Whether to enable Kube State Metrics"
  type        = bool
  default     = true
}

variable "grafana_admin_users" {
  description = "List of admin users for Grafana workspace"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "eks-monitoring"
    ManagedBy = "terraform"
  }
}
