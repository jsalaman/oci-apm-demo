#!/bin/bash
# (c) 2024 Demo. MIT License
set -euo pipefail

# Load configuration
# =======================
source .env

# Get external IP
# =======================
printf "INFO: Getting external IP...\n"
EXTERNAL_IP=""
while [ -z "$EXTERNAL_IP" ]; do
  EXTERNAL_IP=$(kubectl -n "$K8S_NAMESPACE" get svc apm-demo-svc -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  [ -z "$EXTERNAL_IP" ] && printf "Waiting for external IP...\n" && sleep 10
done

# Load test
# =======================
printf "INFO: Generating requests...\n"
for i in {1..20}; do
  curl -X POST "http://$EXTERNAL_IP/api/checkout" \
    -H "Content-Type: application/json" \
    -d '{"productId": "123", "quantity": 1}'
  sleep 1
done

printf "INFO: Done.\n"
