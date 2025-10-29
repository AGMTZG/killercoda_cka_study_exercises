### Update kubeadm to the target version 1.33.5-1.1

Kubeadm orchestrates upgrades in Kubernetes. Upgrading kubeadm first is critical because:

- It ensures compatibility with the desired cluster version.
- Provides the tools necessary to safely upgrade controlplane components.
- Prevents version mismatches during the upgrade.

In this step: before upgrading kubeadm, you must:

- Ensure the kubeadm package is not on hold.
- Update the package list on the machine.
- Check the available versions of kubeadm.
- Ensure the kubeadm package is at version 1.33.5-1.1 before proceeding.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Unhold kubeadm package
sudo apt-mark unhold kubeadm

# Update package list and check available kubeadm versions
sudo apt update
sudo apt-cache madison kubeadm

# Install the target kubeadm version
sudo apt install kubeadm=1.33.5-1.1
sudo apt-mark hold kubeadm
```

</p>
</details>
