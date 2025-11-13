#!/bin/bash

echo -e "\033[91m[INFO] Installing MetalLB...\033[0m"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
echo "[INFO] Waiting for MetalLB webhook service to become ready..."
for i in {1..36}; do
  if kubectl get svc webhook-service -n metallb-system >/dev/null 2>&1; then
    ip=$(kubectl get svc webhook-service -n metallb-system -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
    if [ -n "$ip" ]; then
      echo -e "\033[92m[INFO] Webhook service is ready at $ip\033[0m"
      break
    fi
  fi
  echo -e "\033[91m[WAIT] Waiting for webhook-service... ($i/36)\033[0m"
  sleep 5
done
IP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
PREFIX=$(echo $IP | cut -d'.' -f1-3)
RANGE_START="${PREFIX}.240"
RANGE_END="${PREFIX}.250"
export IP PREFIX RANGE_START RANGE_END
envsubst < /root/metallb.yaml | kubectl apply -f -
echo -e "\033[96m[INFO] Installing Gateway...\033[0m"
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.1.0" | kubectl apply -f -
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/crds.yaml
echo -e "\033[96m[WAIT] Waiting for Gateway CRDs to be registered...\033[0m"
for crd in nginxproxies.gateway.nginx.org nginxgateways.gateway.nginx.org; do
  for i in {1..30}; do
    if kubectl get crd "$crd" &>/dev/null; then
      echo -e "\033[96m[INFO] CRD $crd is available.\033[0m"
      break
    fi
    echo -e "\033[96m[WAIT] Waiting for CRD $crd... ($i/30)\033[0m"
    sleep 3
  done
done
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.1.0/deploy/default/deploy.yaml
echo -e "\033[92m[INFO] Installing NGINX Ingress Controller...\033[0m"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
echo -e "\033[92m[INFO] Waiting for ingress-nginx controller to be ready...\033[0m"
kubectl wait --namespace ingress-nginx --for=condition=Ready pod --selector=app.kubernetes.io/component=controller --timeout=180s || true
echo -e "\033[92m[INFO]  Please wait 10 seconds... \033[0m"
sleep 10
echo -e "\033[95m[INFO] Installing cert-manager... \033[0m"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
echo -e "\033[93m[INFO] Installing setup...\033[0m"
envsubst < /root/setup.yaml | kubectl apply -f -
echo -e "\033[93m[INFO] Environment Ready \033[0m"
