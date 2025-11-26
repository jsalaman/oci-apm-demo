# OCI APM Demo on OKE (Java Spring Boot)

End-to-end demo: Spring Boot app in **OKE**, instrumented with **OCI APM Java Agent** via **OpenTelemetry Operator**.

## What it shows
- Distributed tracing (Trace Explorer) for `/api/checkout` with a downstream HTTP call.
- Quick exposure via LoadBalancer.
- Zero code changes for APM — agent auto-injected by the operator.

## Prerequisites
- OCI CLI configured.
- `kubectl`, `docker`, `maven`, and `jq` installed.

## Steps
1) Configure the demo:
- Edit `scripts/00-variables.sh` and set the required values.

2) Export variables and create `.env` file:
```bash
./scripts/00b-export-variables.sh
```

3) Create the necessary OCI resources:
```bash
./scripts/00-create-prerequisites.sh
```

4) Build and push the image to OCIR:
```bash
./scripts/01-build-push-ocir.sh
```

5) Deploy to OKE:
```bash
./scripts/02-deploy-oke.sh
```

6) Generate traffic:
```bash
./scripts/03-load-test-checkout.sh
```
Open **OCI Console → Application Performance Monitoring → Trace Explorer**.


## Cleanup
```bash
./scripts/99-teardown.sh
```

(c) 2025 Demo. MIT License.
