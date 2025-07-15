#cluster config snippet
# eksctl config
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: prometheus-poc
  region: us-east-1
  version: "1.26"
managedNodeGroups:
  - name: ng-small
    instanceType: t3.small     # ~2 vCPU / 2 GiB RAM
    desiredCapacity: 1
    minSize: 1
    maxSize: 1
    labels: { role: worker }
    ssh:
      allow: false

# ascii diagram    

<img width="301" height="218" alt="image" src="https://github.com/user-attachments/assets/791d420e-6cfd-46af-be39-a1c725d146b8" />

#screenshot of prometheus setup on t3 small instance
<img width="1070" height="794" alt="image" src="https://github.com/user-attachments/assets/d8b06f91-8dcc-4a14-8929-7b21b1d21d4e" />
