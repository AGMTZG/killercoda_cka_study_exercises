### Backup and Restore etcd in a Kubernetes Cluster

In this scenario, you’ll learn how to **back up and restore the etcd datastore** used by Kubernetes.

Your organization operates a Kubernetes cluster with a single control plane node. You are required to create a backup of the etcd datastore and later perform a disaster recovery test by restoring the cluster from that backup.

Your Tasks:

- Access the control plane node, locate the running etcd container or service, and access its information.

- Create a snapshot backup of etcd and save it to /backup/etcd-snapshot.db.

- Simulate a disaster scenario by removing the static pod manifest files for kube-apiserver-controlplane and kube-controller-manager-controlplane.

- Restore etcd using the snapshot previously created.
  - The new etcd data directory will be in: /mnt/etcd-data

- Verify that the cluster is functional by checking the nodes and pods.

Press **Next** to start preparing the node.
