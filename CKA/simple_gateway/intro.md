### Simple Gateway in Kubernetes

A Gateway in Kubernetes defines how traffic enters a cluster and routes to internal services. Unlike standard Services, Gateways give you more control over routing, protocols, and traffic management, supporting advanced use cases like HTTP, HTTPS, and TCP routing.

With the Gateway API, you can:

- **Decouple traffic routing from services**: Define routing rules independently from the backend services.  
- **Use GatewayClasses**: Specify which controller manages the Gateway (e.g., NGINX).  
- **Manage traffic with HTTPRoutes**: Route requests based on hostnames, paths, or headers.  
- **Expose services externally**: Integrate with LoadBalancers like MetalLB to get external IPs for local clusters like Minikube.  

Key components you’ll work with:

- **GatewayClass**: Defines which controller manages your Gateways (e.g., `k8s.nginx.org/gateway-controller`).  
- **Gateway**: Specifies where and how traffic enters a namespace.  
- **HTTPRoute**: Routes traffic from a Gateway to one or more backend services.  

**Important: Using Minikube requires `minikube tunnel` to expose Gateways with LoadBalancer IPs, allowing you to test external traffic routing locally.**

In this scenario, you’ll install the required **CRDs**, **NGINX Gateway Fabric**, and **MetalLB**, then create a Gateway and HTTPRoute.

Press **Next** to start setting up your Gateway.
