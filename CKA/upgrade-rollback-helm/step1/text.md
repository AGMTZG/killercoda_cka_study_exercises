### Deploy the chart to the cluster and verify the release, along with all associated pods and services

You will deploy the **Nginx** chart from the **Bitnami** Helm repository to create the initial release in your Kubernetes cluster. This deployment will generate all required resources, including deployments, services, and pods. After deployment, you will verify that the application is running correctly and save the generated manifests, notes, and release status for reference.

Tasks:

- Add the **Bitnami** Helm repository: `https://charts.bitnami.com/bitnami`.

- Update the **Helm repositories** to ensure the latest charts are available.

- Deploy the latest available Nginx chart as `my-nginx-release` using Helm.

- Verify that all pods are running and the application is functioning correctly and retrieve the release status, generated manifests and Helm notes.

- Save the **manifests** as `manifest.yaml` in `/opt/helm/nginx`.

- Save the **Helm notes** as `notes.txt` in `/opt/helm/nginx`.

- Save the **release status** as `status.txt` in `/opt/helm/nginx`.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Add the Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update the local Helm repository to get the latest charts
helm repo update

# Install the Nginx chart in the Kubernetes cluster
helm install my-nginx-release bitnami/nginx

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
