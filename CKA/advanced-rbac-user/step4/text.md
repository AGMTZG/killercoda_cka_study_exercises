### Configure kubeconfig for alice

Now that you have the signed certificate `alice.crt` and private key `alice.key`, create a dedicated **kubeconfig** file, or update the existing one, so that Alice can securely connect to the cluster. Then, set up a new context named `alice-context` in the namespace `projectx`.

Ensure that the paths specified in **client-certificate** and **client-key** point to the exact locations where `the alice.crt` and `alice.key` files are stored on your system.

If instead you prefer to embed the certificate and key directly in the **kubeconfig** (for example, to make it portable), you must first encode them in base64 and then use the fields **client-certificate-data** and **client-key-data**:

```bash
cat alice.crt | base64 | tr -d "\n"
cat alice.key | base64 | tr -d "\n"
```
Once you have the correct file paths or encoded values, add the **client-certificate-data** and **client-key-data** entries under the user section in the **kubeconfig** file.

Save all your changes in `~/.kube/config` (or merge it with your existing kubeconfig).


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Now we will modify the kubeconfig for alice.
# Creating a new cluster is optional. However, if you choose to create one, you’ll need to obtain the API server endpoint.
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'

# Get the cluster CA certificate and encode it (if you decided to create a new cluster).
base64 /etc/kubernetes/pki/ca.crt

# Modify the kubeconfig(no need to create a new one, just add the lines), usually in: ~/.kube/config
apiVersion: v1
kind: Config
clusters:  # Optional, you can use the default one as the cluster
- name: kubernetes 
  cluster:
    server: https://<apiserver:6443>  # Api server endpoint
    certificate-authority: /etc/kubernetes/pki/ca.crt   #  CA certificate
contexts:
- name: alice-context
  context:
    user: alice
    cluster: kubernetes # If you created a new cluster, add it here.
    namespace: projectx
users:
- name: alice
  user:
    client-certificate-data: <encoded base64 alice.crt>
    client-key-data: <encoded base64 alice.key>
```

</p>
</details>
