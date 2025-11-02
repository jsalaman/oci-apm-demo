# OCI APM Demo on OKE (Java Spring Boot)

End-to-end demo: Spring Boot app in **OKE**, instrumented with **OCI APM Java Agent** via **OpenTelemetry Operator**.

## What it shows
- Distributed tracing (Trace Explorer) for `/api/checkout` with a downstream HTTP call.
- Quick exposure via LoadBalancer.
- Zero code changes for APM — agent auto-injected by the operator.

## Prerequisites
- OCI CLI configured.
- `kubectl`, `docker`, and `maven` installed.
- The following values need to be set in `scripts/00-create-prerequisites.sh` and `scripts/99-teardown.sh`:
  - `COMPARTMENT_ID`
  - `REGION`
  - `VCN_ID`
  - `SUBNET_ID`
  - `IMAGE_ID`
- **Note:** You may also need to update the `availabilityDomain` in `scripts/00-create-prerequisites.sh` to match your region.

## Steps
1) Create the necessary OCI resources:
```bash
./scripts/00-create-prerequisites.sh
```

2) Build and push the image to OCIR:
```bash
./scripts/01-build-push-ocir.sh
```
Then edit `k8s/10-app.yaml` and set your image under `spec.template.spec.containers[0].image`.

3) Configure the APM Instrumentation (`k8s/20-otel-instrumentation.yaml`):
- Set `OTEL_com_oracle_apm_agent_data_upload_endpoint`
- Set `OTEL_com_oracle_apm_agent_private_data_key`

4) Deploy to OKE:
```bash
./scripts/02-deploy-oke.sh
```
Wait for `EXTERNAL-IP` of `apm-demo-svc`.

5) Generate traffic:
```bash
./scripts/03-load-test-checkout.sh
```
Open **OCI Console → Application Performance Monitoring → Trace Explorer**.


## Cleanup
```bash
./scripts/99-teardown.sh
```

(c) 2025 Demo. MIT License.
