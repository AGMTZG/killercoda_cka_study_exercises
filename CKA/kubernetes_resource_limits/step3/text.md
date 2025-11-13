### Calculate Safe Memory Requests and Limits

Since the Deployment requests **1.5 GB** per Pod and we have two nodes with **2 GB** each, one Pod is **scheduled** on each node. This leaves only **0.5 GB** free per node, which is insufficient to schedule the third Pod, so it remains **pending**.

There are two possible approaches: 
- Reduce the number of replicas.
- Adjust the memory requests for each Pod to ensure all **3 replicas** can be scheduled.

Since your manager asked you not to reduce the number of replicas, the only option is to adjust the memory requests per Pod.
So, we need to determine the maximum memory request that can be allocated on the node. 

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

# To avoid resource pressure on the node, memory requests should leave enough room for system components and normal workload variation.
# Reducing the calculated value by ~30% gives:

1.024,1875 * .70 = 716,93125 Mi per pod
```
</p>
</details>
