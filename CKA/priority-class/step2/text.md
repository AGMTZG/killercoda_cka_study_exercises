### Deploy an application using the new PriorityClass and verify evicted pods

With the new scheduling tier `signal-frame` in place, it’s time to deploy an application that takes advantage of it.
This step demonstrates how Kubernetes prioritizes workloads when the cluster experiences resource pressure.

When node resources become scarce, the Kubernetes scheduler evaluates each pod’s PriorityClass value to determine which workloads should remain active and which can be safely evicted.
By assigning your new deployment the `signal-frame` class, you’ll observe how higher-priority workloads preempt lower-tier ones to maintain system stability.

Your task:

- Create a new **Deployment** named `signal-deploy` that uses the `signal-frame` PriorityClass.

- Configure it with **3 replicas** of an **NGINX** container.

- Each container should request **200Mi** of memory and set a limit of **300Mi**.

- After deploying, monitor scheduling activity and note whether any lower-priority pods are evicted as new replicas are scheduled.

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
  priorityClass: signal-frame
  replicas: 3
  selector:
    matchLabels:
      app: signal-deploy
  template:
    metadata:
      labels:
        app: signal-deploy
    spec:
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

# You can check evicted pods with this command
kubectl get pods --field-selector=status.phase=Failed | grep Evicted || echo "No evictions detected yet."
```

</p>
</details>
