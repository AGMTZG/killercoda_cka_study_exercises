### Deploy an application using the new PriorityClass and verify preempted pods

With the new scheduling tier `signal-frame` in place, it’s time to deploy an application that takes advantage of it.
This step demonstrates how Kubernetes prioritizes workloads when the cluster experiences resource pressure.

When node resources tighten, the Kubernetes scheduler relies on each pod’s **PriorityClass** value to determine which workloads should stay running and which ones can be replaced to make room for higher-priority tasks.
By assigning your new deployment the `signal-frame` class, you’ll observe how higher-priority workloads preempt lower-tier ones to maintain system stability.

Your task:

- Create a new **Deployment** named `signal-deploy` that uses the `signal-frame` PriorityClass.

- Configure it with **3 replicas** of an **NGINX** container.

- Each container should request **200Mi** of memory and set a limit of **300Mi**.

- After deploying, watch the scheduler’s behavior and identify whether any lower-priority pods are replaced to allow the new replicas to start.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create the deployment manifest
apiVersion: apps/v1
kind: Deployment
metadata:
  name: signal-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: signal-deploy
  template:
    metadata:
      labels:
        app: signal-deploy
    spec:
      priorityClassName: signal-frame
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: 200Mi
          limits:
            memory: 300Mi

# Verify that the deployment and its pods were created successfully
kubectl get deploy,pods -o wide

# Check which PriorityClass was assigned to each pod
kubectl get pod -l app=signal-deploy -o custom-columns=NAME:.metadata.name,PRIORITYCLASS:.spec.priorityClassName

# You can inspect the cluster events to see the preempted pod.
kubectl get events --sort-by=.lastTimestamp

Example:
7m36s       Normal    Preempted                 pod/pod-shade                         Preempted by pod 118f4e40-cd56-4435-8913-8b6bb225d786 on node controlplane
```

</p>
</details>
