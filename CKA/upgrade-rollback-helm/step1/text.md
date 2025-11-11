### Deploy the chart to the cluster and verify the release, along with all associated pods and services

First, add and update the Bitnami Helm repository(https://charts.bitnami.com/bitnami). Then, deploy the Nginx chart (version 13.2.22) as `my-nginx-release` to the Kubernetes cluster using Helm.

This will create the initial release, generating all required Kubernetes resources, including deployments, services, and pods. Once deployed, you will verify that the application is running properly by checking pod statuses, reviewing the overall release status, and retrieving the manifests and chart notes created by Helm. The manifests(**manifest.yaml**), notes(**notes.txt**) and release status(**status.txt**) should be saved in `/opt/helm/nginx`

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Add the Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update the local Helm repository to get the latest charts
helm repo update

# Install the Nginx chart (version 13.2.22) as 'my-nginx-release' in the Kubernetes cluster
helm install my-nginx-release bitnami/nginx --version 13.2.22

# Check the status of Pods to verify that Nginx is running
kubectl get pods

# Create directory to store manifests, notes, and status
mkdir -p /opt/helm/nginx

# Display detailed status of the Helm release
helm status my-nginx-release > /opt/helm/nginx/status.txt

# Retrieve the complete manifest generated for the release and save it to /opt/helm/nginx/manifest.yaml
helm get manifest my-nginx-release > /opt/helm/nginx/manifest.yaml

# Retrieve any notes provided by the chart and save them to /opt/helm/nginx/notes.txt
helm get notes my-nginx-release > /opt/helm/nginx/notes.txt
```

</p>
</details>
