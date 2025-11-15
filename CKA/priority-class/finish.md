Well done! 

You’ve explored how Kubernetes uses **PriorityClass** to influence scheduling behavior when resources are limited. By defining and applying custom priority levels, you observed how the scheduler decides which workloads stay running and which ones get preempted to make room for higher-priority pods.

In this exercise, you learned how to:

- Create and register new **PriorityClass** objects.

- See how scheduling decisions shift based on pod priority.

- Observe **preemption** when higher-priority workloads require node capacity.

- Inspect and verify priority assignments across running pods.

**Important**

It’s important to recognize that **preempt** and **evicted** refer to different behaviors in Kubernetes:

**Preempt**:
The scheduler terminates a lower-priority pod to free space so a higher-priority pod can be scheduled.

**Evicted**:
The kubelet removes a running pod because the node runs out of resources (memory, disk, etc.), regardless of priority.

Understanding this distinction helps you reason more clearly about why pods disappear and who is responsible(the scheduler or the kubelet).

You solved this challenge!
