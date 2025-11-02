#!/usr/bin/env bash
set -euo pipefail

# Placeholder values - replace with your actual values
COMPARTMENT_ID="<your_compartment_id>"
OKE_CLUSTER_NAME="apm-demo-cluster"
OCIR_REPO_NAME="apm-demo-repo"
APM_DOMAIN_NAME="apm-demo-domain"

echo "Deleting OKE Cluster..."
CLUSTER_ID=$(oci ce cluster list --compartment-id $COMPARTMENT_ID --name $OKE_CLUSTER_NAME --query "data[0].id" --raw-output)
if [ -n "$CLUSTER_ID" ]; then
  oci ce cluster delete --cluster-id $CLUSTER_ID --force --wait-for-state SUCCEEDED
fi

echo "Deleting OCIR Repository..."
REPO_ID=$(oci artifacts container repository list --compartment-id $COMPARTMENT_ID --display-name $OCIR_REPO_NAME --query "data.items[0].id" --raw-output)
if [ -n "$REPO_ID" ]; then
    oci artifacts container repository delete --repository-id $REPO_ID --force
fi

echo "Deleting APM Domain..."
APM_DOMAIN_ID=$(oci apm-control-plane apm-domain list --compartment-id $COMPARTMENT_ID --display-name $APM_DOMAIN_NAME --query "data.items[0].id" --raw-output)
if [ -n "$APM_DOMAIN_ID" ]; then
  oci apm-control-plane apm-domain delete --apm-domain-id $APM_DOMAIN_ID --force --wait-for-state SUCCEEDED
fi

kubectl delete -f k8s/10-app.yaml || true
kubectl delete -f k8s/20-otel-instrumentation.yaml || true
kubectl delete -f k8s/00-namespace.yaml || true
