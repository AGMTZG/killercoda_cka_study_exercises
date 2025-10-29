### Upgrade kubelet on the control-plane node

The kubelet must match the control-plane version. Steps include:

- Draining the node to safely evict pods.
- Installing the target kubelet version.
- Restarting the kubelet to apply the upgrade.
- Uncordoning the node to allow new pods to schedule.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Drain the control-plane node
kubectl drain control-plane --ignore-daemonsets

# Upgrade kubelet
sudo apt-mark unhold kubelet
sudo apt install -y kubelet=1.33.5-1.1
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo apt-mark hold kubelet

# Uncordon the node after upgrade
kubectl uncordon control-plane
```

</p>
</details>
