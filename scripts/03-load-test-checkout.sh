#!/usr/bin/env bash
export URL="http://159.112.143.92"   # o tu FQDN si usas Ingress

for i in {1..20}; do
  curl -s -o /dev/null -w "%{http_code}\n" "$URL/api/checkout"
  sleep 0.2
done