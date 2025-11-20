### Access the Prometheus Pod and Verify Metrics Exposure

Now that Prometheus is installed, the RBAC permissions are configured, and your PodMonitor is deployed, it’s time to confirm that Prometheus is actually discovering and scraping the Nginx Pod you exposed.

Prometheus runs inside a **StatefulSet**, and its pod names follow a predictable pattern. To verify configuration, you will:

- Identify the name of the Prometheus pod and its port. The pod is sometimes listed as `prometheus-prometheus-kube-prometheus-prometheus-0`.

- Open an interactive shell inside it.

- Query the Prometheus HTTP API to confirm that your PodMonitor `nginx-monitor` is detected and that metrics scraping is active.

This ensures that Prometheus Operator has successfully registered your monitoring resource.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Identify the Prometheus server pod and verify its ports
kubectl get pods -n monitoring
kubectl describe pod <prometheus-pod-name> -n monitoring | grep -i port

# Access the Prometheus server container
kubectl exec -n monitoring -it <prometheus-pod-name> -- sh

# Query the Prometheus HTTP API to verify discovered scrape targets
wget -qO- http://localhost:9090/api/v1/targets | head
wget -qO- http://localhost:9090/api/v1/targets | grep -i nginx-monitor

# If the PodMonitor appears in the output, your configuration is working.
```

</p>
</details>
