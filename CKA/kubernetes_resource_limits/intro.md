### Pod Resources and Scheduling Behavior

**Introduction**: </br>
In this scenario, you’ll explore how Kubernetes schedules Pods based on resource requests and limits, and how these affect whether your workloads can run successfully across the cluster.

**Scenario**: </br>
You are working in a cluster with two nodes: `controlplane` and `node01`.
Your manager has provided a YAML Deployment named `heavy-deployment` that runs **3 replicas** of a container, each configured with the following resource specifications:

```bash
resources:
  requests:
    memory: "1.5Gi"
    cpu: "100m"
  limits:
    memory: "1.5Gi"
    cpu: "200m"
```

After applying the manifest, only two Pods **start successfully**, while the third Pod remains **pending**. Your task is to analyze why the Pod cannot be scheduled and adjust the resource configuration to ensure that all three Pods can run simultaneously, without affecting cluster stability.

Press **Next** to begin investigating the scheduling issue.
