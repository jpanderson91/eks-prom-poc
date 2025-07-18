# eks-prom-poc

Deployed a self hosted version of an observability stack using prometheus and grafana initially (documented in docs/design.md.)

Deployed via terraform using https://aws-observability.github.io/terraform-aws-observability-accelerator/helpers/managed-grafana/ subsequently (screenshots also in docs/design.md)

# 📡 EKS Prometheus + Grafana Monitoring Stack

This project demonstrates how to deploy a fully functional observability stack on Amazon EKS using **Prometheus**, **Grafana**, and a sample app with **metrics exposed** for scraping and visualization. Both manual (kubectl + YAML) and automated (**Terraform**) provisioning methods are shown.

---

## 🗺️ Overview

This proof-of-concept sets up:

- A demo app (`prom-example`) that emits Prometheus-formatted metrics
- Prometheus for metric collection using the Prometheus Operator
- Grafana for querying and visualizing metrics via a custom dashboard
- Terraform modules to automate the deployment process on EKS

Screenshots are included to illustrate:
- Prometheus `/targets` showing active metric scrapes
- Grafana dashboards visualizing request rate, response codes, and app version

---

## ⚙️ Deployment Methods

### 🔧 Manual YAML

1. Deploy Prometheus, Grafana, and ServiceMonitors via YAML
2. Deploy the `prom-example` app and expose `/metrics`
3. Verify targets in Prometheus and create dashboard panels in Grafana

### 🛠️ Terraform

1. Apply infrastructure via `terraform apply`
2. Create necessary namespaces, deployments, services, and monitoring resources
3. Import Grafana dashboard for automatic visualization

---

## 🎯 Features

**🎨 Visual Architecture**:
```mermaid
graph TB
    subgraph "Self-Hosted EKS Monitoring Platform"
        subgraph "EKS Cluster"
            Node1["🖥️ Node 1<br/>ip-192-168-204-164"]
            Node2["🖥️ Node 2<br/>ip-192-168-3-51"]
            
            subgraph "Monitoring Pods"
                Pod1["🔄 prom-example<br/>/metrics"]
                Pod2["🔄 node-exporter<br/>/metrics"]
                Pod3["🔄 kube-state-metrics<br/>/metrics"]
            end
            
            subgraph "Prometheus Stack"
                Prometheus["📊 Prometheus Server<br/>prometheus-kube-prometheus-prometheus"]
                PVC["💾 PVC<br/>Data Persistence"]
                Service["🔗 Service<br/>prometheus-operated"]
            end
            
            subgraph "Grafana Stack"
                Grafana["📈 Grafana Server<br/>prometheus-grafana"]
                GrafanaService["🔗 Service<br/>prometheus-grafana"]
                ConfigMap["⚙️ ConfigMap<br/>Dashboard Config"]
            end
        end
        
        subgraph "External Services"
            LoadBalancer["🌐 LoadBalancer<br/>External Access"]
            NodePort["🔗 NodePort<br/>9090, 3000"]
        end
        
        subgraph "Configuration Management"
            ServiceMonitor["📋 ServiceMonitor<br/>Target Discovery"]
            PrometheusRule["📏 PrometheusRule<br/>Recording & Alerting"]
            Values["📄 values.yaml<br/>Helm Configuration"]
        end
    end
    
    %% Data Flow
    Pod1 --> ServiceMonitor
    Pod2 --> ServiceMonitor
    Pod3 --> ServiceMonitor
    Node1 --> Pod1
    Node1 --> Pod2
    Node2 --> Pod3
    
    ServiceMonitor --> Prometheus
    PrometheusRule --> Prometheus
    Prometheus --> PVC
    Service --> Prometheus
    
    Prometheus --> Grafana
    ConfigMap --> Grafana
    GrafanaService --> Grafana
    
    LoadBalancer --> NodePort
    NodePort --> Service
    NodePort --> GrafanaService
    
    Values --> ServiceMonitor
    Values --> PrometheusRule
    Values --> Prometheus
    Values --> Grafana
    
    %% Styling
    classDef eksNode fill:#FF9900,stroke:#FF6600,stroke-width:2px,color:#fff
    classDef prometheus fill:#E6522C,stroke:#CC2936,stroke-width:2px,color:#fff
    classDef grafana fill:#F46800,stroke:#E55100,stroke-width:2px,color:#fff
    classDef config fill:#4CAF50,stroke:#2E7D32,stroke-width:2px,color:#fff
    classDef pods fill:#326CE5,stroke:#1565C0,stroke-width:2px,color:#fff
    classDef external fill:#9C27B0,stroke:#7B1FA2,stroke-width:2px,color:#fff
    
    class Node1,Node2 eksNode
    class Prometheus,PVC,Service,PrometheusRule prometheus
    class Grafana,GrafanaService,ConfigMap grafana
    class ServiceMonitor,Values config
    class Pod1,Pod2,Pod3 pods
    class LoadBalancer,NodePort external
```

- ✅ Validated Prometheus targets with full metric ingestion
- ✅ Grafana dashboard with panels showing:
  - HTTP request rate
  - Response code breakdowns
  - Per-pod traffic stats
  - App version indicator
- ✅ Automated infrastructure creation via Terraform
- ✅ Screenshots for visual walkthrough

---

## 📝 To-Do & Optional Enhancements

- [ ] 🧠 Add CPU & memory usage panels using `container_*` metrics
- [ ] 🧹 Create a `cleanup.sh` script or Terraform destroy module
- [ ] 🎯 Add alerting rules in Prometheus for critical thresholds
- [ ] 📦 Wrap YAML into a Helm chart for reuse
- [ ] 📘 Document troubleshooting steps (e.g. scrape failures, port mismatches)
- [ ] 🐳 Package as a Docker Compose dev environment
- [ ] 📈 Export dashboard definitions as `.json` and attach in repo
- [ ] 📄 Create a walkthrough video or animation GIF for dashboard showcase
- [ ] 🔐 Add authentication for Grafana in production-grade setups

---

## 📷 Screenshots

Screenshots are available in the `/screenshots` folder, showcasing:
- Prometheus scrape targets
- Grafana visualizations
- Terraform-managed cluster resources

---

## 🤝 Contributing

Got tweaks, enhancements, or want to fork this into your own stack? Feel free to clone, adapt, and improve — just drop a star ⭐ if it helped.

---

## 📬 Contact

Built by [@jpanderson91](https://github.com/jpanderson91) — feel free to reach out for questions or collaboration ideas.
