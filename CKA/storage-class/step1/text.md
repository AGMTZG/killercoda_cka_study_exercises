### Create and Verify the StorageClass

Your manager has requested you to configure a custom StorageClass that meets specific performance and retention requirements.
The goal is to create a StorageClass that ensures persistent volumes are retained after deletion, support volume expansion, and are provisioned only when pods are scheduled.

After creating it, you must also verify which StorageClass is currently set as default and store the result in a specific directory for auditing purposes.

Requirements

- Create a StorageClass named `csi-retain-sc` with the following specifications:

  - Provisioner: `csi-driver.example-vendor.example` (not dynamic — it does not automatically create PersistentVolumes)

  - Reclaim policy: `Retain`

  - Volume expansion: `Allow`

  - Mount option: `discard`

  - Volume binding mode: `WaitForFirstConsumer`

  - Parameter: `guaranteedReadWriteLatency: "true"`

  - Set this StorageClass as default

Save the configuration and apply it to the cluster.

Finally:

  - Run the proper command to determine which StorageClass is the default.

  - Save the command output into `/opt/storage/default-sc.txt`.

  Note: You can use variations of the command, with or without headers, as long as the output clearly shows the default StorageClass.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, Remove the annotation from the default storage class
kubectl get storageclass

NAME                      PROVISIONER                         RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)      rancher.io/local-path               Delete          WaitForFirstConsumer   false                  20d

kubectl edit storageclass local-path

# Remove the annotation
storageclass.kubernetes.io/is-default-class: "true"

# Next, we create the storage class yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-retain-sc
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"   # Use this annotation to mark the StorageClass as the default. (Remember to remove the annotation from any existing default StorageClass to avoid conflicts.)
provisioner: csi-driver.example-vendor.example
reclaimPolicy: Retain
allowVolumeExpansion: true
volumeBindingMode: WaitForFirstConsumer
parameters:
  guaranteedReadWriteLatency: "true"
mountOptions:
- discard
volumeBindingMode: WaitForFirstConsumer

# Create the /opt/storage folder
mkdir -p /opt/storage/

# Then create the command
kubectl get storageclass -o custom-columns=NAME:.metadata.name,DEFAULT:.metadata.annotations."storageclass\.kubernetes\.io/is-default-class" | awk 'NR==1 || /true/' > /opt/storage/default-sc.txt
```

</p>
</details>
