### Update kubeadm to the target version

Kubeadm orchestrates upgrades in Kubernetes. Upgrading kubeadm first is critical because:

- It ensures compatibility with the desired cluster version.
- Provides the tools necessary to safely upgrade control-plane components.
- Prevents version mismatches during the upgrade.

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
