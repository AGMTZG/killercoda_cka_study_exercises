### Create and Configure TLS Certificates and Secrets

In this step, you’ll configure your cluster to handle TLS termination using either cert-manager or OpenSSL.
The objective is to generate self-signed certificates that your Gateway will later use to securely serve HTTPS traffic.

cert-manager is a Kubernetes add-on that simplifies certificate management. It automatically handles the creation and renewal of certificates, as well as the generation of TLS secrets.

If you’re using cert-manager, you’ll need to define two resources:

- An Issuer named `my-issuer`, which defines how certificates are signed,

- A Certificate named `multi-cert`, which requests and stores the TLS credentials.

If you choose OpenSSL, make sure to include your hostnames (CN and SAN fields) when generating the certificate, and then create the corresponding Kubernetes Secret to store it.

The secret will have a name `my-secret`.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
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
  name: multi-cert
spec:
  secretName: my-secret
  dnsNames:
  - app.home.local
  - app.contact.local
  issuerRef:
    name: my-issuer
    kind: Issuer

# Using openSSL
# You can create the certificates manually
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 \
  -nodes -keyout tls.key -out tls.crt \
  -subj "/CN=app.home.local" -addext "subjectAltName=DNS:app.home.local,DNS:app.contact.local"

kubectl create secret tls my-secret --cert=tls.crt --key=tls.key
```

</p>
</details>
