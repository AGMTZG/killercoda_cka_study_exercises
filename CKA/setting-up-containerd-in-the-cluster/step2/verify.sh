#!/bin/bash

if systemctl list-unit-files | grep -q "^containerd.service"; then
    echo "containerd service exists."
else
    echo "containerd service does NOT exist."
    exit 1
fi

if systemctl is-active --quiet containerd; then
    echo "containerd service is running."
else
    echo "containerd service is NOT running."
    exit 1
fi

if command -v containerd &> /dev/null; then
    echo "containerd binary found:"
    containerd --version
else
    echo "containerd binary not found in PATH."
    exit 1
fi
