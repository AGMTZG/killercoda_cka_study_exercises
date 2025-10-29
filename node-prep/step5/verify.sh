#!/bin/bash

PORTS=(6443 2379 2380 10250)
ALL_OPEN=1

for PORT in "${PORTS[@]}"; do
    if ss -tuln | grep -q ":$PORT "; then
        echo "Port $PORT is open"
    else
        echo "Port $PORT is NOT open"
        ALL_OPEN=0
    fi
done

if [ $ALL_OPEN -eq 1 ]; then
    echo "All required ports are open"
    exit 0
else
    echo "Some required ports are closed, please open them before proceeding"
    exit 1
fi
