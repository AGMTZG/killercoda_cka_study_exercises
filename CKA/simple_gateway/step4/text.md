### Create a Nginx Deployment with a ClusterIP Service

In this step, you will deploy a simple Nginx web server and expose it internally using a ClusterIP Service. This Service will allow other resources in your cluster, such as a Gateway, to route traffic to the Nginx pods.

**Tasks:**

1. Create a Deployment named `webapp` that runs Nginx with one replica, listening on port 80.
2. Expose the `webapp` Deployment with a ClusterIP Service on port 80, targeting port 80 on the pods.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
kubectl create deployment webapp --image=nginx --replicas=1 --port=80
kubectl expose deployment webapp --type=ClusterIP --port=80 --target-port=80
```

</p>
</details>
