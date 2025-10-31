### Clear iptables rules and delete virtual network interfaces

This step is necessary to remove leftover network configurations from previous Kubernetes setups or CNI plugins such as Flannel or Calico. Residual iptables rules and virtual network interfaces can interfere with a new cluster installation, causing networking issues for pods and services.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Flush all rules in the filter table
sudo iptables -F

# Flush all rules in the NAT table
sudo iptables -t nat -F

# Flush all rules in the mangle table
sudo iptables -t mangle -F

# Delete all user-defined chains
sudo iptables -X

# List all network interfaces
sudo ip link show

# Examples of virtual interfaces created by CNI plugins:
sudo ip link delete flannel.1
sudo ip link delete cali6f0dd2aae09
sudo ip link delete calic4f3c10e5e1
```

</p>
</details>
