# architecture diagram + screenshots
  [ EKS Control Plane ]
           │
 ┌─────────┴─────────┐
 │   t3.small Node   │
 └──┬──────────┬─────┘
    │          │
[kube-prom] [Grafana]
    │          │
[Metrics DB] [Visuals/UI]
