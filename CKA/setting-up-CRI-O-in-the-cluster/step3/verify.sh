#!/bin/bash
set -e

iptables_empty=true

if [ -n "$(sudo iptables -S)" ]; then
    echo "Error: Filter table rules still exist"
    iptables_empty=false
fi

if [ -n "$(sudo iptables -t nat -S)" ]; then
    echo "Error: NAT table rules still exist"
    iptables_empty=false
fi

if [ -n "$(sudo iptables -t mangle -S)" ]; then
    echo "Error: Mangle table rules still exist"
    iptables_empty=false
fi

if [ "$iptables_empty" = true ]; then
    echo "Verification passed: iptables tables are empty"
    exit 0
else
    echo "Verification failed"
    exit 1
fi
