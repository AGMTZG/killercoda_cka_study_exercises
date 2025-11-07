### Check upgrade plan and apply controlplane upgrade

Before upgrading the controlplane, it’s important to review the available versions and understand the changes that will be applied. This ensures the upgrade is performed safely without affecting running workloads.

In this step, you will:

- Check the controlplane upgrade plan
- Apply the upgrade to the controlplane

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Check available upgrade versions
sudo kubeadm upgrade plan

# Apply upgrade to the controlplane
sudo kubeadm upgrade apply 1.34.1
```

</p>
</details>
