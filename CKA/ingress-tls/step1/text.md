### Create and Configure a TLS-enabled Ingress

You already have the following resources deployed in the cluster:

Deployments:

- **alpha** (label: `app: alpha`)

- **beta** (label: `app: beta`)

Services (ClusterIP):

- **alpha-service** (targeting alpha pods, `port 80`)

- **beta-service** (targeting beta pods, `port 80`)

Your task is to create an Ingress named `connection-ingress` with the following requirements:

- Verify that the services are correctly routing traffic by checking that their associated pods appear in the endpoints.

- Requests to `/alpha` and `/beta` should be routed to the corresponding services.

- Enable TLS for secure traffic by creating a TLS secret named `my-secret` and generating the corresponding certificates.

- The host for testing: `example.local`


Once done, test your setup by running:

```bash
curl -k https://example.local/alpha
curl -k https://example.local/beta
```

Note:

- Don’t forget to update /etc/hosts to point example.local to your cluster IP.

- You can use cert-manager (already installed in the cluster) or OpenSSL to generate the TLS certificates.

- When you create the Ingress, wait until the cluster assigns it an external IP address.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First we check the endpoints
kubectl get ep

# Next, we start creating the tls secret
# Using cert-manager
# First we create the issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: my-issuer
spec:
  selfSigned: {}

# Now, create the certificate
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-cert
spec:
  secretName: my-secret
  dnsNames:
  - example.local
  issuerRef:
    name: my-issuer
    kind: Issuer

# Using openSSL
# You can create the certificates manually
openssl genrsa -out example.local.key 2048
openssl req -new -key example.local.key -out example.local.csr -subj "/CN=example.local"
openssl x509 -req -in example.local.csr -signkey example.local.key -out example.local.crt -days 365

kubectl create secret tls my-secret --cert=tls.crt --key=tls.key

# Verify which Ingress Controller is installed
kubectl get ingressclass

# We start creating the ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: connection-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.local
    secretName: my-secret 
  rules:
  - host: example.local
    http:
      paths:
      - path: /alpha
        pathType: Prefix
        backend:
          service:
            name: alpha-service
            port:
              number: 80
      - path: /beta
        pathType: Prefix
        backend:
          service:
            name: beta-service
            port:
              number: 80

# Wait for the ingress external ip
k get ingress -w

# Retrieve the external IP address of the NGINX Ingress Controller LoadBalancer
kubectl get svc -n ingress-nginx

# Update the /etc/hosts file to resolve the application domains locally
sudo vim /etc/hosts

<external load balancer ip from ingress>   example.local

or

echo "<external load balancer ip from ingress>   example.local" | sudo tee -a /etc/hosts

# We test
curl -k https://example.local/alpha
curl -k https://example.local/beta
```

</p>
</details>
