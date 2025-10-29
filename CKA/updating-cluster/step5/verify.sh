#!/bin/bash

KUBECTL_VER=$(kubectl version --client --short | awk '{print $3}')
TARGET_VER="v1.33.5"
if [[ "$KUBECTL_VER" == "$TARGET_VER" ]]; then
    echo "kubectl upgraded to $TARGET_VER"
else
    echo "kubectl version is $KUBECTL_VER, expected $TARGET_VER"
    exit 1
fi

if apt-mark showhold | grep -q "^kubectl$"; then
  echo "kubectl is on hold"
else
  echo "kubectl is not on hold"
  exit 1
fi
