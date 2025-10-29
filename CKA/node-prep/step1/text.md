### Disable swap memory (required by Kubernetes)

Kubernetes requires swap to be turned off because:

- The kubelet needs predictable memory; swap can cause instability.

- Pods need fast, reliable memory; using swap can slow them down or cause failures.

- It is an official Kubernetes requirement for all cluster nodes.

<details>
<summary>Show commands / answers</summary>
<p>

```bash

# Disable swap memory (required by Kubernetes)

sudo swapoff -a

# To make it permanent, comment out any swap entries in /etc/fstab

sudo sed -i.bak '/ swap / s/^/#/' /etc/fstab

```

</p>
</details>
