### Ensure required ports are open

Kubernetes components need specific ports to communicate properly between nodes:

- 6443 → kube-apiserver (API server for the cluster)

- 2379–2380 → etcd (key-value store used by Kubernetes)

- 10250 → kubelet (manages pods on the node)
