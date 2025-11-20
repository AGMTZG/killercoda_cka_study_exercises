### Create a Monitoring Namespace and Add the Kube Prometheus Stack Helm Repository

Before installing the Prometheus Operator, we need to prepare our Kubernetes cluster. This includes creating a dedicated namespace for monitoring and adding the Helm repository that contains the **Kube Prometheus Stack** chart. This stack includes Prometheus, Alertmanager, node-exporter, and other essential monitoring components.


Tasks:
- Create a namespace called `monitoring` to keep all monitoring resources organized.
- Add the Prometheus community Helm repository, making sure to register it under the name `prometheus-community`, using the URL below, and then update your local chart index.

```bash
https://prometheus-community.github.io/helm-charts
```

- Install the **Kube Prometheus Stack** by selecting the chart `kube-prometheus-stack` from the `prometheus-community` repository, and deploy it under the release name `prometheus` in the `monitoring` namespace.
- Verify that the Prometheus pods are running correctly.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create the monitoring namespace
kubectl create ns monitoring

# Add the prometheus community helm repository to your chart list
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update your chart list
helm repo update

# Search for Kube Prometheus Stack in the repository
helm search repo prometheus-community | grep -i kube-prometheus-stack

# Install the operator
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack

# Check if pods are ready
kubectl get pods -n monitoring
```

</p>
</details>
