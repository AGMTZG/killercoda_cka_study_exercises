#!/bin/bash

installed_kubeadm=$(kubeadm version -o short)
installed_kubelet=$(kubelet --version 2>/dev/null | awk '{print $2}')

if [ "$installed_kubelet" == "$installed_kubeadm" ]; then
    echo "kubelet matches kubeadm version"
else
    echo "kubelet version ($installed_kubelet) does not match kubeadm ($installed_kubeadm)"
    exit 1
fi

if apt-mark showhold | grep -q "^kubelet$"; then
  echo "kubelet is on hold"
else
  echo "kubelet is not on hold"
  exit 1
fi

SCHEDULABLE=$(kubectl get node ubuntu -o jsonpath='{.spec.unschedulable}')
if [[ "$SCHEDULABLE" == "" ]]; then
    echo "Node is schedulable"
else
    echo "Node is still cordoned"
    exit 1
fi
