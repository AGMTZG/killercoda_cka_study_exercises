### Connect to the controlplane and verify node status

In this step, you will connect to the controlplane(ubuntu) node via SSH and check the status of your cluster nodes. It's important to know which nodes exist, their roles, and current Kubernetes versions before performing any upgrades.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Connect to the controlplane
ssh ubuntu

# Verify cluster nodes and their versions
kubectl get nodes

```

</p>
</details>
