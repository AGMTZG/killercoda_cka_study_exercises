# Step 1: Stop existing services and reset the cluster

Before starting a fresh Kubernetes cluster, we need to stop all running Kubernetes services and any container runtimes like containerd. This ensures no processes interfere with the new setup.

Note: At the beginning, Docker was uninstalled, which also removed containerd. In this environment, it’s not necessary to stop containerd manually, only do so if it’s still present on your system.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
sudo systemctl stop kubelet

# Stop the container runtime
sudo systemctl stop containerd 

# We reset the cluster
sudo kubeadm reset -f
```

</p>
</details>
