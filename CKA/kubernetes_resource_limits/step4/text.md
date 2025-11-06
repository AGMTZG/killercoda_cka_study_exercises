### Update Deployment and Verify

In this step, you will update the Deployment with the optimized memory requests and limits calculated in the previous step. The goal is to ensure that all three Pods are scheduled and running simultaneously without exceeding the available node resources.

Tasks:

- Edit the deploy.yaml file located in the home folder to update the resources.requests and resources.limits for the container.
- Apply the updated Deployment to the cluster.
- Verify that all three Pods are running by checking the Deployment and Pod status.

Observe how Kubernetes schedules Pods correctly when resources are properly allocated, maintaining cluster stability.Observe how Kubernetes schedules Pods when resources are adjusted properly, ensuring the cluster remains stable.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# With this, we should modify the requests and the limits of the deployment
# deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: heavy-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: heavy-deployment
  template:
    metadata:
      labels:
        app: heavy-deployment
    spec:
      containers:
      - name: memory-hog
        image: alpine:latest
        command: ["sh", "-c"]
        args:
          - |
            echo "eating memory...";
            MEM="";
            while true; do
              MEM="$MEM$(head -c 500M </dev/zero)";
              sleep 2;
            done
        resources:
          requests:
            memory: "922Mi"
            cpu: "100m"
          limits:
            memory: "950Mi"
            cpu: "200m"

# A memory limit of 950 Mi is applied to accommodate potential usage spikes.
# We apply the new deployment and it should work!

kubectl get deploy -w
```

</p>
</details>
