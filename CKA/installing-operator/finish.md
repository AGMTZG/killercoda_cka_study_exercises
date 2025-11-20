Well done!

Great job! You deployed Prometheus, created the necessary RBAC permissions, added a PodMonitor, and verified that Prometheus is scraping your Nginx Pod.  
The raw `/api/v1/targets` output can be **hard to read**, which is exactly why **Grafana** exists.

Since the Kube Prometheus Stack already deployed Grafana, just follow these steps(You cannot use grafana ui in killercoda):

- Port-forward Grafana

```bash
kubectl port-forward service/prometheus-grafana -n monitoring 3000:80
```

- Get your Grafana admin credentials

```bash
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-user}" | base64 --decode
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

- Add Prometheus as a data source

1. Log in to Grafana

2. Go to Connections → Add new connection

3. Search for Prometheus

4. Add new data source

5. Set URL to:

```bash
http://localhost:9090
or
http://<prometheus-server-ip>:<port>
```

6. Click Save & Test

You're all set! Grafana will now display your Prometheus metrics in clean, visual dashboards.

You solved this challenge!
