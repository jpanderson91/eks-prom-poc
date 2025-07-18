# Test Prometheus Targets Diagram

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
