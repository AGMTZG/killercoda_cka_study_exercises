### Create a Gateway

Gateways are the core entry point of the **Gateway API**, acting as the modern replacement for the traditional **Ingress** resource. While Ingress is limited in flexibility and configuration, Gateways allow for cleaner separation of responsibilities, stronger extensibility, and support for multiple listeners, protocols, and routing rules.

With a Gateway, you define how traffic enters your cluster, for example, which ports to listen on, which addresses to bind to, and which GatewayClass will handle the underlying routing logic (like NGINX Gateway Fabric).

In this step, you will create a simple non-TLS Gateway as a starting point. This will allow HTTP traffic to enter your cluster and route to your backend services.

Create a Gateway named `my-gateway` that:

- Uses the **nginx** GatewayClass.

- Listens on **port 80** using HTTP.

- Uses the host `app.example.com`.

This Gateway will serve as the entry point for routing traffic to your webapp Service.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - protocol: HTTP
    port: 80
    name: http
    hostname: app.example.com

kubectl create -f gateway.yaml
```

</p>
</details>
