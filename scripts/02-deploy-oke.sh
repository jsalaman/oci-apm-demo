#!/bin/bash
# (c) 2024 Demo. MIT License
set -euo pipefail

# Load configuration
# =======================
source .env

# Get OKE credentials
# =======================
printf "INFO: Getting OKE credentials...\n"
oci ce cluster create-kubeconfig --cluster-id "$OKE_CLUSTER_OCID" --file "$KUBECONFIG" --region "$REGION" --token-version 2.0.0 --overwrite

# Install OTEL Operator
# =======================
printf "INFO: Installing OpenTelemetry Operator...\n"
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

# Deploy to OKE
# =======================
printf "INFO: Deploying to OKE...\n"
kubectl apply -f k8s/00-namespace.yaml

# Enable auto-instrumentation
# =======================
printf "INFO: Enabling auto-instrumentation...\n"
kubectl annotate namespace "$K8S_NAMESPACE" opentelemetry-instrumentation=enabled --overwrite

# Create secrets
# =======================
printf "INFO: Creating secrets...\n"
kubectl -n "$K8S_NAMESPACE" create secret docker-registry ocir-secret --docker-server="$REGION.ocir.io" --docker-username="$TF_VAR_tenancy_namespace/oci.auth.token" --docker-password="$AUTH_TOKEN" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$K8S_NAMESPACE" create secret generic apm-secret --from-literal=private-data-key="$APM_PRIVATE_DATA_KEY" --dry-run=client -o yaml | kubectl apply -f -

# Deploy app and instrumentation
# =======================
printf "INFO: Deploying app and instrumentation...\n"
envsubst < k8s/10-app.yaml | kubectl -n "$K8S_NAMESPACE" apply -f -
envsubst < k8s/20-otel-instrumentation.yaml | kubectl apply -f -

printf "INFO: Done.\n"
