### Load required kernel modules

Kubernetes and Calico require certain kernel modules to be loaded so networking works correctly:

- br_netfilter → allows Kubernetes to apply iptables rules to network bridge traffic (used by pods).

- overlay → enables overlay networking, required for CNI plugins like Calico.

<details>
<summary>Show commands / answers</summary>
<p>

```bash

# Load required kernel modules

sudo modprobe br_netfilter
sudo modprobe overlay

```

</p>
</details>
