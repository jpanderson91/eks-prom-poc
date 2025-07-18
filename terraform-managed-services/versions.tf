# Terraform version and provider requirements

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
    
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Provider configuration details:
# 
# aws ~> 5.0: Latest AWS provider with support for AMP and AMG
# helm ~> 2.15.0: Constrained version for compatibility with Kubernetes provider
# kubernetes ~> 2.23: Latest stable Kubernetes provider
# flux ~> 1.0: Flux provider for GitOps configuration
# null ~> 3.0: Null provider for local provisioners and API calls
