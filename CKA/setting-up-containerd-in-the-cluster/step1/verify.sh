#!/bin/bash

NODE=$(hostname)
if [[ "$NODE" == "ubuntu" ]]; then
    echo "Connected to ubuntu"
else
    echo "You are not on the ubuntu node"
    exit 1
fi
