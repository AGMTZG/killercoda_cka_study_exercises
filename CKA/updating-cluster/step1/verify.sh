#!/bin/bash

NODE=$(hostname)
if [[ "$NODE" == "ubuntu" ]]; then
    echo "Connected to controlplane(ubuntu)"
else
    echo "You are not on the controlplane(ubuntu) node"
    exit 1
fi

kubectl get nodes >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Cluster nodes are reachable"
else
    echo "Cluster nodes not reachable"
    exit 1
fi
