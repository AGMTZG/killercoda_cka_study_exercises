### Check Node Resource Capacity

In this step, we will inspect the available resources on each node in a Kubernetes cluster. Understanding node **capacity** and **allocatable resources** is crucial for diagnosing why some Pods might remain in a **Pending** state. In the previous step, we observed that the pod from the `heavy-deployment` was failing because the replicas were consuming more memory than the node could handle, which prevented the scheduler from placing all pods successfully. With this context, we are now ready to investigate the resources available on the node.

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

# controlplane
Capacity:
  cpu:                1
  ephemeral-storage:  19221248Ki
  hugepages-2Mi:      0
  memory:             2199936Ki
  pods:               110
Allocatable:
  cpu:                1
  ephemeral-storage:  18698430040
  hugepages-2Mi:      0
  memory:             2097536Ki
  pods:               110


# controlplane, let’s calculate how much memory is reserved on the node

Capacity, this indicates the total memory of the node:

2199936 Ki  |   1Mi    = 2199936 / 1024 =  2,148.375 Mi
               1024Ki

Allocatable, this shows the amount of memory available for pods to use

2097536 Ki  |   1Mi    = 2097536 / 1024 =   2,048.375 Mi
               1024Ki

# For controlplane, 100Mi are being reserving for critical system components.


# We also check node01
kubectl describe node node01

# Node01
Capacity:
  cpu:                1
  ephemeral-storage:  19221248Ki
  hugepages-2Mi:      0
  memory:             1949056Ki
  pods:               110
Allocatable:
  cpu:                1
  ephemeral-storage:  18698430040
  hugepages-2Mi:      0
  memory:             1846656Ki
  pods:               110

# Capacity
1949056 Ki |  1Mi     = 1949056 / 1024 = 1,903.375 Mi
            1024 Ki

# Allocable
1846656 Ki |  1Mi     = 1846656 / 1024 = 1.803,375 Mi
            1024 Ki

# For node01, 100Mi are being reserving for critical system components.
```

</p>
</details>
