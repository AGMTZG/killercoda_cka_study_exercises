### Migrating from an Ingress to a Gateway

**Introduction** </br>

In this lab, you will learn how to migrate from a Kubernetes Ingress configuration to the Gateway API using HTTP routes without TLS.

The provided environment already includes all necessary components such as MetalLB, NGINX Gateway Fabric, and the NGINX Ingress Controller. You will not install them manually instead, the setup script will automatically prepare everything for you.

MetalLB is used in this environment to simulate a LoadBalancer service on a bare-metal cluster, allowing the Gateway to function properly.

The initialization process takes approximately 2 to 4 minutes, as the script installs and configures all dependencies before your Gateway becomes ready.

**Scenario** </br>

You are given a Kubernetes cluster with multiple applications deployed, each with its own Deployment, Service, and ConfigMap. Currently, traffic routing is handled using an Ingress with the NGINX Ingress Controller. Your task is to replace the Ingress with a Gateway API setup using NGINX Gateway Fabric.

Current setup includes:

- `web-app` and `dashboard-app` accessible via `app.company.local`

- `orders-app` and `reports-app` accessible via `orders.company.local`

- An Ingress named `company-ingress` routing traffic to the appropriate services based on path prefixes.

Objectives:

- Remove or disable the existing Ingress.

- Install and configure NGINX Gateway Fabric in the cluster.

- Define the necessary GatewayClass, Gateway, and HTTPRoute resources to replicate the routing behavior of the original Ingress.

Ensure the following routing (all of them have the nginx image and serve in port 80):

|Host                  | Path        | Backend Service |
|----------------------|-------------|-----------------|
|app.company.local     |  /	         | web-app         |
|app.company.local	   |  /dashboard | dashboard-app   |
|orders.company.local  |  /          | orders-app      |
|orders.company.local  |  /reports   | reports-app     |

- Validate that all applications are accessible via their respective hostnames and paths, using curl or a browser.


Press **Next** to start
