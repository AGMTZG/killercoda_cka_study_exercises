### Affinity, Taints, and Tolerations

**Scenario**  </br>

You have a two-node cluster:

- **controlplane**: Linux node (kubernetes.io/os=linux) tainted with role=admin:NoExecute.
- **node01**: Labeled with `tier=testing`

Your goal is to deploy four pods with specific placement rules:

- **api**(service=api): Should try to be scheduled together with the auth pod. The scheduler will prefer this placement with weight 100, and it can tolerate the taint on controlplane so it can be colocated with auth if needed. Should avoid nodes running the logger pod using a soft anti-affinity.

- **auth**(service=auth): Should tolerate the role=admin:NoExecute taint on controlplane so it can run there.

- **logger**(service=logger): Should avoid nodes labeled tier=testing, but can tolerate the taint on controlplane. Should only run on Linux nodes.

- **db**(service=db): Preferred to run on node01 with a weight of 100.

The YAML files can be found in the home directory.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# api
apiVersion: v1
kind: Pod
metadata:
  name: api
  labels:
    service: api
spec:
  tolerations:
  - key: role
    operator: Equals
    value: admin
    effect: NoExecute
  affinity:
    podAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              service: auth
          topologyKey: kubernetes.io/hostname
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              service: logger
          topologyKey: kubernetes.io/hostname
  containers:
  - name: api
    image: nginx
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# auth
apiVersion: v1
kind: Pod
metadata:
  name: auth
  labels:
    service: auth
spec:
  tolerations:
  - key: role
    operator: Equals
    value: admin
    effect: NoExecute
  containers:
  - name: auth
    image: busybox
    command: ["sleep", "3600"]
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# logger
apiVersion: v1
kind: Pod
metadata:
  name: logger
  labels:
    service: logger
spec:
  tolerations:
  - key: role
    operator: Equals
    value: admin
    effect: NoExecute
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerm:
        - matchExpressions:
          - key: tier
            operator: NotIn
            values:
            - testing
          - key: "kubernetes.io/os"
            operator: "In"
            values: ["linux"]
  containers:
  - name: logger
    image: busybox
    command: ["sleep", "3600"]
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# db
apiVersion: v1
kind: Pod
metadata:
  name: db
  labels:
    service: db
spec:
  containers:
  - name: db
    image: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "12345678"
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        preference:
          matchExpressions:
          - key: "tier"
            operator: "In"
            values: ["testing"]
  dnsPolicy: ClusterFirst
  restartPolicy: Never
```

</p>
</details>
