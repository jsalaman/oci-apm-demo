#!/bin/bash
# (c) 2024 Demo. MIT License
set -euo pipefail

# Load configuration
# =======================
source .env

# K8s resources
# =======================
printf "INFO: Deleting K8s namespace...\n"
kubectl delete namespace "$K8S_NAMESPACE" --ignore-not-found

# OKE Cluster
# =======================
printf "INFO: Deleting OKE cluster...\n"
oci ce cluster delete --cluster-id "$OKE_CLUSTER_OCID" --force --wait-for-state "DELETED"

# OCIR Repo
# =======================
printf "INFO: Deleting OCIR repo...\n"
OCIR_REPO_ID=$(oci artifacts container-repository list --compartment-id "$COMPARTMENT_ID" --display-name "$OCIR_REPO_NAME" --query "data.items[0].id" --raw-output)
oci artifacts container-repository delete --repository-id "$OCIR_REPO_ID" --force || true

# APM Domain
# =======================
printf "INFO: Deleting APM Domain...\n"
APM_DOMAIN_ID=$(oci apm-control-plane apm-domain list --compartment-id "$COMPARTMENT_ID" --display-name "$APM_DOMAIN_NAME" --query "items[0].id" --raw-output)
oci apm-control-plane apm-domain delete --apm-domain-id "$APM_DOMAIN_ID" --force --wait-for-state "DELETED"

printf "INFO: Done.\n"
