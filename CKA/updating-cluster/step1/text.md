### Connect to the control-plane and verify node status

In this step, you will connect to the control-plane node via SSH and check the status of your cluster nodes. It's important to know which nodes exist, their roles, and current Kubernetes versions before performing any upgrades.

- Ensures you are on the correct node.
- Checks the current cluster health and node versions.
- Confirms readiness of nodes before starting the upgrade.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Connect to the control-plane
ssh control-plane

# Verify cluster nodes and their versions
kubectl get nodes

```

</p>
</details>
