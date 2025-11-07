#!/bin/bash

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
kubectl create -f deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --all --timeout=120s || true
IP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
PREFIX=$(echo $IP | cut -d'.' -f1-3)
RANGE_START="${PREFIX}.240"
RANGE_END="${PREFIX}.250"
export IP PREFIX RANGE_START RANGE_END
envsubst < /root/metallb.yaml | kubectl apply -f -
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

