### Install Gateway CRDs

Before you can create Gateways in Kubernetes, you need to install the Gateway API Custom Resource Definitions (CRDs). These CRDs define the objects like GatewayClass, Gateway, and HTTPRoute that allow Kubernetes to manage external traffic in a structured and flexible way.

Gateway CRDs extend the Kubernetes API, giving you the ability to define advanced routing rules beyond what standard Services provide.

**Tasks:**

1. Apply the Gateway API CRDs to your cluster, you can use this command:

```bash
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.1.0" | kubectl apply -f -
```

