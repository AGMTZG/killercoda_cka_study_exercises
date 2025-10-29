#!/bin/bash

NODE=$(hostname)
if [[ "$NODE" == "controlplane" ]]; then
    echo "Connected to controlplane"
else
    echo "You are not on the controlplane node"
    exit 1
fi

kubectl get nodes >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Cluster nodes are reachable"
else
    echo "Cluster nodes not reachable"
    exit 1
fi
