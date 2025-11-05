### Verify the Gateway Controller and Create the Gateway Resource

After the environment finishes initializing, verify that the NGINX Gateway Controller is installed and accepted by Kubernetes. After that, create a Gateway resource named my-gateway that defines listeners for the following endpoints.

|Host                  | Path        | Backend Service | Listeners name     | port | image |
|----------------------|-------------|-----------------|--------------------|------|-------|
|app.company.local     |  /	         | web-app         | http-app           | 80   | nginx |
|app.company.local	   |  /dashboard | dashboard-app   | http-app           | 80   | nginx |
|orders.company.local  |  /          | orders-app      | http-orders        | 80   | nginx |
|orders.company.local  |  /reports   | reports-app     | http-orders        | 80   | nginx |


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, check if the Gateway controller is installed and accepted by Kubernetes.
kubectl get gatewayclass

# If the Gateway controller is in the OK state, you can continue.
# Next, create the Gateway resource using the endpoints defined above.

apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http-app
    protocol: HTTP
    port: 80
    hostname: app.company.local
  - name: http-orders
    protocol: HTTP
    port: 80
    hostname: orders.company.local
```

</p>
</details>
