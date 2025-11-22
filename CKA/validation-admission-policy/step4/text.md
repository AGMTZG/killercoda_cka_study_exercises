### Test the ValidatingAdmissionPolicy with Pods

In this step, you'll test the **require-basic-labels** policy to ensure it correctly validates Pods according to the rules you defined. This allows you to verify that invalid Pods are rejected and valid Pods are accepted, helping enforce consistent labeling across all namespaces.

Tasks:

- **Create a valid Pod named `valid-pod-dev` in `dev` namespace** with the following configuration:
- Labels:
  - `owner` set to `mercury`  
  - `env` set to `dev` (matches namespace)
- Container:
  - Image: `nginx:1.26`
  - Container name: `nginx`
- Confirm that this Pod is accepted by the ValidatingAdmissionPolicy.

- **Test Pods that violate the policy named `invalid-pod-no-owner` in `dev` namespace** with the following configuration:
- Labels:
  - `env` set to `dev`  
- Container:
  - Image: `nginx:1.26`
  - Container name: `nginx`
- Confirm that Pod is rejected; validation message indicates missing `owner` label.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Valid pod - valid-pod-dev.yaml
apiVersion: v1
kind: Pod
metadata:
  name: valid-pod-dev
  namespace: dev
  labels:
    owner: mercury
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.26

# Apply the yaml - SUCCESS
kubectl create -f valid-pod-dev.yaml

# Invalid pod - invalid-pod-no-owner.yaml
apiVersion: v1
kind: Pod
metadata:
  name: invalid-pod-no-owner
  namespace: dev
  labels:
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.26

# Apply the yaml - REJECTED
kubectl create -f invalid-pod-no-owner.yaml
```

</p> 
</details>
