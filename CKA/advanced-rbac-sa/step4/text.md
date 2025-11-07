### Validate deploybot’s Permissions

Confirm that the `deploybot` ServiceAccount has the correct permissions by checking if it can manage **Deployments** and **ReplicaSets** in the `appenv` namespace using its **kubeconfig**.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Switch context
kubectl config use-context deploybot-context

# Try to create a deployment (allowed)
kubectl create deployment nginx --image=nginx -n appenv

# Try to list replicasets (allowed)
kubectl get replicasets -n appenv

# Try to create a pod (denied)
kubectl run test-pod --image=nginx -n appenv

# Check if deploybot can delete deployments (allowed)
kubectl auth can-i delete deployments -n appenv --as system:serviceaccount:appenv:deploybot

# Check if deploybot can get secrets (denied)
kubectl auth can-i get secrets -n appenv --as system:serviceaccount:appenv:deploybot
```

</p>
</details>
