### Create a Deployment and PriorityClass to Trigger Pod Eviction

**Introduction**  
In this exercise, you will work with Kubernetes scheduling and resource management.  
You’ll create a new `PriorityClass`, deploy multiple pods using it, and observe how Kubernetes handles pod eviction when node resources become limited.

Tasks:

- Define a new `PriorityClass` with a value that fits between existing priority levels.
- Deploy a `Deployment` using this new class to simulate scheduling pressure.
- Store an audit command that identifies intermediate priority classes.
- Verify which low-priority pods are evicted once higher-priority workloads are scheduled.

Note:

- Review the eviction results carefully to understand scheduling priorities.

Press **Next** to begin.
