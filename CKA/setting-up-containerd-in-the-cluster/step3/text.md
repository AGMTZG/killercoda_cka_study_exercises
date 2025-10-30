### Configure containerd with systemd cgroup driver

In this step, you will:

- Generate the default configuration of containerd in /etc/containerd/

- Enable the systemd cgroup driver.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Generate the default configuration of containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Navigate through the config.toml and enable the systemd cgroup driver
SystemdCgroup = true

# Or
sed -i 's/SystemdCgroup = false/SystemdCgroup = true' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
```

</p>
</details>
