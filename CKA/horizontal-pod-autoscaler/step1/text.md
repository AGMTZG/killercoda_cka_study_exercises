### Create and Configure the HPA

Your team recently noticed performance degradation and pod failures in the **production** namespace.  
The issue appeared during peak traffic hours — some `web-app` pods were being **evicted** because the namespace’s **ResourceQuota** was fully consumed.  

Currently, the `production` namespace restricts total CPU and memory usage to keep costs under control.  
However, the `web-app` deployment runs with **6 fixed replicas** and **static resource limits**, which causes it to exceed the quota when load increases.

Your task is to implement a **Horizontal Pod Autoscaler (HPA)** named `web-app` that scales the deployment dynamically based on CPU utilization.  
This approach allows Kubernetes to allocate resources only when needed, maintaining performance without breaching quota restrictions.

Requirements

- Review the deployment’s resource requests and limits using the Metrics Server.

- The HPA should maintain between 2 and 5 replicas.

- The target average CPU utilization should be 60%.

- The scaling behavior should:

- Allow scaling up with a maximum of 1 replica increase per 30 seconds.

- Allow scaling down with a maximum of 1 replica decrease per 1 minute.

- Stabilize scaling down for 2 minutes (meaning it will not scale down faster than this window).

- Ensure all pods initialize successfully and that the namespace quota is not exceeded.

Note: The Metrics Server might take a few moments to start. If you see the message “metrics API not available”, wait a bit and try again.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Check current CPU and memory metrics
kubectl top pods -n production
kubectl top nodes

# Create the Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app
  namespace: production
spec:
  scaleTargetRef:
    kind: Deployment
    name: web-app
    apiVersion: apps/v1
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
  behavior:
    scaleUp:
      policies:
      - type: Pods
        value: 1
        periodSeconds: 30
      stabilizationWindowSeconds: 0
    scaleDown:
      policies:
      - type: Pods
        value: 1
        periodSeconds: 60
      stabilizationWindowSeconds: 120

kubectl create -f hpa.yaml

# Verify HPA configuration and pod behavior
kubectl get hpa web-app -n production
kubectl describe hpa web-app -n production

# Check that all pods started and quota was not exceeded
kubectl get pods -n production
kubectl describe quota -n production
```

</p>
</details>
