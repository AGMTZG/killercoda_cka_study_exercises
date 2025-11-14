#!/bin/sh

kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint node controlplane role=admin:NoExecute
kubectl label node controlplane kubernetes.io/os=linux
kubectl label node node01 tier=testing

cat <<EOF > frontend.yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  containers:
  - name: frontend
    image: nginx
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

cat <<EOF > backend.yaml
apiVersion: v1
kind: Pod
metadata:
  name: backend
  labels:
    app: backend
spec:
  containers:
  - name: backend
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

cat <<EOF > cache.yaml
apiVersion: v1
kind: Pod
metadata:
  name: cache
  labels:
    app: cache
spec:
  containers:
  - name: cache
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

cat <<EOF > mysql.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
  labels:
    app: db
spec:
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
EOF

