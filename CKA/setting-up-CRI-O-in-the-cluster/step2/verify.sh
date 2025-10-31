#!/bin/bash
set -e

DIRS=(/etc/cni/net.d /var/lib/kubelet /var/lib/cni /var/lib/etcd /var/run/kubernetes)
all_erased=true

for d in "${DIRS[@]}"; do
    if [ -e "$d" ]; then
        echo "Error: $d still exists"
        all_erased=false
    fi
done

if [ "$all_erased" = true ]; then
    echo "All directories erased successfully"
    exit 0
else
    exit 1
fi
