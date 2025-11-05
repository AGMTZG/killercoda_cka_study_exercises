### Verify the Gateway Controller and Create the Gateway Resource

After the environment finishes initializing, verify that the NGINX Gateway Controller is installed and accepted by Kubernetes. Then, create a Gateway resource named my-gateway that defines two listeners — http-app and http-orders — corresponding to the application and orders domains.
The http-app listener will handle requests for app.company.local, while http-orders will handle requests for orders.company.local, both listening on port 80

|Host                  | Path        | Backend Service |
|----------------------|-------------|-----------------|
|app.company.local     |  /	         | web-app         |
|app.company.local	   |  /dashboard | dashboard-app   |
|orders.company.local  |  /          | orders-app      |
|orders.company.local  |  /reports   | reports-app     |



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
