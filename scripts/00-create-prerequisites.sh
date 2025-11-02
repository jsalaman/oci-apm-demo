#!/usr/bin/env bash
set -euo pipefail

# Placeholder values - replace with your actual values
COMPARTMENT_ID="<your_compartment_id>"
REGION="<your_region>"
VCN_ID="<your_vcn_id>"
SUBNET_ID="<your_subnet_id>"
IMAGE_ID="<your_image_id>"
OKE_CLUSTER_NAME="apm-demo-cluster"
OCIR_REPO_NAME="apm-demo-repo"
APM_DOMAIN_NAME="apm-demo-domain"

echo "Creating OKE Cluster..."
oci ce cluster create \
  --compartment-id $COMPARTMENT_ID \
  --name $OKE_CLUSTER_NAME \
  --kubernetes-version "v1.28.2" \
  --vcn-id $VCN_ID \
  --region $REGION \
  --node-pool-details '{
    "name": "nodepool1",
    "nodeShape": "VM.Standard.E4.Flex",
    "nodeShapeConfig": {
      "ocpus": 1,
      "memoryInGBs": 16
    },
    "placementConfigs": [
      {
        "availabilityDomain": "Uocm:US-ASHBURN-AD-1",
        "subnetId": "'$SUBNET_ID'"
      }
    ],
    "size": 1,
    "nodeSourceDetails": {
      "sourceType": "IMAGE",
      "imageId": "'$IMAGE_ID'"
    }
  }' \
  --wait-for-state SUCCEEDED

echo "Creating OCIR Repository..."
oci artifacts container repository create \
  --compartment-id $COMPARTMENT_ID \
  --display-name $OCIR_REPO_NAME \
  --is-public true

echo "Creating APM Domain..."
oci apm-control-plane apm-domain create \
  --compartment-id $COMPARTMENT_ID \
  --display-name $APM_DOMAIN_NAME \
  --is-free-tier "true"

echo "Prerequisites created successfully."
