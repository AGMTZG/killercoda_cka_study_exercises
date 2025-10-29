### Create a backup snapshot of etcd

Now that you know where etcd is running, create a snapshot of the datastore at /backup/etcd-snapshot.db using the information obtained from kubectl describe:

```bash
--cert-file=/etc/kubernetes/pki/etcd/server.crt
--key-file=/etc/kubernetes/pki/etcd/server.key
--data-dir=/var/lib/etcd
--listen-client-urls=https://127.0.0.1:2379,https://172.30.1.2:2379
--peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
```

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, we create the folder backup/
mkdir -p /backup/

# Next, We create the snapshot
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-snapshot.db --endpoints=https://172.30.1.2:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  --cacert=/etc/kubernetes/pki/etcd/ca.crt

```

</p>
</details>
