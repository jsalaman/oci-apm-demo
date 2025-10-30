#!/usr/bin/env bash
set -euo pipefail
kubectl delete -f k8s/10-app.yaml || true
kubectl delete -f k8s/20-otel-instrumentation.yaml || true
kubectl delete -f k8s/00-namespace.yaml || true
