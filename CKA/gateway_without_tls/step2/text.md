### Create HTTPRoutes for Each Hostname

In this step, you’ll create routing rules that define how HTTP traffic is forwarded from the Gateway `my-gateway` to the appropriate backend services. Each HTTPRoute corresponds to a specific hostname and references the previously created Gateway.

You’ll create one route per hostname: `app.company.local` and `orders.company.local`.

For `app.company.local`, the HTTPRoute named `http-app` routes `/` to `web-app` and `/dashboard` to `dashboard-app`, using URLRewrite filters, because the NGINX image doesn’t include the endpoint /dashboard.

For `orders.company.local`, the HTTPRoute named `http-orders` routes `/` to orders-app and `/reports` to `reports-app`, also applying URL rewrites for consistent paths.

This setup ensures clear, organized routing for each domain and its backend services.

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
# First HTTPRoute for app.company.local

apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: http-app
spec:
  parentRefs:
  - name: my-gateway
  hostnames:
  - app.company.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: http-app
      port: 80
  - matches:
    - path:
        type: PathPrefix
        value: /dashboard
    backendRefs:
    - name: dashboard-app
      port: 80
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /

# Second HTTP Route for orders.company.local

apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: http-orders
spec:
  parentRefs:
  - name: my-gateway
  hostnames: 
  - orders.company.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: orders-app
      port: 80
  - matches:
    - path:
        type: PathPrefix
        value: /reports
    backendRefs:
    - name: reports-app
      port: 80
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /
```

</p>
</details>
