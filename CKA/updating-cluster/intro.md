### Updating the Control Plane

Note: From now on, this scenario will use a plain Ubuntu node. In the foreground, it will install kubeadm v1.33.2. This approach is necessary because Killercoda has updated all clusters to v1.34, making it impossible to perform a downgrade.

**Introduction**: </br>
In this scenario, you’ll learn how to safely upgrade a Kubernetes cluster using kubeadm, including updating kubeadm, the control-plane, kubelet, and kubectl

**Scenario**: </br>
You are the administrator of a Kubernetes cluster currently running version 1.33.2. You want to upgrade the control plane node to version 1.33.5-1.1 using kubeadm.

Tasks:

- Prepare the node by allowing the kubeadm package to be upgraded.

- Update the package list and install the specific version 1.33.5-1.1 of kubeadm.

- Check the available upgrades and confirm that version 1.33.5-1.1 can be applied.

- Apply the upgrade to the control plane node using kubeadm.

- Drain the control plane node to safely evict workloads before upgrading the kubelet.

- Update the kubelet package to the new version 1.33.5-1.1.

- Restart the kubelet service to apply the changes.

- Uncordon the control plane node to make it schedulable again.

- Update the kubectl package to the new version 1.33.5-1.1.

- Prevent kubeadm, kubelet, and kubectl from being automatically upgraded in the future.

Press **Next** to start preparing the node.
