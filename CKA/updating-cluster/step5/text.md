### Upgrade kubectl

Finally, upgrade your local `kubectl` to ensure it matches the cluster version:

- Avoids version conflicts when interacting with the cluster.
- Ensures all commands work as expected.
- Maintains compatibility with new features and APIs.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Upgrade kubectl to the same version as cluster
sudo apt-mark unhold kubectl
sudo apt install -y kubectl=1.33.5-1.1
sudo apt-mark hold kubectl
```

</p>
</details>
