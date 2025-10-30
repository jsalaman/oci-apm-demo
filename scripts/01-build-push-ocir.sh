#!/usr/bin/env bash
set -euo pipefail

OCI_USER=juan.salamanca@oracle.com
TENANCY_NS=yzpk9kei2fk7    # oci iam tenant
REGION_SHORT=sa-santiago-1              # fra/phx/syd...
REPO="ocir.${REGION_SHORT}.oci.oraclecloud.com/${TENANCY_NS}/demo/apm-demo"
TAG="v1"
IMAGE="${REPO}:${TAG}"
USER="${TENANCY_NS}/${OCI_USER}"
AUTH_TOKEN="w_1b9C_WP{nnV49ITeX+"

cd "$(dirname "$0")/.."
APP_DIR="app"

echo "[1/4] Docker login to OCIR..."
echo "${AUTH_TOKEN}" | docker login "${REGION_SHORT}.ocir.io" -u "${USER}" --password-stdin

echo "[2/4] Build image..."
docker build -t "${IMAGE}" "${APP_DIR}"

echo "[3/4] Push image..."
docker push "${IMAGE}"

echo "[4/4] Done. Use image: ${IMAGE}"