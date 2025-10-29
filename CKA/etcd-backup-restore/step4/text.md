### Restore etcd from the backup snapshot

Next, restore etcd from the snapshot you just created.

- The backup is located at: `/backup/etcd-snapshot.db`
- The restored data directory will be: `/mnt/etcd-data`

<details>
<summary>Show commands / answers</summary>
<p>

```bash
ETCDCTL_API=3 etcdutl snapshot restore /backup/etcd-snapshot.db --data-dir /mnt/etcd-data

# Verify the restored directory
ls /mnt/etcd-data
```

</p>
</details>
