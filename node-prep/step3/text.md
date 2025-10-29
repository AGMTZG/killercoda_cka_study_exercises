### Set sysctl parameters for Kubernetes networking

Kubernetes requires certain kernel networking settings to be enabled so pods can communicate properly:

- net.bridge.bridge-nf-call-iptables=1 → ensures iptables rules are applied to bridged network traffic.

- net.ipv4.ip_forward=1 → allows the node to forward IPv4 packets between interfaces.

- net.ipv6.conf.all.forwarding=1 → allows the node to forward IPv6 packets if needed.

<details>
<summary>Show commands / answers</summary>
<p>

```bash

Set sysctl parameters for Kubernetes networking

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -w net.ipv4.ip_forward=1

```

</p>
</details>
