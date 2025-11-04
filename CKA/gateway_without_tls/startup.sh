#!/bin/sh
echo "[INFO] Installing MetalLB..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
echo "[INFO]  Waiting for MetalLB pods..."
kubectl wait --namespace metallb-system --for=condition=ready pod --all --timeout=120s || true
IP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
PREFIX=$(echo $IP | cut -d'.' -f1-3)
RANGE_START="${PREFIX}.240"
RANGE_END="${PREFIX}.250"
envsubst < /root/metallb.yaml | kubectl apply -f -
echo "[INFO] Installing Gateway..."
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.1.0" | kubectl apply -f -
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/default/deploy.yaml
echo "[INFO] Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
echo "[INFO] Waiting for ingress-nginx pods..."
kubectl wait --namespace ingress-nginx --for=condition=ready pod --all --timeout=180s || true
echo "[INFO] Installing setup..."
envsubst < /root/setup.yaml | kubectl apply -f -
echo "[INFO] Environment ready"
