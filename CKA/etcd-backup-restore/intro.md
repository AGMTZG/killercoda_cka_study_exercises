### Backup and Restore etcd in a Kubernetes Cluster

In this scenario, you’ll learn how to **back up and restore the etcd datastore** used by Kubernetes.

Your company has a Kubernetes cluster with a single control plane node. You’ve been asked to perform a backup of the etcd datastore and later simulate a disaster recovery scenario by restoring the cluster from that backup.

Your Tasks:

- Access the control plane node, locate the running etcd container or service, and access its information.

- Create a snapshot backup of etcd and save it to /backup/etcd-snapshot.db.

- Delete pods kube-apiserver-controlplane and kube-controller-manager-controlplane in namespace kube-system

- Restore etcd using the snapshot previously created.
  - The new etcd data directory will be in: /mnt/etcd-data

- Verify that the cluster is functional by checking the nodes and pods.
