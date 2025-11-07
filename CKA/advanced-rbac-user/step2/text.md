### Approve and Retrieve the Signed Certificate

In this step, you will approve the CertificateSigningRequest (CSR) you previously created and then retrieve the signed certificate for the user alice.

Specifically, you will:

- Approve the CSR to allow Kubernetes to generate a signed certificate.

- Extract the signed certificate from the approved CSR and save it locally as alice.crt.

- Verify that the certificate file exists and is ready for use to authenticate the user to the cluster.

This ensures that alice can securely connect to the Kubernetes cluster using the signed certificate and her private key.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Approve the certificate request to let Kubernetes sign it
kubectl certificate approve alice-certificate

# Now extract the signed certificate from the CSR and save it as alice.crt
kubectl get csr alice-certificate -o jsonpath='{.status.certificate}' | base64 -d > alice.crt
```

</p>
</details>
