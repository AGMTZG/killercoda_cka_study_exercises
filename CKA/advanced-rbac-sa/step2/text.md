### Create and bind the Role to the ServiceAccount

In this step, you’ll create a Role named deploybot-role that grants the list, get, create, update, and delete permissions required to manage ReplicaSets and Deployments.
Then, you’ll create a RoleBinding named deploybot-role-binding to associate this role with the ServiceAccount you created earlier.

Note: Unlike user-based authentication, there’s no need to generate a Certificate Signing Request (CSR) — the ServiceAccount token will handle authentication automatically.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create a Role in the appenv namespace that allows management of deployments and replicasets.
kubectl create role deploybot-role --verb=get,list,create,update,delete --resource=deployments,replicasets -n appenv

# Validate
kubectl get role deploymanager -n appenv -o yaml

# Now bind the deploymanager Role to the deploybot ServiceAccount
kubectl create rolebinding deploybot-role-binding --role=deploybot-role --serviceaccount=appenv:deploybot -n appenv
```

</p>
</details>
