### Inspect Pod Scheduling Issues

In this step, you’ll troubleshoot a common production scenario where Pods remain in a Pending state due to resource constraints.

In production, it’s common to encounter situations where some Pods cannot be scheduled because nodes don’t have enough CPU or memory. The goal here is to get all three Pods of your `heavy-deployment` running simultaneously. You will also learn how to investigate resource-related scheduling issues.

Tasks:

Task:

- Inspect the Deployment heavy-deployment to identify which Pods are running and which are Pending.

- Describe any Pending Pod to view the scheduling events and understand why it cannot be scheduled.

- Check the CPU and memory requests and limits for each Pod.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Check the deployment status
kubectl get deployment

# Example
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
heavy-deployment   2/3     3            2           20s

# List all Pods associated with the deployment
kubectl get deployment,pods | grep heavy-deployment

# Example
pod/heavy-deployment-xxxxxx-xxxx   1/1     Running   0          118s
pod/heavy-deployment-xxxxxx-xxxx   1/1     Running   0          118s
pod/heavy-deployment-xxxxxx-xxxx   0/1     Pending   0          118s
deployment.apps/heavy-deployment   2/3     3            2           118s

# Describe the pods in pending state to investigate the reason
kubectl describe po heavy-deployment-xxxxxx-xxxx

# Example of limits and requests
Limits:
      cpu:     200m
      memory:  1536Mi
    Requests:
      cpu:        100m
      memory:     1536Mi

# Example output from events section
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  31s   default-scheduler  0/2 nodes are available: 1 Insufficient memory, 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. no new claims to deallocate, preemption: 0/2 nodes are available: 1 No preemption victims found for incoming pod, 1 Preemption is not helpful for scheduling.


```

</p>
</details>
