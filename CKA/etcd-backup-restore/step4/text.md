### Restore etcd from the backup snapshot

Next, restore etcd from the snapshot you just created.

- The backup is located at: `/backup/etcd-snapshot.db`
- The restored data directory will be: `/mnt/etcd-data`
- Once the etcd data is restored, you need to recreate the static pods for the API server and Controller Manager. Restoring etcd only recovers the cluster state prior to the disaster, it does not restore the manifests that were deleted from /etc/kubernetes/manifests/

Tip:
To recover the controlplane static pods, you can either restore the original manifest files from backup or regenerate them using kubeadm init phase commands. Once the manifests are back in place, kubelet will automatically recreate the static pods.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
ETCDCTL_API=3 etcdutl snapshot restore /backup/etcd-snapshot.db --data-dir /mnt/etcd-data

# Verify the restored directory
ls /mnt/etcd-data

# Recreate the static pods (use control-plane; it's not actually the hostname controlplane)
sudo kubeadm init phase control-plane apiserver
sudo kubeadm init phase control-plane controller-manager
```

</p>
</details>
