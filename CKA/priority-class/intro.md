### PriorityClass Scheduling and Pod Preemption

**Introduction**  
In this exercise, you will work with Kubernetes scheduling and resource management.  
You’ll create a new **PriorityClass**, deploy multiple pods that use it, and observe how Kubernetes preempts lower-priority pods when node resources become constrained.

Tasks:

- Define a new **PriorityClass** with a value that fits between existing priority levels.
- Deploy a **Deployment** using this new PriorityClass to simulate scheduling pressure.
- Verify which low-priority pods are **preempted** when higher-priority workloads are scheduled.

Note:

- Inspect preemption outcomes to learn how priority influences scheduling.

Press **Next** to begin.
