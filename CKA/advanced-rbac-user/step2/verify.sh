#!/bin/bash
if [ -f "alice.crt" ]; then
  echo "alice.crt found and certificate approved."
  exit 0
else
  echo "Certificate not found. Ensure you approved and extracted it correctly."
  exit 1
fi
