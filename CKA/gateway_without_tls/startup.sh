#!/bin/sh
set -e
echo -e "\033[91m[INFO] Installing MetalLB...\033[0m"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
echo -e "\033[91m[INFO] Waiting for MetalLB pods to become ready...\033[0m"
kubectl wait --namespace metallb-system --for=condition=ready pod --all --timeout=120s || true
IP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
PREFIX=$(echo $IP | cut -d'.' -f1-3)
RANGE_START="${PREFIX}.240"
RANGE_END="${PREFIX}.250"
export IP PREFIX RANGE_START RANGE_END
envsubst < /root/metallb.yaml | kubectl apply -f -
echo -e "\033[96m[INFO] Installing Gateway...\033[0m"
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.1.0" | kubectl apply -f -
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/default/deploy.yaml
echo -e "\033[92m[INFO] Installing NGINX Ingress Controller...\033[0m"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
echo -e "\033[92m[INFO] Waiting for ingress-nginx controller to be ready. This may take several minutes...\033[0m"
kubectl wait --namespace ingress-nginx --for=condition=Ready pod --selector=app.kubernetes.io/component=controller --timeout=180s || true
echo -e "\033[92m[INFO] Ingress controller is ready! \033[0m"
echo -e "\033[93m[INFO] Installing setup...\033[0m"
envsubst < /root/setup.yaml | kubectl apply -f -
echo -e "\033[93m[INFO] Environment Ready \033[0m"
