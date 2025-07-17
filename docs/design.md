#cluster config snippet

<img width="706" height="586" alt="image" src="https://github.com/user-attachments/assets/2c8011c0-af71-4d62-8490-bda5cccc6935" />


# ascii diagram    

<img width="301" height="218" alt="image" src="https://github.com/user-attachments/assets/791d420e-6cfd-46af-be39-a1c725d146b8" />

#screenshot of prometheus setup on t3 small instance

<img width="1070" height="794" alt="image" src="https://github.com/user-attachments/assets/d8b06f91-8dcc-4a14-8929-7b21b1d21d4e" />


# confirm prom-example-monitor demo app is in "UP" status

<img width="1074" height="802" alt="image" src="https://github.com/user-attachments/assets/8ad3b913-2b77-43b9-b929-bddc0abce038" />

# sample query, output confirms Prometheus is actively scraping metrics — both from Prometheus instance itself and from the Node Exporter. Those promhttp_metric_handler_requests_total entries are HTTP server metrics — great for system-level observability.

<img width="1067" height="800" alt="image" src="https://github.com/user-attachments/assets/ee4d232a-0802-43b9-b5a5-88b595fe296b" />

#Grafana

<img width="1025" height="1189" alt="image" src="https://github.com/user-attachments/assets/a29ad02b-9214-40d3-9b47-07ed9b2594da" />


#example dashboard

<img width="1070" height="1758" alt="image" src="https://github.com/user-attachments/assets/214910ad-c4d2-4248-8214-b9e84cf0e601" />

#deploying again as terraform using https://aws-observability.github.io/terraform-aws-observability-accelerator/helpers/managed-grafana/

<img width="1912" height="1015" alt="image" src="https://github.com/user-attachments/assets/2bc44656-026c-4036-b9ff-641a70a59bc2" />

#screenshot of grafana workspace deployed via terraform

<img width="1910" height="929" alt="image" src="https://github.com/user-attachments/assets/e80b529a-eaa2-470b-9586-89ba3f99baa0" />

#This demo showcases a fully automated observability stack using Terraform to provision AWS resources, Amazon Managed Prometheus, and Amazon Managed Grafana. The Terraform configuration creates all required infrastructure, including a Prometheus workspace, IAM roles, a Grafana workspace, and API keys. It also sets up a Grafana TestData data source and deploys a custom dashboard with a variety of panels (time series, stat, gauge, bar gauge, table, and logs), each configured to display sample data for demonstration purposes. This setup illustrates best practices for infrastructure-as-code, cloud-native monitoring, and dashboard automation, making it easy to demonstrate Grafana’s visualization capabilities even without live production data.
<img width="1074" height="1113" alt="image" src="https://github.com/user-attachments/assets/bc0afea3-a081-4c12-9f5d-bbc2377e2b52" />


#destroying to avoid cost

<img width="1907" height="717" alt="image" src="https://github.com/user-attachments/assets/0e720411-eed4-4d83-bb6a-51f432515f03" />

#creating another demo with an EKS cluster, amazon managed prometheus to scrape metrics, and amazon managed grafana with dashboard



#eks cluster created using: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

<img width="1894" height="901" alt="image" src="https://github.com/user-attachments/assets/2fa9a754-6585-439b-bf97-3176ae9eefd5" />

#grafana created using https://docs.aws.amazon.com/grafana/latest/userguide/AMG-create-workspace.html

<img width="1878" height="968" alt="image" src="https://github.com/user-attachments/assets/20349fc1-ee47-4b29-830a-e0cad346ac39" />


#prometheus created using https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-create-workspace.html

<img width="1882" height="522" alt="image" src="https://github.com/user-attachments/assets/0b2a74d1-0cc0-4e43-a31f-2e83ae1be142" />


#solution deployed via terraform using guide https://docs.aws.amazon.com/grafana/latest/userguide/solution-eks.html#solution-eks-about




