### Identify the etcd instance

Learn how to locate the running etcd instance in your Kubernetes control plane, and gather key configuration details such as certificate paths, data directory, and endpoints.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Connect to the control-plane node
ssh controlplane

# Check etcd version
etcdctl version

# List the running etcd Pod
kubectl get pods -n kube-system | grep etcd
# Example output:
# etcd-controlplane    1/1     Running   2 (50m ago)   10d

# Describe the etcd Pod to confirm its configuration
kubectl describe pod etcd-controlplane -n kube-system

# Look for these important flags:
# --cert-file=/etc/kubernetes/pki/etcd/server.crt
# --key-file=/etc/kubernetes/pki/etcd/server.key
# --data-dir=/var/lib/etcd
# --listen-client-urls=https://127.0.0.1:2379,https://172.30.1.2:2379
# --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
# --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

# The data-dir in etcd is the directory where etcd stores all of its persistent data.
```

</p>
</details>
