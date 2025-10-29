### Connect to the control-plane and verify node status

In this step, you will connect to the control-plane node via SSH and check the status of your cluster nodes. It's important to know which nodes exist, their roles, and current Kubernetes versions before performing any upgrades.

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
