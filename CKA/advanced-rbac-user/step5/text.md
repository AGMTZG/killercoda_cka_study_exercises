### Validate alice’s permissions

Now that alice’s kubeconfig is configured, let’s verify that she can only perform the actions allowed by her Role (`alice-developer`) in the `projectx` namespace.

Use her kubeconfig to attempt operations on pods:


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We switch context
kubectl config use-context alice-context

# Try to create a pod
kubectl create pod nginx --image=nginx --port=80

# Try to create a deployment
kubectl create deployment nginx --image=nginx --replicas=3 --port=80
```

</p>
</details>
