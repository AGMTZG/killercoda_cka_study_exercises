### Deploy a Monitoring Resource for an Nginx Pod

For Prometheus to collect metrics, you must define the correct monitoring resource. Kubernetes exposes several custom resources that the Prometheus Operator understands, and each one covers a different scenario.

Monitoring Resource Types

| Type               | What it monitors     | When to use                    |
| ------------------ | -------------------- | ------------------------------ |
| **ServiceMonitor** | Services → Pods      | When the app exposes a Service |
| **PodMonitor**     | Pods directly        | When the app has no Service    |
| **Probe**          | HTTP/TCP endpoints   | For external or health URLs    |
| **PrometheusRule** | Alerting rules       | For Alertmanager alerts        |

A **ServiceMonitor** relies on a Service selector, while a **PodMonitor** targets Pods directly. Probes are useful for checking external URLs, and PrometheusRule defines alert conditions.

Tasks:

- Deploy an **Nginx Pod** in the `default` namespace that exposes port `80`, uses the Pod name `nginx`, and sets the container port’s name field to `nginx`.

- You will create a **PodMonitor** named `nginx-monitor` in the namespace `monitoring`, labeled `release=prometheus`, which instructs Prometheus to scrape metrics directly from the Nginx Pod.

**Note**: Creating the monitoring resource may take a few moments. If you proceed immediately and see a validation error, it’s likely because the resource hasn’t fully started yet. Please wait a moment and try again.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, generate the base Pod manifest using dry-run
kubectl run nginx --image=nginx --port=80 --dry-run=client -o yaml > nginx.yaml

# After generating the file, edit nginx.yaml to include a named port
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    ports:
    - containerPort: 80
      name: nginx     # Named port required for PodMonitor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

# Then, create the PodMonitor that instructs Prometheus to scrape the Nginx pod
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: nginx-monitor
  namespace: monitoring
  labels:
    release: prometheus
spec:
  selector:
    matchLabels:
      run: nginx
  namespaceSelector:
    matchNames:
    - default
  podMetricsEndpoints:
  - port: nginx
```

</p>
</details>
