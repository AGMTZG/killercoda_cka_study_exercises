#!/bin/bash
set -e

swapoff -a
modprobe -a br_netfilter overlay
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet=1.34.0-1.1 kubeadm=1.34.0-1.1 kubectl=1.34.0-1.1
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet
kubeadm init --cri-socket=unix:///var/run/containerd/containerd.sock --kubernetes-version=v1.34.0 --ignore-preflight-errors=NumCPU
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
