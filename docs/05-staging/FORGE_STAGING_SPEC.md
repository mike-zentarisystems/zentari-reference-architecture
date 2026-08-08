# Forge Staging Specification

## Purpose

Forge is the production-like proving ground. Changes destined for Atlas should be tested here first when practical.

## Initial VM

Name: `zentari-staging`

Suggested starting allocation:

- 4 vCPU
- 16 GB RAM
- 100 GB local disk
- Ubuntu 24.04 LTS
- Tailscale
- Docker + Docker Compose
- Git
- Caddy

Adjust only after measured usage.

## Baseline stack

Deploy from the same Git-tracked Compose definitions intended for Atlas, but with staging hostnames and isolated databases.

Initial services:

- PostgreSQL
- n8n staging
- LiteLLM staging if needed
- Caddy
- Twenty only under its staging profile

Do not enable outbound customer messaging or destructive integrations by default.

## Network rules

- Administrative access over Tailscale.
- No public database ports.
- Public ingress only when required for webhook/TLS validation.
- Use staging DNS names that cannot be confused with production.

## Promotion rule

A change can move to Atlas only when:

1. Compose config validates.
2. Containers become healthy.
3. Required HTTPS/WebSocket paths work.
4. Database backup exists before schema-changing upgrades.
5. Smoke tests pass.
6. Rollback/recovery steps are known.

## Staging is disposable

No unique authoritative data belongs here. If staging cannot be recreated from Git plus test fixtures, fix that before trusting it as a validation environment.
