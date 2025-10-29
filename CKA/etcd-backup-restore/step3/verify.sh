#!/bin/bash

APISERVER_STATUS=$(kubectl get pod kube-apiserver-controlplane -n kube-system -o jsonpath='{.status.phase}')
CONTROLLER_STATUS=$(kubectl get pod kube-controller-manager-controlplane -n kube-system -o jsonpath='{.status.phase}')

if [[ "$APISERVER_STATUS" == "Running" && "$CONTROLLER_STATUS" == "Running" ]]; then
    echo "Disaster recovery simulation successful: pods have been recreated and are running."
else
    echo "Pods are not yet running. Current status:"
    kubectl get pod kube-apiserver-controlplane kube-controller-manager-controlplane -n kube-system
    exit 1
fi
