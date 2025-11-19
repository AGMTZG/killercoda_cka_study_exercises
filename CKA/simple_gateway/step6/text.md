### Create an HTTPRoute for webapp and Test the Connection

With your Gateway now accepting external HTTP traffic, the next step is to define how that traffic should be routed inside your cluster. This is where HTTPRoute comes in, it acts as the routing map that connects incoming requests from the Gateway to backend Services.

Unlike the older Ingress resource, HTTPRoute gives you a cleaner and more modular way to define routing rules. You can match on paths, hosts, headers, and more, and direct traffic to any Kubernetes Service.
In this step, you'll create a simple rule that routes all traffic to the webapp Service on port 80.

Tasks:
- Create an HTTPRoute named `webapp-route` that:
  - Attaches to the Gateway named `my-gateway`
  - Matches the HTTP path prefix `/` for host `app.example.com`
  - Forwards traffic to: Service: webapp in Port: 80
  - Edit `/etc/hosts` to add the gateway’s external IP along with the `app.example.com` host.

Once the route is created, you will verify that everything works by sending a request through the Gateway’s external IP.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# http.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: webapp-route
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - app.example.com
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: "/"
    backendRefs:
    - name: webapp
      port: 80


kubectl create -f http.yaml

# We check the external ip from the gateway
kubectl get gateway

# Update the /etc/hosts file to resolve the application domains locally
sudo vim /etc/hosts
<external ip from gateway>    app.example.com

or

echo "<external ip from gateway>   app.example.com" | sudo tee -a /etc/hosts

# Test the Gateway endpoints, for http
curl http://app.example.com/
```

</p>
</details>
