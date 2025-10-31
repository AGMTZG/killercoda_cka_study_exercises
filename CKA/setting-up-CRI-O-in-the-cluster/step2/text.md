# Step 2: Remove residual Kubernetes and CNI directories

Remove leftover directories from previous Kubernetes installations. These directories can contain configurations, pod data, and network settings that may conflict with a new setup.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Contains configuration files for CNI.
sudo rm -rf /etc/cni/net.d

# Contains kubelet state, including pod data, volume mounts, and other node-specific information.
sudo rm -rf /var/lib/kubelet/*

# Contains kubelet state, including pod data, volume mounts, and other node-specific information.
sudo rm -rf /var/lib/etcd/

# Contains CNI plugin binaries and runtime state for container networking.
sudo rm -rf /var/lib/cni

# Contains runtime files such as API server sockets, PID files, and temporary Kubernetes runtime data.
sudo rm -rf /var/run/kubernetes
```

</p>
</details>
