#!/bin/bash

NODE=$(hostname)
if [[ "$NODE" == "control-plane" ]]; then
    echo "Connected to control-plane"
else
    echo "You are not on the control-plane node"
    exit 1
fi

kubectl get nodes >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Cluster nodes are reachable"
else
    echo "Cluster nodes not reachable"
    exit 1
fi
