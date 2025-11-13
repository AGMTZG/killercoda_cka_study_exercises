### Calculate Safe Memory Requests and Limits

Since the Deployment requests **1.5 GB** per Pod and we have two nodes with **2 GB** each, one Pod is **scheduled** on each node. This leaves only **0.5 GB** free per node, which is insufficient to schedule the third Pod, so it remains **pending**.

There are two possible approaches: 
- Reduce the number of replicas.
- Adjust the memory requests for each Pod to ensure all **3 replicas** can be scheduled.

Since your manager asked you not to reduce the number of replicas, the only option is to adjust the memory requests per Pod.
So, we need to determine the maximum memory request that can be allocated on the node. 

```bash
Each node has:
cpu: 1 = 1000m
memory: = 2,098018646240234375Gi (total memory of the node)

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
# We divide the maximum allocatable memory (in Mi) by the three replicas. Since the problem does not specify that
# we must use only one node, we can consider both nodes. Otherwise, we would need a node affinity.
# We can infer that one node will host 2 Pods while the other node will host 1 Pod.
# To perform the calculations, we should use the allocatable memory, since that represents the total memory available for pods:

2097532Ki |  1 Mi     =   2097532 / 1024  =  2.048,37109375Mi
            1024Ki

2.048,37109375Mi  / 2 (number of replicas) = 1.024,185546875Mi (maximum request per replica)

# To avoid potential issues—because a Pod could exceed its allocated memory—we should not set the exact value of
# 1.024,185546875Mi per Pod. Instead, reduce it by 5–10 % as a safety margin.
# We will apply a 10 % reduction to this value, resulting in a safer memory allocation of ≈ 921,7669921875 Mi
# per Pod.

1.024,185546875 * .90 = 921,7669921875 Mi per pod
```
</p>
</details>
