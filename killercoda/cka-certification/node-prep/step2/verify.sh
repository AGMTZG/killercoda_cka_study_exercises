#!/bin/bash

if lsmod | grep -q br_netfilter; then
    echo "br_netfilter module is loaded"
else
    echo "br_netfilter module is NOT loaded"
    exit 1
fi

if lsmod | grep -q overlay; then
    echo "overlay module is loaded"
else
    echo "overlay module is NOT loaded"
    exit 1
fi
