### Pod Resources and Scheduling Behavior

**Introduction**: </br>
In this scenario, you’ll explore how Kubernetes schedules Pods based on resource requests and limits, and how these affect whether your workloads can run successfully across the cluster.

**Scenario**: </br>
You are working in a cluster with two nodes: `controlplane` and `node01`.
Your manager has provided a YAML Deployment named `heavy-deployment` that runs **3 replicas** of a container designed to handle large datasets and intensive processing workloads.

After applying the manifest, only two Pods **start successfully**, while the third Pod remains **pending**. Your task is to analyze why the Pod cannot be scheduled and adjust the resource configuration to ensure that all three Pods can run simultaneously, without affecting cluster stability.

Press **Next** to begin investigating the scheduling issue.
