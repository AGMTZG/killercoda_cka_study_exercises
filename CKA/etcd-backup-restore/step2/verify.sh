#!/bin/bash
if [ -f /backup/etcd-snapshot.db ]; then
  echo "done"
else
  echo "Snapshot not found at /backup/etcd-snapshot.db"
  exit 1
fi
