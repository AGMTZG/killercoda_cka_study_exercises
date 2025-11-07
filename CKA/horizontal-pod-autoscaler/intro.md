# Horizontal Pod Autoscaler (HPA)

The **Horizontal Pod Autoscaler (HPA)** automatically adjusts the number of pod replicas in a deployment or replica set based on resource utilization, such as CPU or memory usage.  
It helps ensure applications can handle variable workloads efficiently while minimizing resource waste.

The HPA monitors metrics from the **Kubernetes Metrics Server** or another monitoring source.  
When resource usage moves above or below the target threshold, the autoscaler changes the replica count accordingly:

- **High resource usage:** HPA scales **up** by adding more pods.  
- **Low resource usage:** HPA scales **down** to save resources.

This mechanism improves reliability, efficiency, and performance without manual intervention.

The **Metrics Server** will be available in the cluster to provide CPU utilization metrics required for scaling.  

Press **Next** to start configuring the Horizontal Pod Autoscaler.
