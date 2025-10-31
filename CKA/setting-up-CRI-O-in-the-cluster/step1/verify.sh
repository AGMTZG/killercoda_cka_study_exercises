#!/bin/bash
set -e
if ! systemctl is-active --quiet kubelet && ! systemctl is-active --quiet containerd; then
    echo "Services stopped"
    exit 0
else
    echo "Services running"
    exit 1
fi
