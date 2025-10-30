#!/bin/bash
if whoami | grep -q "ubuntu"; then
  echo "SSH verified"
  exit 0
else
  echo "You are not logged in as ubuntu"
  exit 1
fi
