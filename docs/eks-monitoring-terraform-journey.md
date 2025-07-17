# AWS EKS Monitoring Solution Deployment with Prometheus, Grafana, and Terraform

## Overview

This document summarizes my experience following the [AWS Managed Grafana EKS Monitoring Solution](https://docs.aws.amazon.com/grafana/latest/userguide/solution-eks.html#solution-eks-about) guide. It covers the prerequisites, what was deployed, and the troubleshooting steps I performed to successfully set up end-to-end monitoring for an EKS cluster using Terraform, Prometheus, and Grafana.

## Screenshots

## EKS Cluster

<img width="1893" height="801" alt="image" src="https://github.com/user-attachments/assets/f912cafd-ad13-470d-95fa-e7b4522daa57" />

## AMP

<img width="1902" height="479" alt="image" src="https://github.com/user-attachments/assets/969526aa-71ba-44a5-9c17-a611c3ac0d74" />


## AMG

<img width="1872" height="971" alt="image" src="https://github.com/user-attachments/assets/a21443df-4caf-4fde-9840-b419e9d966e8" />

---

## Prerequisites Satisfied

- **AWS Account** with permissions for EKS, IAM, S3, AMP, and AMG.
- **Amazon EKS Cluster**: Existing cluster (`my-cluster`).
- **Amazon Managed Grafana (AMG) Workspace**: Created and configured (`g-336cdb9361`).
- **Amazon Managed Service for Prometheus (AMP) Workspace**: Existing workspace (`ws-99f95003-d683-45bb-b66a-27cd242c79e3`).
- **S3 Bucket for Terraform State**: Used `johns-account-terraform-state`.
- **Terraform Installed**: Version 1.7.5, with provider version management as needed.

---

## What Was Deployed

### Monitoring Add-ons and Integrations

- **Prometheus Server** (via Helm) for metrics collection.
- **AMP Remote Write** configuration for sending metrics to AMP.
- **AMG Integration**:
  - Service account and API key for automation.
  - Pre-configured dashboards and data sources.
- **Kube State Metrics** (via Helm) for Kubernetes object metrics.
- **Node Exporter** (via Helm) for node-level metrics.
- **Alertmanager** (via Helm) for alerting.
- **External Secrets** (via Helm) for secret management.
- **Amazon CloudWatch Observability Add-on** for enhanced logging and metrics.

### IAM and Security

- **IAM Roles and Policies** for Prometheus, Grafana, and add-ons (using IRSA).

### Dashboards and Alerts

- **Pre-built Grafana Dashboards** for EKS and Prometheus.
- **Prometheus Alerting Rules** for cluster health.

### Other Resources

- **Helm Releases** for all monitoring components.
- **RBAC** for secure access.
- **Terraform Outputs** for endpoints and resource IDs.

---

## Troubleshooting Journey

### 1. Variable Name Error

**Issue:**  
Used `$managed_grafana_workspace_id` (undefined) instead of `$WORKSPACE_ID` (defined as `g-336cdb9361`).

**Fix:**  
Always use the correct, defined variable:
```bash
export TF_VAR_grafana_api_key=$(aws grafana create-workspace-service-account-token \
  --workspace-id $WORKSPACE_ID \
  --name "grafana-operator-key-$(date +%s)" \
  --seconds-to-live 7200 \
  --service-account-id $GRAFANA_SA_ID \
  --query 'serviceAccountToken.key' \
  --output text)

  2. AWS CloudShell Disk Space Limitations
Issue:
CloudShell home directory is limited (~1GB), causing "no space left on device" errors during terraform init.

Fix:
Move the project to /tmp for more space:

cp -r ~/terraform-eks-monitoring /tmp/
cd /tmp/terraform-eks-monitoring/eks-monitoring

3. Helm Provider Version Compatibility
Issue:
Syntax mismatch between Terraform config and Helm provider version.

Fix:
Constrain Helm provider to a compatible version and use the correct syntax:

# versions.tf
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15.0"
    }
  }
}

# main.tf
provider "helm" {
  kubernetes {
    host                   = local.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

4. Environment Variable Management
Issue:
Variables not persisting between directory changes.

Fix:
Re-export all variables after moving directories.

Final Results
Terraform Plan: 34 resources to add, 0 to change, 0 to destroy.
Outputs: EKS cluster ID and version, Prometheus workspace endpoint and ID, region.
Warning: Only deprecated attribute warnings (non-blocking).
Deployment: Complete EKS monitoring stack with Prometheus, Grafana, dashboards, alerts, and secure IAM integration.

Key Lessons Learned
Always use defined and correct variable names.
Be aware of AWS CloudShell disk space limits; use /tmp for large operations.
Match provider versions with configuration syntax.
Re-export environment variables after changing directories.
Read error messages carefully—they often point directly to the root cause.
References
AWS Managed Grafana EKS Monitoring Solution
AWS Observability Terraform Modules
This document demonstrates hands-on experience with AWS EKS, Prometheus, Grafana, and Terraform, including troubleshooting and best practices for cloud-native monitoring deployments.



