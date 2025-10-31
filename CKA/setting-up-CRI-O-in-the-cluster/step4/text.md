### Install and configure CRI-O

Now, we are ready to install CRI-O, download the CRI-O .deb package for version 1.33 from the official repository:

```bash
wget https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.33/deb/amd64/cri-o_1.33.0-2.1_amd64.deb
```

Once installed, CRI-O needs a default configuration to function correctly with Kubernetes. This configuration is typically located in /etc/crio/. Additionally, the cgroup driver must be enabled to ensure proper container resource management.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We download the file
wget https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.33/deb/amd64/cri-o_1.33.0-2.1_amd64.deb

# Next, install it
sudo dpkg -i cri-o_1.33.0-2.1_amd64.deb

# Ensure the service is enabled; this will create the .sock file that will be used for connecting CRI-O with Kubernetes
sudo systemctl start crio
sudo systemctl enable crio

# Generate the default configuration of crio
mkdir -p /etc/crio/
crio config default | sudo tee /etc/crio/crio.conf > /dev/null

# We enable the cgroup driver in crio
# Search for this line and remove the hash
cgroup_manager = "systemd"

# Restart the crio service
sudo systemctl restart crio
```

</p>
</details>
