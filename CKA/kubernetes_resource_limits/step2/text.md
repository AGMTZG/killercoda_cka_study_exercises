### Check Node Resource Capacity

In this step, we will inspect the available resources on each node in a Kubernetes cluster. Understanding **node capacity** and **allocatable resources** is crucial for diagnosing why some Pods might remain in a Pending state.

Tasks:
- List all nodes in the cluster to see their status and roles.
- Describe each node to examine both the **Capacity** and **Allocatable** sections.
- Analyze memory and **CPU** values to understand the limits for scheduling Pods.
- Convert memory units from **Ki** to **Mi** for easier interpretation, which helps in planning resource requests for your Pods.

The node reports memory in **Ki** (Kibibytes), so we need to convert it to **Mi** (Mebibytes) when comparing with Pod resource requests and limits.

```bash
heavy-deployment pods:
Limits:
      cpu:     200m
      memory:  1536Mi
Requests:
      cpu:        100m
      memory:     1536Mi
```

Note: The **capacity** section shows the total hardware resources of the node and the **allocatable** section shows the resources available for Pods after Kubernetes reserves some **memory** and **CPU** for system processes.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, verify the resource capacity of both nodes in the cluster:
kubectl get nodes

NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   19d   v1.33.2
node01         Ready    <none>          19d   v1.33.2

# You can check the memory and cpu allocation by checking the capacity and allocation section:
kubectl describe node controlplane
kubectl describe node node01

Both display this:
Capacity:
  cpu:                1
  ephemeral-storage:  19221248Ki
  hugepages-2Mi:      0
  memory:             2199932Ki
  pods:               110
Allocatable:
  cpu:                1
  ephemeral-storage:  18698430040
  hugepages-2Mi:      0
  memory:             2097532Ki
  pods:               110

# The difference between capacity and allocatable memory indicates that the node
# has already reserved some memory for the kubelet and other internal system processes.
# The allocatable section indicates the portion of node resources that can be allocated to Pods, while the capacity
# represents the total maximum resources available on the node.
# For easier reading, convert Ki to Mi for calculations. If you want to see the total memory in GiB,
# you can convert Mi to Gi.

2199932Ki |   1Mi   = 2199932 / 1024  =  2.148,37109375Mi
             1024Ki

2.148,37109375Mi |  1Gi    = 2.148,37109375 / 1024  = 2,098018646240234375Gi
                   1024Mi


# Therefore, we can confirm that each node has:
cpu: 1 = 1000m
memory: = 2,098018646240234375Gi (total memory of the node)
```

</p>
</details>
