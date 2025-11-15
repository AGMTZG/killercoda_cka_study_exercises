### Affinity, Taints, and Tolerations

**Scenario**  </br>

You have a two-node cluster:

- **controlplane**: Linux node (`kubernetes.io/os=linux`) tainted with `role=admin:NoExecute`.
- **node01**: Labeled with `tier=testing`

You need to deploy four pods with specific placement rules:

- **api** (`service: api`): Should prefer to be scheduled on the same node as the `auth` pod, with a **preference** weight of `100`. It can tolerate the taint on `controlplane` to allow colocation with `auth` if necessary. Additionally, it should avoid nodes running the `logger` pod using a soft **anti-affinity** rule.

- **auth** (`service: auth`): Must tolerate the `role=admin:NoExecute` taint on `controlplane` to allow scheduling there. Placement on `controlplane` is mandatory.

- **logger** (`service: logger`): Should avoid nodes labeled `tier=testing`, but can tolerate the taint on `controlplane`. It must run on **Linux nodes** only.

- **db** (`service: db`): Preferred to run on `node01` with a **weight** of `100`.

The YAML files can be found in the **home** directory.

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
    operator: Equal
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
    operator: Equal
    value: admin
    effect: NoExecute
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
            - controlplane
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
    operator: Equal
    value: admin
    effect: NoExecute
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: tier
            operator: NotIn
            values:
            - testing
          - key: kubernetes.io/os
            operator: In
            values:
            - linux
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
