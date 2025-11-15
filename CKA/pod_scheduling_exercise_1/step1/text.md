### Affinity, Taints, and Tolerations

**Scenario**  </br>

You have a two-node cluster:

- **controlplane**: Tainted with `role=backend:NoSchedule`
- **node01**: Labeled with `env=dev`

You need to deploy four pods, each with specific placement requirements:

- **frontend**: Should prefer to be scheduled on the same node as the `backend` pod. This preference has a **weight** of `100`. Additionally, it can tolerate the taint on `controlplane` so it can run there if necessary.

- **backend**: Must tolerate the `role=backend:NoSchedule` taint on `controlplane` to allow scheduling there. Placement on `controlplane` is mandatory.

- **cache**: Should avoid nodes labeled `env=dev`, but it can tolerate the taint on `controlplane`. This ensures it can still be scheduled if `controlplane` is the only available node.

- **db**: Must run on `node01` and cannot be scheduled on any other node. No special tolerations are required.

The YAML files can be found in the `home` directory.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Frontend
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  tolerations:
  - key: role
    operator: Equal
    value: backend
    effect: NoSchedule
  affinity:
    podAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: backend
          topologyKey: kubernetes.io/hostname
  containers:
  - name: frontend
    image: nginx
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# Backend
apiVersion: v1
kind: Pod
metadata:
  name: backend
  labels:
    app: backend
spec:
  tolerations:
  - key: role
    operator: Equal
    value: backend
    effect: NoSchedule
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
  - name: backend
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# Cache
apiVersion: v1
kind: Pod
metadata:
  name: cache
  labels:
    app: cache
spec:
  tolerations:
  - key: role
    operator: Equal
    value: backend
    effect: NoSchedule
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: env
            operator: NotIn
            values:
            - dev
  containers:
  - name: cache
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never

# Db
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  labels:
    app: db
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: env
            operator: In
            values:
            - dev
  containers:
  - name: mysql
    image: mysql
    ports:
    - containerPort: 3306
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "12345678"
  dnsPolicy: ClusterFirst
  restartPolicy: Never


```

</p>
</details>
