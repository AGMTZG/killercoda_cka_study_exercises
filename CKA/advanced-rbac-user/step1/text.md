### Generate and Upload a Certificate Request for Alice

You will begin by generating a private key named `alice.key` and a certificate signing request (CSR) named `alice.csr` for the user alice.
Next, encode the CSR in base64 and use it to create a Kubernetes CSR manifest named `alice-certificate`, which can then be applied to the cluster to request a signed certificate for authentication.

Note: The Common Name (CN) in the CSR must exactly match the username defined in the kubeconfig file.
If they don’t match, authentication will fail when the user tries to access the cluster.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
#  Generate the private key:
openssl genrsa -out alice.key 2048

# Verify the key:
openssl rsa -in alice.key -check

# Generate a CSR with the Common Name (CN) alice
openssl req -new -key alice.key -out alice.csr -subj "/CN=alice"

# Encode the CSR in base64
cat alice.csr | base64 | tr -d '\n'

# Create a certificate.yaml

apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: alice-certificate
spec:
  request: <paste-the-csr-token>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth

# Apply it
kubectl apply -f certificate.yaml
```

</p>
</details>
