### Storage class

A StorageClass in Kubernetes defines the storage provisioner and parameters used to dynamically create PersistentVolumes (PVs), although not all provisioners support dynamic provisioning.
It simplifies storage management by allowing developers to request storage without needing to understand backend infrastructure details.

Administrators can define multiple StorageClasses for different performance, cost, or data retention needs — for example, fast SSD storage for databases or standard HDD storage for backups.

Key features of a StorageClass include:

- Provisioner: Provisioner: Defines the external or internal driver used to create volumes (e.g., local-path, ebs.csi.aws.com, rook-ceph.rbd.csi.ceph.com).

- Reclaim Policy: Determines what happens to a PV after its claim is deleted (e.g., Retain, Delete).

- Volume Expansion: Allows resizing volumes without recreation.

- Mount Options and Parameters: Provide tuning for performance or reliability.

- Default Class: Specifies which StorageClass Kubernetes will use automatically when none is defined.

**Important: Not all provisioners automatically create PersistentVolumes, this is something you should memorize, as it’s essential to understanding how Kubernetes storage provisioning works.**

In this scenario, you’ll create a custom default StorageClass with specific parameters and then verify it’s correctly set as the cluster’s default.

Press Next to start configuring your StorageClass.
