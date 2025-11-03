#!/bin/sh

set -e

kubectl taint node controlplane role=admin:NoExecute
kubectl label node controlplane kubernetes.io/os=linux
kubectl label node node01 tier=testing

# API pod
cat <<EOF > api.yaml
apiVersion: v1
kind: Pod
metadata:
  name: api
  labels:
    service: api
spec:
  containers:
  - name: api
    image: nginx
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

# Auth pod
cat <<EOF > auth.yaml
apiVersion: v1
kind: Pod
metadata:
  name: auth
  labels:
    service: auth
spec:
  containers:
  - name: auth
    image: busybox
    command: ["sleep", "3600"]
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

# Logger pod
cat <<EOF > logger.yaml
apiVersion: v1
kind: Pod
metadata:
  name: logger
  labels:
    service: logger
spec:
  containers:
  - name: logger
    image: busybox
    command: ["sleep", "3600"]
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF

# DB pod
cat <<EOF > db.yaml
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
  dnsPolicy: ClusterFirst
  restartPolicy: Never
EOF
