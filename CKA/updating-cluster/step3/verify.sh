#!/bin/bash

if kubeadm upgrade plan &> /dev/null; then
  echo "kubeadm upgrade plan ran successfully"
else
  echo "kubeadm upgrade plan failed"
  exit 1
fi

if apt-mark showhold | grep -q "^kubeadm$"; then
  echo "kubeadm is on hold"
  exit 1
else
  echo "kubeadm is not on hold"
fi
