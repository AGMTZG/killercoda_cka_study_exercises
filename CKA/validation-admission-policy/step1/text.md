### Enable ValidatingAdmissionPolicy Feature Gate in Your Cluster

Before you can create and enforce a `ValidatingAdmissionPolicy`, you must ensure that the **feature gate** is enabled in your Kubernetes cluster. This feature allows Kubernetes to validate Pods against custom rules before they are persisted.

**Note:** In current Kubernetes versions, the `ValidatingAdmissionPolicy` feature gate is enabled by default, so you usually only need to verify it.

Tasks:

- Open the `kube-apiserver` manifest file: `/etc/kubernetes/manifests/kube-apiserver.yaml`.

- Locate the **command** section that defines the **container's** arguments, check if the **ValidatingAdmissionPolicy feature gate** is present, and if not, add the following argument to enable it:

```bash
--feature-gates=ValidatingAdmissionPolicy=true
```

- If you edited the file, Kubernetes will automatically restart the API server with the new feature gate.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Open the kube-apiserver manifest
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml

# Inspect the command arguments or add this flag if it’s missing
--feature-gates=ValidatingAdmissionPolicy=true

# After adding the feature gate, save and exit

# Check that kube-apiserver restarted successfully
kubectl get pods -n kube-system | grep kube-apiserver
```

</p> 
</details>
