#!/bin/bash
# (c) 2024 Demo. MIT License

# Compartment and Region
# =======================
export COMPARTMENT_ID="ocid1.compartment.oc1..aaaaaaaa..."
export REGION="sa-santiago-1"

# OKE Cluster
# =======================
export VCN_ID="ocid1.vcn.oc1..aaaaaaaa..."
export SUBNET_ID="ocid1.subnet.oc1..aaaaaaaa..."
export IMAGE_ID="ocid1.image.oc1..aaaaaaaa..."
export OKE_CLUSTER_NAME="oke-apm-demo"
export OKE_NODE_SHAPE="VM.Standard.E4.Flex"
export OKE_AD="SA-SANTIAGO-1-AD-1" # Update to match your REGION
export K8S_NAMESPACE="demo-apm"
export KUBECONFIG=~/.kube/config

# Container Registry
# =======================
export AUTH_TOKEN="your-auth-token" # OCI Auth Token
export OCIR_REPO_NAME="apm-demo"
export APP_IMAGE_NAME="apm-demo"
export APP_IMAGE_TAG="v1"

# APM Domain
# =======================
export APM_DOMAIN_NAME="ApmDemo"
