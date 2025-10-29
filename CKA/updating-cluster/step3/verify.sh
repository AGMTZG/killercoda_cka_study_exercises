#!/bin/bash

CONTROL_VER=$(kubectl get nodes -o jsonpath='{.items[?(@.metadata.name=="control-plane")].status.nodeInfo.kubeletVersion}')
TARGET_VER="v1.33.5"
if [[ "$CONTROL_VER" == "$TARGET_VER" ]]; then
    echo "Control-plane upgraded to $TARGET_VER"
else
    echo "Control-plane version is $CONTROL_VER, expected $TARGET_VER"
    exit 1
fi
