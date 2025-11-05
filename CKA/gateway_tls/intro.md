### Convert an Ingress to a Gateway API with TLS in Kubernetes

**Introduction** </br>

In this lab, you will learn how to migrate from a Kubernetes Ingress configuration to the Gateway API using NGINX Gateway Fabric, and enable TLS using either cert-manager or OpenSSL.

The provided environment already includes all required components such as MetalLB, cert-manager, NGINX Gateway Fabric, and the NGINX Ingress Controller.
You won’t need to install these manually — the setup script will automatically configure everything for you.

MetalLB is used to simulate a LoadBalancer service in a bare-metal environment, allowing the Gateway to properly expose services externally.

The initialization process typically takes 2–4 minutes, as the environment installs and configures all dependencies before your Gateway becomes ready.

Scenario </br>

You are given a Kubernetes cluster with multiple applications deployed, each with its own Deployment, Service, and ConfigMap.

Currently, routing is managed through an Ingress using the NGINX Ingress Controller.

Your goal is to migrate this setup to the Gateway API using NGINX Gateway Fabric, while enabling TLS termination using cert-manager or manually generated certificates with OpenSSL.

Current setup includes:

- `home-svc` and `sales-svc` accessible via `app.home.local`

- `contact-svc` and `about-us-svc` accessible via `app.contact.local`

- An Ingress named `my-app-ingress` that routes traffic based on path prefixes `/`, `/sales`, `/contact`, and `/about`

Objectives:

- Remove or disable the existing Ingress.

- Install and configure NGINX Gateway Fabric in the cluster.

- Create a self-signed cert-manager Issuer and a Certificate covering app.home.local and app.contact.local, or manually generate TLS certificates using OpenSSL and create a Kubernetes Secret from them.

- Define the required GatewayClass, Gateway, and HTTPRoute resources to replicate the Ingress routing behavior.

- Enable TLS for both hostnames using the certificate Secret.

Ensure the following routing:

|Host               | Path      | Backend Service |
|-------------------|-----------|-----------------|
|app.home.local     |  /	    | home-svc        |
|app.home.local	    |  /sales   | sales-svc       |
|app.contact.local  |  /contact | contact-svc     |
|app.contact.local  |  /about   | about-us-svc    |

Validate that all applications are reachable through their respective hostnames and paths over HTTPS, using curl -k or a web browser.

Press **Next** to start
