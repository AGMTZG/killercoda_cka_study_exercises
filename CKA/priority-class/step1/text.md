### Create a new PriorityClass

The cluster currently hosts multiple workloads assigned to different **PriorityClasses**: `nebula-phase`, `drift-sequence`, `echo-frame`, `pulse-node`, and `shade-pattern`.
Each class defines how important its workloads are when Kubernetes selects which pods should be scheduled or replaced during resource contention.

You’ve been tasked with introducing a new scheduling tier that fits precisely between two existing priority levels.

Your objectives:

- Define a new **PriorityClass** named `signal-frame`. Its numeric value must be greater than the class ranked below intermediate, but lower than the group of mid-tier priorities.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, list all existing PriorityClasses in the cluster
kubectl get pc

# However, to sort them by their numeric value (from highest to lowest), use:
kubectl get priorityclass --no-headers -o custom-columns=NAME:.metadata.name,VALUE:.value | sort -k2 -n -r

# Example output:
system-node-critical      2000001000
system-cluster-critical   2000000000
nebula-phase              100000
drift-sequence            50000
echo-frame                10000
pulse-node                1000
shade-pattern             500

# From this output, we can observe that the lower-tier priorities fall between 500 and 1000. To define a new class that fits between these values, we can assign it a numeric value greater than 500 but lower than 1000.
# Priority class
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: signal-frame
value: 700
globalDefault: false
preemptionPolicy: PreemptLowerPriority
```

</p>
</details>
