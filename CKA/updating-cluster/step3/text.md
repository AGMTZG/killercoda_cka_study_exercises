### Check upgrade plan and apply control-plane upgrade

Before upgrading the control-plane, it’s important to review the available versions and understand the changes that will be applied. This ensures the upgrade is performed safely without affecting running workloads.

In this step, you will:

- Check the control-plane upgrade plan
- Apply the upgrade to the control-plane
- Put kubeadm package in hold

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Check available upgrade versions
sudo kubeadm upgrade plan

# Apply upgrade to the control-plane
sudo kubeadm upgrade apply 1.33.5

# We lock the kubeadm package
sudo apt-mark hold kubeadm
```

</p>
</details>
