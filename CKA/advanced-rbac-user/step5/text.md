### Validate alice’s permissions

Now that alice’s **kubeconfig** is configured, let’s verify that she can only perform the actions allowed by her Role `alice-developer` in the `projectx` namespace.

Use her **kubeconfig** to attempt operations on pods.


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We switch context
kubectl config use-context alice-context

# Try to create a pod (allowed)
kubectl run pod nginx --image=nginx --port=80

# Try to create a deployment (denied)
kubectl create deployment nginx --image=nginx --replicas=3 --port=80

# If you are going to run kubectl auth tests, make sure to switch back to the default admin context
kubectl config use-context kubernetes-admin@kubernetes

# Check if alice can list pods (allowed)
kubectl auth can-i list pods -n projectx --as alice

# Check if alice can create pods (allowed)
kubectl auth can-i create pods -n projectx --as alice

# Check if alice can get secrets (denied)
kubectl auth can-i get secrets -n projectx --as alice
```

</p>
</details>
