### Configure kubeconfig for alice

Now that you have the signed certificate (alice.crt) and the private key (alice.key), you’ll set up a dedicated kubeconfig file so that alice can securely authenticate to the cluster.

Ensure that the paths specified in client-certificate and client-key point to the exact locations where the alice.crt and alice.key files are stored on your system.

If instead you prefer to embed the certificate and key directly in the kubeconfig (for example, to make it portable), you must first encode them in base64 and then use the fields client-certificate-data and client-key-data:

```bash
cat alice.crt | base64 | tr -d "\n"
cat alice.key | base64 | tr -d "\n"
```
Once you have the correct file paths or encoded values, modify the kubeconfig, usually in ~/.kube/config


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Now we will modify the kubeconfig for alice.
# First, locate your cluster API server and CA cert.
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'

# Modify the kubeconfig, usually in: ~/.kube/config
apiVersion: v1
kind: Config
clusters:
- name: kubernetes
  cluster:
    server: https://<apiserver:6443>
    certificate-authority: /etc/kubernetes/pki/ca.crt
contexts:
- name: alice-context
  context:
    user: alice
    cluster: kubernetes
    namespace: projectx
users:
- name: alice
  user:
    client-certificate: alice.crt
    client-key: alice.key
current-context: alice-context
```

</p>
</details>
