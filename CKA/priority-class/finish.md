Well done! 

You’ve successfully explored how Kubernetes uses `PriorityClass` objects to manage workload scheduling and eviction under resource constraints. By defining and applying custom priority levels, you observed how the scheduler determines which pods should remain active and which are evicted when resources become scarce.

Throughout this exercise, you learned:
- How to create and register new `PriorityClass` resources.  
- How pod scheduling decisions change based on assigned priorities.  
- How eviction occurs when higher-priority workloads need space on limited nodes.  
- How to inspect and verify the priorities of pods running in the cluster.  

Understanding these concepts is essential for maintaining a stable and efficient Kubernetes environment, especially when dealing with production workloads that compete for limited cluster resources.  

You solved this challenge!
