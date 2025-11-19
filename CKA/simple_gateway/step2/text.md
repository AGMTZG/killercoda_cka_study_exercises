### Step 2: Install NGINX Gateway Fabric

NGINX Gateway Fabric is a Kubernetes controller that implements the Gateway API, allowing you to manage external traffic routing through NGINX. It watches Gateway, GatewayClass, and HTTPRoute resources, and programs the NGINX data plane accordingly.

By installing NGINX Gateway Fabric, your cluster can handle HTTP and HTTPS traffic with advanced routing features like path-based routing, host-based routing, and traffic splitting.

**Tasks:**

1. Apply the NGINX Gateway Fabric manifests to your cluster. You can do this using the following commands:

```bash
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/default/deploy.yaml
```
