### Create and Verify the ValidatingAdmissionPolicy

In this step, you'll create a **ValidatingAdmissionPolicy**. Your organization runs multiple applications across different environments (`dev`, `staging`, `prod`) managed by two teams: **Team Mercury** and **Team Saturn**. This policy ensures that all Pods include the required basic labels for proper governance and tracking.

Tasks:

Create a **ValidatingAdmissionPolicy** named `require-basic-labels` that:

- Limits the policy to **Pods only**.
- Sets **failurePolicy** to `Fail` to reject invalid Pods.
- Apply the policy only on **CREATE** and **UPDATE** operations for Pods.

Validates that:

- Every Pod must have an `owner` label, and its value must be either `saturn` or `mercury`.

- Every Pod has an `env` label.

- If a Pod is in the `dev`, `staging`, or `prod` namespace, its `env` label must match the namespace.

- Returns a clear error message for each validation failure.

You can use this table for reference when building expressions:

| Command / Expression                                      | Purpose                                                                  |
|-----------------------------------------------------------|--------------------------------------------------------------------------|
| `has(object.metadata.labels.<label name>)`                | Checks if a Pod has a specific label.                                    |
| `[].exists(e, e == object.metadata.labels.<label name>)`  | Checks if a label exists and its value matches one of the allowed values.|
| `object.metadata.namespace == 'namespace'`                | Ensures that Pods belong to a specific namespace.                        |
| `&&` (AND)                                                | Returns **true** only if all combined expressions are **true**.          |
| `||` (OR)                                                 | Returns **true** if at least one of the expressions is **true**.         |

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# require-basic-labels.yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicy
metadata:
  name: require-basic-labels
spec:
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
    - apiGroups: [""]
      apiVersions: ["v1"]
      operations: ["CREATE", "UPDATE"]
      resources: ["pods"]
  validations:
  - expression: >
      has(object.metadata.labels.owner) &&
      ['saturn','mercury'].exists(e, e == object.metadata.labels.owner) &&
      (
       (object.metadata.namespace == 'dev' && has(object.metadata.labels.env) && ['dev'].exists(e, e == object.metadata.labels.env)) ||
       (object.metadata.namespace == 'staging' && has(object.metadata.labels.env) && ['staging'].exists(e, e == object.metadata.labels.env)) ||
       (object.metadata.namespace == 'prod' && has(object.metadata.labels.env) && ['prod'].exists(e, e == object.metadata.labels.env))
      )
    message: >
      Pod validation failed:
      - 'owner' label is required
      - 'owner' label must be one of ['saturn','mercury']
      - 'env' label is required
      - 'env' label must have value 'dev' if in 'dev' namespace
      - 'env' label must have value 'staging' if in 'staging' namespace
      - 'env' label must have value 'prod' if in 'prod' namespace

# Apply the policy
kubectl create -f require-basic-labels.yaml
```

</p> 
</details>
