### Create the Namespace, ServiceAccount, and generate the ServiceAccount Token

In this step, you will:

- Create a dedicated namespace called `appenv` to isolate resources.

- Create a ServiceAccount named `deploybot` within that namespace to represent a specific application or user identity.

- Generate an authentication token for the ServiceAccount, which can be used by applications or users to securely access the Kubernetes API.

This setup allows you to grant limited and controlled access to the cluster for specific applications or users, without exposing full administrative privileges. The token can be used in kubeconfig files or by applications to authenticate securely.

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
