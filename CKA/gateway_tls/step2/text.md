### Verify the Gateway Controller and Create the Gateway Resource

In this step, verify that the NGINX Gateway Controller is installed and accepted by Kubernetes. Then, create a Gateway resource named `my-tls-gateway` that defines four listeners to handle both HTTP and HTTPS traffic for your application domains:

- `http-home` listener → HTTP requests for `app.home.local` on port 80  
- `https-home` listener → HTTPS requests for `app.home.local` on port 443 using the TLS secret `my-secret`  
- `http-contact` listener → HTTP requests for `app.contact.local` on port 80  
- `https-contact` listener → HTTPS requests for `app.contact.local` on port 443 using the TLS secret `my-secret`  

This configuration allows your Gateway to handle traffic securely over HTTPS while still supporting HTTP if needed. For a clear overview of how requests are routed to each backend, refer to the table below.

|Host               | Path      | Backend Service |
|-------------------|-----------|-----------------|
|app.home.local     |  /	    | home-svc        |
|app.home.local	    |  /sales   | sales-svc       |
|app.contact.local  |  /contact | contact-svc     |
|app.contact.local  |  /about   | about-us-svc    |



<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, we check if the gateway class was accepted by kubernetes
kubectl get gatewayclass

# We create the gateway
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-tls-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http-home
    protocol: HTTP
    port: 80
    hostname: app.home.local
  - name: https-home
    protocol: HTTPS
    port: 443
    hostname: app.home.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: my-secret
  - name: http-contact
    protocol: HTTP
    port: 80
    hostname: app.contact.local
  - name: https-contact
    protocol: HTTPS
    port: 443
    hostname: app.contact.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: my-secret
```

</p>
</details>
