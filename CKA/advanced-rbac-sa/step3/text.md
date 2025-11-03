### Create a Kubeconfig for deploybot

Generate a kubeconfig for the deploybot ServiceAccount to access the cluster using its token, and configure a new context named deploybot-context in the namespace appenv associated with this ServiceAccount.
If you created a new cluster, include its API server endpoint and CA certificate.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Creating a new cluster is optional. However, if you choose to create one, you’ll need to obtain the API server endpoint.
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'

# Get the cluster CA certificate and encode it (if you decided to create a new cluster).
base64 /etc/kubernetes/pki/ca.crt

# Create kubeconfig-deploybot.yaml
apiVersion: v1
kind: Config
clusters:  # optional
- name: kubernetes
  cluster:
    server: https://<apiserverip>:6443  # Api server endpoint
    certificate-authority-data: <base64-ca>  # Ca certificate
contexts:
- name: deploybot-context
  context:
    cluster: kubernetes  # If you created a new cluster, add it here.
    user: deploybot
    namespace: appenv
users:
- name: deploybot
  user:
    token: <insert-token-here>
```

</p>
</details>
