#!/bin/bash

BR_IPTABLES=$(sysctl -n net.bridge.bridge-nf-call-iptables)
IPV6_FORWARD=$(sysctl -n net.ipv6.conf.all.forwarding)
IPV4_FORWARD=$(sysctl -n net.ipv4.ip_forward)

if [ "$BR_IPTABLES" -eq 1 ]; then
    echo "net.bridge.bridge-nf-call-iptables is set to 1"
else
    echo "net.bridge.bridge-nf-call-iptables is NOT set correctly"
    exit 1
fi

if [ "$IPV6_FORWARD" -eq 1 ]; then
    echo "net.ipv6.conf.all.forwarding is set to 1"
else
    echo "net.ipv6.conf.all.forwarding is NOT set correctly"
    exit 1
fi

if [ "$IPV4_FORWARD" -eq 1 ]; then
    echo "net.ipv4.ip_forward is set to 1"
else
    echo "net.ipv4.ip_forward is NOT set correctly"
    exit 1
fi
