#!/bin/bash

KUBELET_VER=$(kubelet --version | awk '{print $2}')
TARGET_VER="v1.33.5"
if [[ "$KUBELET_VER" == "$TARGET_VER" ]]; then
    echo "kubelet upgraded to $TARGET_VER"
else
    echo "kubelet version is $KUBELET_VER, expected $TARGET_VER"
    exit 1
fi

if apt-mark showhold | grep -q "^kubelet$"; then
  echo "kubelet is on hold"
  exit 1
else
  echo "kubelet is not on hold"
fi

SCHEDULABLE=$(kubectl get node control-plane -o jsonpath='{.spec.unschedulable}')
if [[ "$SCHEDULABLE" == "" ]]; then
    echo "Node is schedulable"
else
    echo "Node is still cordoned"
    exit 1
fi
