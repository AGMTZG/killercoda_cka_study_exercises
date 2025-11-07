#!/bin/bash

if kubeadm upgrade plan &> /dev/null; then
  echo "kubeadm upgrade plan ran successfully"
else
  echo "kubeadm upgrade plan failed"
  exit 1
fi
