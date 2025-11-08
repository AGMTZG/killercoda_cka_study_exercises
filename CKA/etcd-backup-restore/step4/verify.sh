#!/bin/bash

if [ -d "/mnt/etcd-data" ] && [ "$(ls -A /mnt/etcd-data)" ]; then
    echo "ETCD data restored successfully in /mnt/etcd-data"
else
    echo "ETCD restore failed or directory is empty"
    exit 1
fi

for manifest in /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml; do
    if [ -f "$manifest" ]; then
        echo "$manifest exists"
    else
        echo "$manifest is missing"
        exit 1
    fi
done

sleep 10

APISERVER_STATUS=$(kubectl get pod kube-apiserver-controlplane -n kube-system -o jsonpath='{.status.phase}')
if [[ "$APISERVER_STATUS" != "Running" ]]; then
    echo "kube-apiserver-controlplane pod is not running yet"
    kubectl get pod kube-apiserver-control-plane -n kube-system
    exit 1
fi

CONTROLLER_STATUS=$(kubectl get pod kube-controller-manager-controlplane -n kube-system -o jsonpath='{.status.phase}')
if [[ "$CONTROLLER_STATUS" != "Running" ]]; then
    echo "kube-controller-manager-control-plane pod is not running yet"
    kubectl get pod kube-controller-manager-control-plane -n kube-system
    exit 1
fi
