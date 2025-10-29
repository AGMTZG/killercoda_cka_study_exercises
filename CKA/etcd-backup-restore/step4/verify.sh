#!/bin/bash

if [ -d /mnt/etcd-data/member ]; then
  echo "done"
else
  echo "Restored etcd data not found in /mnt/etcd-data"
  exit 1
fi
