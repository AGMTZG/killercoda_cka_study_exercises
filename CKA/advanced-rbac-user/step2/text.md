### Approve and Retrieve the Signed Certificate

Once the certificate signing request (CSR) has been created and submitted, a cluster administrator must approve it.
After approval, Kubernetes generates and stores the signed certificate, which you can then extract and use to authenticate the user.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Approve the certificate request to let Kubernetes sign it
kubectl certificate approve alice-certificate

# Now extract the signed certificate from the CSR and save it as alice.crt
kubectl get csr alice-certificate -o jsonpath='{.status.certificate}' | base64 -d > alice.crt

# Verify it exists
ls -l alice.crt
```

</p>
</details>
