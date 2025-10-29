### Update the etcd manifest to use restored data

Finally, Modify the etcd static Pod manifest to use the new restored data directory /mnt/etcd-data.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Modify the new data-dir in this file under hostPath
vim /etc/kubernetes/manifests/etcd.yaml

# Search for this line
- hostPath:
    path: /mnt/etcd-data # CHANGE THIS LINE
    type: DirectoryOrCreate
  name: etcd-data

or

sudo sed -i 's|/var/lib/etcd|/mnt/etcd-data|g' /etc/kubernetes/manifests/etcd.yaml

# Wait for etcd Pod to restart automatically
kubectl get pods -n kube-system | grep etcd
</p>
</details>
