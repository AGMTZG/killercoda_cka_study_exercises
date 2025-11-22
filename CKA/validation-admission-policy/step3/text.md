### Bind the Policy Cluster-wide

In this step, you'll bind the **ValidatingAdmissionPolicy** `require-basic-labels` so that it applies across the entire cluster. Binding the policy ensures that all Pods in all namespaces are evaluated against the rules you defined, providing consistent governance and enforcement.

Tasks:

- Create a ValidatingAdmissionPolicyBinding named `require-basic-labels-binding`

- Set the `policyName` to `require-basic-labels` to link the binding with your previously created policy.

- Apply the binding cluster-wide, so it affects Pods in all namespaces.

- Set the `validationActions` to `Deny` to reject Pods that fail the validation.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# require-basic-labels-binding.yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicyBinding
metadata:
  name: require-basic-labels-binding
spec:
  policyName: require-basic-labels
  validationActions: ["Deny"]

# Apply the binding into the cluster
kubectl create -f require-basic-labels-binding.yaml
```

</p> 
</details>
