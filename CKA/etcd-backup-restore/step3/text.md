### Simulate a disaster recovery

In this step, you will simulate a disaster recovery scenario by deleting critical control-plane components. This helps you practice restoring etcd and ensuring cluster functionality.

You will:

- Delete the static pod manifest files for the **API Server** and **Controller Manager** from the `/etc/kubernetes/manifests` directory

Note: After deleting the static pod manifests, there’s no need to manually delete the corresponding pods from the kube-system namespace. The kubelet automatically terminates them when it no longer finds their manifest files in the configured directory.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# List static pod manifests
ls /etc/kubernetes/manifests/
# Expected output: etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

# Remove the API server and Controller Manager manifests
sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml

```

</p>
</details>
