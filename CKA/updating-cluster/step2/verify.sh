#!/bin/bash

KUBEADM_VER=$(kubeadm version -o short)
TARGET_VER="v1.34.1"
if [[ "$KUBEADM_VER" == "$TARGET_VER" ]]; then
    echo "kubeadm is at the correct version $TARGET_VER"
else
    echo "kubeadm version is $KUBEADM_VER, expected $TARGET_VER"
    exit 1
fi
