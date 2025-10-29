### Check upgrade plan and apply control-plane upgrade

Before upgrading the control-plane, you must:

- Review which versions are available.
- Understand what changes will be applied.
- Apply the upgrade safely without affecting workloads.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Check available upgrade versions
sudo kubeadm upgrade plan

# Apply upgrade to the control-plane
sudo kubeadm upgrade apply 1.33.5
```

</p>
</details>
