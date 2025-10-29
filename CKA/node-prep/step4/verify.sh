#!/bin/bash

# Verify that the hostname is set
HOSTNAME=$(hostnamectl --static)

if [ -n "$HOSTNAME" ]; then
    echo "Hostname is set: $HOSTNAME"
else
    echo "Hostname is NOT set"
    exit 1
fi
