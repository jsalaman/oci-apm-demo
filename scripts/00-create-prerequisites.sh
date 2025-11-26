#!/bin/bash
# (c) 2024 Demo. MIT License
set -euo pipefail

# Load configuration
# =======================
source .env

# OKE Cluster
# =======================
printf "INFO: Creating OKE cluster...\n"
oci ce cluster create \
  --compartment-id "$COMPARTMENT_ID" \
  --name "$OKE_CLUSTER_NAME" \
  --kubernetes-version "$KUBERNETES_VERSION" \
  --vcn-id "$VCN_ID" \
  --endpoint-subnet-id "$SUBNET_ID" \
  --service-lb-subnet-ids "[\"$SUBNET_ID\"]" \
  --node-pool-details '{
      "name": "np1",
      "compartmentId": "'"$COMPARTMENT_ID"'",
      "kubernetesVersion": "'"$KUBERNETES_VERSION"'",
      "nodeShape": "'"$OKE_NODE_SHAPE"'",
      "nodeShapeConfig": {
        "ocpus": 1,
        "memoryInGBs": 16
      },
      "placementConfigs": [
        {
          "availabilityDomain": "'"$OKE_AD"'",
          "subnetId": "'"$SUBNET_ID"'"
        }
      ],
      "size": 1,
      "nodeSourceDetails": {
        "sourceType": "IMAGE",
        "imageId": "'"$IMAGE_ID"'"
      }
    }' \
  --wait-for-state "ACTIVE"

# OCIR Repo
# =======================
printf "INFO: Creating OCIR repo...\n"
oci artifacts container-repository create \
  --compartment-id "$COMPARTMENT_ID" \
  --display-name "$OCIR_REPO_NAME" \
  --is-public true

# APM Domain
# =======================
printf "INFO: Creating APM Domain...\n"
oci apm-control-plane apm-domain create \
  --compartment-id "$COMPARTMENT_ID" \
  --display-name "$APM_DOMAIN_NAME" \
  --is-free-tier true \
  --wait-for-state "ACTIVE"

printf "INFO: Done.\n"
