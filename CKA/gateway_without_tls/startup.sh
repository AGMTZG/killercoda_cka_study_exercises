#!/bin/sh
echo "[INFO] Installing MetalLB..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
echo "[INFO]  Waiting for MetalLB pods..."
kubectl wait --namespace metallb-system --for=condition=ready pod --all --timeout=120s || true
IP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
PREFIX=$(echo $IP | cut -d'.' -f1-3)
RANGE_START="${PREFIX}.240"
RANGE_END="${PREFIX}.250"
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: local-pool
  namespace: metallb-system
spec:
  addresses:
    - ${RANGE_START}-${RANGE_END}
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: advert
  namespace: metallb-system
EOF
echo "[INFO] Installing Gateway..."
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.1.0" | kubectl apply -f -
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/default/deploy.yaml
echo "[INFO] Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
echo "[INFO] Waiting for ingress-nginx pods..."
kubectl wait --namespace ingress-nginx --for=condition=ready pod --all --timeout=180s || true
echo "[INFO] Installing setup..."
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: web-content
      volumes:
      - name: web-content
        configMap:
          name: web-content
---

apiVersion: v1
kind: ConfigMap
metadata:
  name: web-content
data:
  index.html: |
    <html><body><h1>Web App Home</h1></body></html>

---

apiVersion: v1
kind: Service
metadata:
  name: web-app
spec:
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: dashboard-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dashboard-app
  template:
    metadata:
      labels:
        app: dashboard-app
    spec:
      containers:
      - name: dashboard
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: dashboard-content
      volumes:
      - name: dashboard-content
        configMap:
          name: dashboard-content

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: dashboard-content
data:
  index.html: |
    <html><body><h1>Dashboard App</h1></body></html>

---

apiVersion: v1
kind: Service
metadata:
  name: dashboard-app
spec:
  selector:
    app: dashboard-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: orders-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: orders-app
  template:
    metadata:
      labels:
        app: orders-app
    spec:
      containers:
      - name: orders
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: orders-content
      volumes:
      - name: orders-content
        configMap:
          name: orders-content

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: orders-content
data:
  index.html: |
    <html><body><h1>Orders App</h1></body></html>

---

apiVersion: v1
kind: Service
metadata:
  name: orders-app
spec:
  selector:
    app: orders-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: reports-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: reports-app
  template:
    metadata:
      labels:
        app: reports-app
    spec:
      containers:
      - name: reports
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: reports-content
      volumes:
      - name: reports-content
        configMap:
          name: reports-content

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: reports-content
data:
  index.html: |
    <html><body><h1>Reports App</h1></body></html>

---

apiVersion: v1
kind: Service
metadata:
  name: reports-app
spec:
  selector:
    app: reports-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: company-ingress
annotations:
  nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: app.company.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app
            port:
              number: 80
      - path: /dashboard
        pathType: Prefix
        backend:
          service:
            name: dashboard-app
            port:
              number: 80
  - host: orders.company.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: orders-app
            port:
              number: 80
      - path: /reports
        pathType: Prefix
        backend:
          service:
            name: reports-app
            port:
              number: 80
EOF

