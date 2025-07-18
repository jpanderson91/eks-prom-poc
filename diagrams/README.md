# AWS EKS Monitoring Architecture Diagrams

This directory contains professional architecture diagrams converted from ASCII art to Mermaid diagrams for better visualization.

## 📊 Available Diagrams

1. **[Main Architecture Overview](#main-architecture-overview)** - Complete EKS monitoring platform
2. **[Terraform Workflow](#terraform-workflow)** - Infrastructure automation flow
3. **[Monitoring Dashboard Layout](#monitoring-dashboard-layout)** - Grafana dashboard structure
4. **[Prometheus Targets](#prometheus-targets)** - Metrics collection endpoints

---

## 🏗️ Main Architecture Overview

### **AWS EKS Monitoring Platform**

```mermaid
graph TB
    subgraph "AWS EKS Monitoring Platform"
        subgraph "EKS Cluster"
            Node1["🖥️ Node 1<br/>ip-192-168-204-164"]
            Node2["🖥️ Node 2<br/>ip-192-168-3-51"]
            
            subgraph "Pods"
                Pod1["🔄 prom-example<br/>/metrics"]
                Pod2["🔄 node-exporter<br/>/metrics"]
                Pod3["🔄 kube-state-metrics<br/>/metrics"]
            end
        end
        
        subgraph "Amazon Managed Prometheus (AMP)"
            AMP["📊 Prometheus Workspace<br/>ws-99f95003-d683-45bb-b66a-27cd242c79e3"]
            Scraper["🔍 Prometheus Scraper<br/>Active Collection"]
            Recording["📈 Recording Rules<br/>Data Aggregation"]
            AlertRules["🚨 Alert Rules<br/>Cluster Health"]
        end
        
        subgraph "Amazon Managed Grafana (AMG)"
            AMG["📈 Grafana Workspace<br/>g-336cdb9361"]
            Dashboards["📊 Dashboards<br/>• EKS Overview<br/>• Node Metrics<br/>• Pod Performance<br/>• Application Health"]
            Alerting["🔔 Alerting<br/>• Critical Alerts<br/>• Notification Rules"]
        end
        
        subgraph "Terraform Automation Layer"
            TF1["🏗️ EKS Resources"]
            TF2["🔧 Prometheus Workspace"]
            TF3["📊 Grafana Workspace"]
            TF4["🔄 GitOps (Flux)<br/>Configuration Management"]
        end
    end
    
    %% Data Flow
    Pod1 --> Scraper
    Pod2 --> Scraper
    Pod3 --> Scraper
    Node1 --> Pod1
    Node1 --> Pod2
    Node2 --> Pod3
    
    Scraper --> AMP
    Recording --> AMP
    AlertRules --> AMP
    
    AMP --> AMG
    AMG --> Dashboards
    AMG --> Alerting
    
    TF1 --> Node1
    TF1 --> Node2
    TF2 --> AMP
    TF3 --> AMG
    TF4 --> AMG
    
    %% Styling
    classDef eksNode fill:#FF9900,stroke:#FF6600,stroke-width:2px,color:#fff
    classDef prometheus fill:#E6522C,stroke:#CC2936,stroke-width:2px,color:#fff
    classDef grafana fill:#F46800,stroke:#E55100,stroke-width:2px,color:#fff
    classDef terraform fill:#623CE4,stroke:#5A32D3,stroke-width:2px,color:#fff
    classDef pods fill:#326CE5,stroke:#1565C0,stroke-width:2px,color:#fff
    
    class Node1,Node2 eksNode
    class AMP,Scraper,Recording,AlertRules prometheus
    class AMG,Dashboards,Alerting grafana
    class TF1,TF2,TF3,TF4 terraform
    class Pod1,Pod2,Pod3 pods
```

---

## 🔄 Terraform Workflow

### **Infrastructure as Code Automation**

```mermaid
graph LR
    subgraph "Developer Workstation"
        Dev["👨‍💻 Developer"]
        YAML["📄 YAML Manifests"]
        TerraformCode["🏗️ Terraform Modules"]
        GitRepo["📚 Git Repository"]
    end
    
    subgraph "Terraform Automation"
        TFPlan["📋 Terraform Plan"]
        TFApply["🚀 Terraform Apply"]
        StateManagement["💾 State Management<br/>S3 Backend"]
        Validation["✅ Validation & Testing"]
    end
    
    subgraph "AWS Services"
        subgraph "EKS Cluster"
            EKSNodes["🖥️ EKS Nodes"]
            EKSPods["🔄 Application Pods"]
        end
        
        subgraph "Monitoring"
            PrometheusWS["📊 Prometheus Workspace<br/>(AMP)"]
            GrafanaWS["📈 Grafana Workspace<br/>(AMG)"]
        end
        
        subgraph "Security"
            IAMRoles["🛡️ IAM Roles"]
            IRSA["🔐 IRSA Integration"]
        end
    end
    
    subgraph "GitOps (Flux CD)"
        FluxController["⚙️ Flux Controller"]
        ConfigSync["🔄 Config Sync"]
        DashboardAutomation["📊 Dashboard Automation"]
    end
    
    %% Workflow
    Dev --> YAML
    Dev --> TerraformCode
    YAML --> GitRepo
    TerraformCode --> GitRepo
    
    GitRepo --> TFPlan
    TFPlan --> TFApply
    TFApply --> StateManagement
    TFApply --> Validation
    
    TFApply --> EKSNodes
    TFApply --> PrometheusWS
    TFApply --> GrafanaWS
    TFApply --> IAMRoles
    
    EKSNodes --> EKSPods
    IAMRoles --> IRSA
    IRSA --> EKSPods
    
    GitRepo --> FluxController
    FluxController --> ConfigSync
    ConfigSync --> DashboardAutomation
    DashboardAutomation --> GrafanaWS
    
    %% Styling
    classDef developer fill:#4CAF50,stroke:#388E3C,stroke-width:2px,color:#fff
    classDef terraform fill:#623CE4,stroke:#5A32D3,stroke-width:2px,color:#fff
    classDef aws fill:#FF9900,stroke:#FF6600,stroke-width:2px,color:#fff
    classDef gitops fill:#326CE5,stroke:#1565C0,stroke-width:2px,color:#fff
    
    class Dev,YAML,TerraformCode,GitRepo developer
    class TFPlan,TFApply,StateManagement,Validation terraform
    class EKSNodes,EKSPods,PrometheusWS,GrafanaWS,IAMRoles,IRSA aws
    class FluxController,ConfigSync,DashboardAutomation gitops
```

---

## 📊 Monitoring Dashboard Layout

### **Grafana Dashboard Structure**

```mermaid
graph TB
    subgraph "Grafana Dashboard View"
        subgraph "Row 1: Cluster Overview"
            ClusterStatus["📊 EKS Cluster Overview<br/>• Status: ✅ Healthy<br/>• Nodes: 2/2 Ready<br/>• Pods: 8/8 Ready<br/>• Uptime: 7h 23m"]
            
            NodeMetrics["📈 Node Metrics<br/>• CPU: 78%<br/>• Memory: 65%<br/>• Network: 45%<br/>• Disk: 32%"]
            
            AppHealth["🔍 Application Health<br/>• prom-example: UP<br/>• Response: 200ms<br/>• Requests: 1.2k/min"]
        end
        
        subgraph "Row 2: Detailed Metrics"
            PrometheusTargets["🎯 Prometheus Targets<br/>• ✅ node-exporter (2 targets)<br/>• ✅ prom-example (1 target)<br/>• ✅ kube-state (1 target)<br/>• Total: 2,847 metrics"]
            
            NodeExporter["🖥️ Node Exporter Details<br/>• Last Scrape: 2.3s ago<br/>• Duration: 45ms<br/>• Samples: 1,247"]
            
            StatusCodes["📊 HTTP Status Codes<br/>• 200: 89%<br/>• 404: 8%<br/>• 500: 3%"]
        end
        
        subgraph "Row 3: Performance"
            MemoryUsage["💾 Memory Usage<br/>65% of 2GB"]
            
            LoadAverage["⚡ Load Average<br/>• 1min: 0.75<br/>• 5min: 0.82<br/>• 15min: 0.68"]
            
            RequestRate["📈 Request Rate<br/>Time Series Graph"]
        end
    end
    
    %% Styling
    classDef overview fill:#2196F3,stroke:#1976D2,stroke-width:2px,color:#fff
    classDef metrics fill:#FF9800,stroke:#F57C00,stroke-width:2px,color:#fff
    classDef performance fill:#4CAF50,stroke:#388E3C,stroke-width:2px,color:#fff
    
    class ClusterStatus,NodeMetrics,AppHealth overview
    class PrometheusTargets,NodeExporter,StatusCodes metrics
    class MemoryUsage,LoadAverage,RequestRate performance
```

---

## 🎯 Prometheus Targets

### **Metrics Collection Endpoints**

```mermaid
graph TB
    subgraph "Prometheus Targets Status"
        subgraph "Application Targets"
            PromExample["📊 prom-example (1/1 up)<br/>http://prom-example:8080/metrics<br/>✅ UP • 2.3s ago • 45ms<br/>Labels: app=prom-example"]
        end
        
        subgraph "Infrastructure Targets"
            NodeExporter1["🖥️ node-exporter (2/2 up)<br/>http://192.168.1.100:9100/metrics<br/>✅ UP • 1.8s ago • 67ms"]
            
            NodeExporter2["🖥️ node-exporter<br/>http://192.168.1.101:9100/metrics<br/>✅ UP • 1.9s ago • 72ms<br/>Labels: job=node-exporter"]
        end
        
        subgraph "Kubernetes Targets"
            KubeState["☸️ kube-state-metrics (1/1 up)<br/>http://kube-state-metrics:8080/metrics<br/>✅ UP • 3.1s ago • 38ms<br/>Labels: app=kube-state-metrics"]
        end
        
        subgraph "Prometheus Internal"
            PrometheusServer["🔧 prometheus-server (1/1 up)<br/>http://prometheus-server:9090/metrics<br/>✅ UP • 0.8s ago • 12ms<br/>Labels: app=prometheus, component=server"]
        end
        
        subgraph "Summary"
            Summary["📈 Total Summary<br/>• Total Targets: 5<br/>• Up: 5 | Down: 0 | Unknown: 0<br/>• Total Samples: 2,847 metrics<br/>• Last Scrape Cycle: Complete"]
        end
    end
    
    %% Connections
    PromExample --> Summary
    NodeExporter1 --> Summary
    NodeExporter2 --> Summary
    KubeState --> Summary
    PrometheusServer --> Summary
    
    %% Styling
    classDef application fill:#FF5722,stroke:#D84315,stroke-width:2px,color:#fff
    classDef infrastructure fill:#607D8B,stroke:#455A64,stroke-width:2px,color:#fff
    classDef kubernetes fill:#326CE5,stroke:#1565C0,stroke-width:2px,color:#fff
    classDef prometheus fill:#E6522C,stroke:#CC2936,stroke-width:2px,color:#fff
    classDef summary fill:#4CAF50,stroke:#388E3C,stroke-width:2px,color:#fff
    
    class PromExample application
    class NodeExporter1,NodeExporter2 infrastructure
    class KubeState kubernetes
    class PrometheusServer prometheus
    class Summary summary
```

---

## 🚀 Terraform Deployment Flow

### **Infrastructure Deployment Process**

```mermaid
sequenceDiagram
    participant Dev as 👨‍💻 Developer
    participant Git as 📚 Git Repository
    participant TF as 🏗️ Terraform
    participant AWS as ☁️ AWS Services
    participant EKS as ☸️ EKS Cluster
    participant Monitor as 📊 Monitoring Stack
    
    Dev->>Git: 1. Push Terraform configuration
    Git->>TF: 2. terraform init
    TF->>TF: 3. Download providers
    TF->>AWS: 4. terraform plan
    AWS->>TF: 5. Return execution plan
    TF->>Dev: 6. Display: "34 resources to add"
    
    Dev->>TF: 7. terraform apply
    TF->>AWS: 8. Create IAM roles
    AWS->>TF: 9. ✅ Roles created
    TF->>AWS: 10. Create Prometheus workspace
    AWS->>TF: 11. ✅ AMP workspace active
    TF->>AWS: 12. Create Grafana workspace
    AWS->>TF: 13. ✅ AMG workspace active
    
    TF->>EKS: 14. Deploy monitoring components
    EKS->>Monitor: 15. Start Prometheus operator
    Monitor->>AWS: 16. Connect to AMP via remote_write
    AWS->>Monitor: 17. ✅ Metrics flowing
    
    TF->>Dev: 18. 🎉 Apply complete!<br/>34 resources added
    
    Note over Dev,Monitor: 🚀 SUCCESS: All monitoring infrastructure<br/>deployed and operational!
```

---

## 📱 How to Use These Diagrams

### **1. GitHub Integration**
- These Mermaid diagrams render automatically in GitHub README files
- Perfect for your portfolio repository
- No additional tools required

### **2. VS Code Preview**
- Install "Markdown Preview Mermaid Support" extension
- Open any `.md` file with these diagrams
- Click the preview button to see rendered diagrams

### **3. Export to Images**
- Use online tools like [Mermaid Live Editor](https://mermaid.live/)
- Copy/paste the code to generate PNG/SVG files
- Perfect for presentations or documentation

### **4. Customization**
- Easy to modify colors, shapes, and text
- Add or remove components as needed
- Maintain consistency with your actual architecture

---

## 🎨 Diagram Features

### **Visual Elements**
- ✅ **Professional Icons**: Emojis provide visual context
- ✅ **Color Coding**: Different colors for different service types
- ✅ **Clear Labels**: Descriptive text with real data
- ✅ **Logical Flow**: Arrows show data and control flow

### **Technical Accuracy**
- ✅ **Real Resource Names**: Matches your actual deployment
- ✅ **Correct Metrics**: Based on your documentation
- ✅ **AWS Services**: Proper service names and configurations
- ✅ **Kubernetes Integration**: Accurate pod and service relationships

---

*These diagrams provide a professional, visual representation of your EKS monitoring architecture that's perfect for portfolio presentation and technical documentation.*
