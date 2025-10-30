#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="demo-apm"
MANIFEST_DIR="$(dirname "$0")/../k8s"

echo "[1/6] Create namespace (if not exists)"
kubectl apply -f "${MANIFEST_DIR}/00-namespace.yaml"

echo "[2/6] Install cert-manager and OpenTelemetry Operator (if absent)"
kubectl get ns cert-manager >/dev/null 2>&1 ||   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.2/cert-manager.yaml
kubectl get ns opentelemetry-operator-system >/dev/null 2>&1 ||   kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

echo "[3/6] Apply Instrumentation CR for OCI APM Java Agent"
kubectl apply -f "${MANIFEST_DIR}/20-otel-instrumentation.yaml"

echo "[4/6] Enable auto-injection on namespace"
kubectl annotate namespace "${NAMESPACE}" instrumentation.opentelemetry.io/inject-java="opentelemetry-operator-system/inst-apm-java" --overwrite

echo "[5/6] Creating OCIR secret on namespace"
kubectl create secret docker-registry ocir-secret \
    --namespace demo-apm \
    --docker-server=ocir.sa-santiago-1.oci.oraclecloud.com \
    --docker-username="yzpk9kei2fk7/juan.salamanca@oracle.com" \
    --docker-password="g3P15MCL1i[5p>Okg{Qf" \
    --docker-email="juan.salamanca@oracle.com"

echo "[6/6] Deploy app and expose via LoadBalancer"
kubectl apply -f "${MANIFEST_DIR}/10-app.yaml"
kubectl rollout status deploy/apm-demo -n "${NAMESPACE}"
kubectl get svc -n "${NAMESPACE}"
echo ">> Get EXTERNAL-IP above and test: curl http://<EXTERNAL-IP>/api/checkout"