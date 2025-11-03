### Create the Namespace, ServiceAccount, and generate the ServiceAccount Token

In this step, you’ll create a dedicated namespace and a ServiceAccount within it.
You’ll then generate an authentication token for the ServiceAccount, which can be used by applications or users to securely access the Kubernetes API.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create the namespace
kubectl create ns appenv

# Create the ServiceAccount
kubectl create sa deploybot -n appenv

# Confirm creation
kubectl get sa -n appenv

# Create the token
kubectl create token deploybot -n appenv
```

</p>
</details>
