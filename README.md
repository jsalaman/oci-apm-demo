# OCI APM Demo on OKE (Java Spring Boot)

End-to-end demo: Spring Boot app in **OKE**, instrumented with **OCI APM Java Agent** via **OpenTelemetry Operator**.

## What it shows
- Distributed tracing (Trace Explorer) for `/api/checkout` with a downstream HTTP call.
- Quick exposure via LoadBalancer.
- Zero code changes for APM — agent auto-injected by the operator.

## Prerequisites
- OKE cluster, OCIR repo, and an **APM Domain** already created.
- APM values:
  - **Data Upload Endpoint** (e.g. `https://aaaaaaaa.apm-agt.us-ashburn-1.oci.oraclecloud.com`)
  - **Private Data Key**
- kubectl configured for OKE, Docker & Maven installed.

## Steps
1) Build and push the image to OCIR:
```bash
./scripts/01-build-push-ocir.sh
```
Then edit `k8s/10-app.yaml` and set your image under `spec.template.spec.containers[0].image`.

2) Configure the APM Instrumentation (`k8s/20-otel-instrumentation.yaml`):
- Set `OTEL_com_oracle_apm_agent_data_upload_endpoint`
- Set `OTEL_com_oracle_apm_agent_private_data_key`

3) Deploy to OKE:
```bash
./scripts/02-deploy-oke.sh
```
Wait for `EXTERNAL-IP` of `apm-demo-svc`.

4) Generate traffic:
```bash
./scripts/03-load-test-checkout.sh
```
Open **OCI Console → Application Performance Monitoring → Trace Explorer**.


## Cleanup
```bash
./scripts/99-teardown.sh
```

(c) 2025 Demo. MIT License.
