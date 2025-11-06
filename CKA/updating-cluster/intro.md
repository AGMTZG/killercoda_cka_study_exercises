### Updating the Control Plane

Note: From this point onward, this scenario will use a plain Ubuntu node. A script will install kubeadm, kubelet, and kubectl in the foreground. The script typically takes 2–3 minutes to complete.

**Introduction**: </br>
In this scenario, you’ll learn how to safely upgrade a Kubernetes cluster using kubeadm, including updating kubeadm, the control-plane, kubelet, and kubectl

**Scenario**: </br>
You are the administrator of a Kubernetes cluster currently running version 1.34.0-1.1. You want to upgrade the control plane node to the latest available version using kubeadm.

Tasks:

- Prepare the node by allowing the kubeadm package to be upgraded.

- Update the package list and install the most recent version of kubeadm.

- Check the available upgrades and confirm that version can be applied.

- Apply the upgrade to the control plane node using kubeadm.

- Drain the control plane node to safely evict workloads before upgrading the kubelet.

- Update the kubelet package to the latest version, ensuring it matches the version used by kubeadm..

- Restart the kubelet service to apply the changes.

- Uncordon the control plane node to make it schedulable again.

- Update the kubectl package to the most recent version, ensuring it matches the version used by kubeadm.

- Prevent kubeadm, kubelet, and kubectl from being automatically upgraded in the future.

Press **Next** to start preparing the node.
