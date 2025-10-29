### Simulate a disaster recovery

In this step, you will simulate a disaster recovery scenario by deleting critical control-plane components. This helps you practice restoring etcd and ensuring cluster functionality.

You will:

- Delete the static pod manifests for the API server and Controller Manager.
- Delete the running pods for the API server and Controller Manager in the `kube-system` namespace.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# List static pod manifests
ls /etc/kubernetes/manifests/
# Expected output: etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

# Remove the API server and Controller Manager manifests
sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml

# Delete the running pods forcibly
kubectl delete pod kube-apiserver-controlplane kube-controller-manager-controlplane -n kube-system --grace-period=0 --force
```

</p>
</details>
