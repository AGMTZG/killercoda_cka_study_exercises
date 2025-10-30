#!/bin/bash

if [ -f /etc/kubernetes/admin.conf ]; then
    echo "Cluster initialized"
    exit 0
else
    echo "Cluster not initialized"
    exit 1
fi
