#!/bin/bash
set -e

iptables_empty=true

if [ "$(sudo iptables -S | grep -v '^-' | wc -l)" -ne 0 ]; then
    echo "Error: Filter table rules still exist"
    iptables_empty=false
fi

if [ "$(sudo iptables -t nat -S | grep -v '^-' | wc -l)" -ne 0 ]; then
    echo "Error: NAT table rules still exist"
    iptables_empty=false
fi

if [ "$(sudo iptables -t mangle -S | grep -v '^-' | wc -l)" -ne 0 ]; then
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
