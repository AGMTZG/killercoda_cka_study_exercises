#!/bin/bash
set -e

swapoff -a
modprobe -a br_netfilter overlay
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
apt-get update
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get install -y --no-install-recommends \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet
dpkg --configure -a
mandb -c || true
if command -v needrestart >/dev/null; then
    NEEDRESTART_MODE=l needrestart || true
fi
systemctl daemon-reload
kubeadm init --cri-socket=unix:///var/run/containerd/containerd.sock
