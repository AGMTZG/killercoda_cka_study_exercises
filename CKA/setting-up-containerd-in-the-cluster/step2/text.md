# Step 2: Install containerd

After connecting to your EC2 instance via SSH, download the Containerd binaries and install them using the following command:

```bash
wget https://github.com/containerd/containerd/releases/download/v2.2.0-rc.0/containerd-2.2.0-rc.0-linux-amd64.tar.gz
```

This will download the Containerd 2.2.0-rc.0 package for Linux (amd64), which you can then extract and set up on your instance.

Tip:
The archive contains the Containerd binaries. Drop them to /usr/local/bin and then set up the systemd service to manage the Containerd daemon, the service should be called containerd.service.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Download the Containerd archive
wget https://github.com/containerd/containerd/releases/download/v2.2.0-rc.0/containerd-2.2.0-rc.0-linux-amd64.tar.gz

# Extract the contents of the archive
tar -xvzf containerd-2.2.0-rc.0-linux-amd64.tar.gz

#  Navigate to the extracted folder, set executable permissions, and move the binaries to /usr/local/bin (requires sudo)
sudo chmod +x containerd*
sudo chmod +x ctr
sudo mv containerd  containerd-shim-runc-v2  containerd-stress  ctr /usr/local/bin/

# Create the systemd service for Containerd
# The service file should be located at /usr/lib/systemd/system/containerd.service (requires sudo)

vim /usr/lib/systemd/system/containerd.service

[Unit]
Description=Containerd Service
After=network.target

[Service]
ExecStart=/usr/local/bin/containerd
Restart=always
Delegate=yes
KillMode=process
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target

# Save the service file, then start and enable the Containerd service:
sudo systemctl daemon-reload
sudo systemctl start containerd
sudo systemctl enable containerd
```

</p>
</details>
