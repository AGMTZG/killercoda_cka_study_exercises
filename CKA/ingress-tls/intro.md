### TLS-enabled Ingress in Kubernetes

In Kubernetes, Services of type ClusterIP are only accessible within the cluster. To make your applications available externally and securely, you use an Ingress.

A TLS-enabled Ingress allows you to route incoming HTTPS traffic to your applications while encrypting the communication between clients and the cluster.

In this scenario, your goal is to create an Ingress that securely exposes the existing alpha and beta applications using TLS certificates, ensuring both security and proper routing.

Press Next to start configuring the TLS-enabled Ingress.
