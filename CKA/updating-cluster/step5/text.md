### Upgrade kubectl

Finally, upgrade your local `kubectl` to ensure it matches the cluster version.

In this step, you will:

- Ensure the kubectl package is not on hold.
- Update kubectl to the target version 1.34.1-1.1
- Put the kubectl package on hold.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Upgrade kubectl to the same version as cluster
sudo apt-mark unhold kubectl
sudo apt install -y kubectl=1.34.1-1.1
sudo apt-mark hold kubectl
```

</p>
</details>
