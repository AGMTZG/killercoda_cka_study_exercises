### Affinity, Taints, and Tolerations

**Scenario**  </br>

You have a two-node cluster:

- **controlplane**: Tainted with `role=backend:NoSchedule`
- **node01**: Labeled with `env=dev`

Your goal is to deploy four pods with specific placement rules:

- **frontend**: Should try to be scheduled on the same node as the backend pod. The scheduler will prefer this placement with a weight of 100, and it can tolerate the taint on controlplane so the pod can run alongside backend if necessary. This ensures the preference can actually be satisfied.

- **backend**: Should tolerate the restriction on controlplane (role=backend:NoSchedule) so it can be scheduled there. No other changes needed.

- **cache**: Should avoid nodes labeled env=dev but can tolerate the taint on controlplane. This way, it can still be scheduled if controlplane is the only node left, avoiding un-schedulable pods.

- **db**: Must run on node01 and cannot be scheduled on any other node. No special tolerations are required.

The YAML files can be found in the home directory.

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
    operator: Equals
    value: backend
    effect: NoSchedule
  affinity:
    podAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app:backend
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
    operator: Equals
    value: backend
    effect: NoSchedule
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
    operator: Equals
    value: backend
    effect: NoSchedule
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerm:
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
        nodeSelectorTerm:
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
