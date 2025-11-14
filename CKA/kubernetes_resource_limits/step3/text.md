### Calculate Safe Memory Requests and Limits

Since the Deployment requests **1.5 GB** of memory per Pod, and we have one node with **2 GB** and another with **1.8 GB**, only one Pod can be scheduled on each node. This leaves very little free memory per node, which is insufficient to accommodate the **third** Pod, causing it to remain in a **Pending** state.
Since your manager asked you not to reduce the number of replicas, the only option is to adjust the memory requests per Pod. So, we need to determine the maximum memory request that can be allocated on the node.
We always schedule Pods on the node with the most **available memory**, so with this context:

Your tasks: 
- Reduce the number of replicas.
- Adjust the memory requests for each Pod to ensure all **3 replicas** can be scheduled.


```bash
# Controlplane available memory:
2,048.375 Mi

# Node01 available memory:
1.803,375 Mi

heavy-deployment pods:
Limits:
      cpu:     200m
      memory:  1536Mi
Requests:
      cpu:        100m
      memory:     1536Mi
```

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We divide the maximum allocatable memory (in Mi) by the three replicas.
# Since the problem does not require using a specific node, we can consider both nodes.
# Keep in mind that in real production environments, the control plane cannot be treated as a worker node.
# We can infer that one node will host 2 Pods while the other node will host 1 Pod.
# We will use the control plane node because it has the most available memory, so this node will run 2 Pods, while the other node will host only 1 Pod.

2,048.375Mi  / 2 (number of replicas) = 1.024,1875 Mi (maximum limit per replica)

# The per-replica value is only a theoretical maximum. Real usage varies, so pods need a safety margin.
# Reduce the value by 10%, 20%, or 30% depending on how bursty the workload is.
# Example using a 30% reduction:

1.024,1875 * .70 = 716,93125 Mi per pod
```
</p>
</details>
