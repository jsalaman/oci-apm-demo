#!/bin/bash
# (c) 2024 Demo. MIT License
set -euo pipefail

# Load configuration
# =======================
source .env

# Login to OCIR
# =======================
printf "INFO: Logging in to OCIR...\n"
echo "$AUTH_TOKEN" | docker login "$REGION.ocir.io" --username "$TF_VAR_tenancy_namespace/oci.auth.token" --password-stdin

# Build image
# =======================
printf "INFO: Building image...\n"
docker build -t "$OCIR_REPO_URL" app

# Push image to OCIR
# =======================
printf "INFO: Pushing image to OCIR...\n"
docker push "$OCIR_REPO_URL"

printf "INFO: Done.\n"
