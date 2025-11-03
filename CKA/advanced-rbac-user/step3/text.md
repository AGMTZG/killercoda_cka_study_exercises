### Create the Role with pod permissions and bind alice to the Role using RoleBinding

In this step, you’ll create a Role named alice-developer that grants the list, get, create, update, and delete permissions required to manage pods in the projectx namespace.
Then, you’ll bind this role to the user alice using a RoleBinding named alice-developer-binding.
Both names should clearly reference the user alice to maintain consistency and make it easy to identify which resources belong to her.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create a namespace for alice’s work
kubectl create namespace projectx

# Then create the developers Role in that namespace
kubectl create role alice-developer --verb=list,get,create,update,delete --resource=pods -n projectx

# Confirm the role:
kubectl get role alice-developer -n projectx -o yaml

# Next, bind the role using rolebinding
kubectl create rolebinding alice-developer-binding --role=alice-developer --user=alice -n projectx

# Confirm the rolebinding
kubectl get rolebinding alice-developer-binding -n projectx -o yaml
```

</p>
</details>
