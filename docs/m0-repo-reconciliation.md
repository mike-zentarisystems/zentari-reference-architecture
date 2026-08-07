# M0 Repository Reconciliation

**As of:** 2026-08-07

This document records evidence recovered from existing Zentari repositories. Repository state is treated as historical or design evidence unless it is corroborated by a live host capture.

## Evidence sources

| Repository | What it proves or strongly indicates | Confidence |
|---|---|---|
| `mike-zentarisystems/zentari-ops` | Production VPS architecture, Compose services, Tailscale management, Restic to Backblaze B2 | High for repo-defined state; live runtime still requires capture |
| `mike-zentarisystems/citidel` | Citadel service layout as captured 2026-07-03 | Medium; stale snapshot |
| `mike-zentarisystems/zentari-logging` | Intended Proxmox observability and operations architecture | Medium for intent, low for live deployment |
| `mike-zentarisystems/oracle-hermes` | Intended Oracle Hermes architecture and security posture | Medium for intent; live systemd state unknown |
| `mike-zentarisystems/buzz-all-in-one` | Intended isolated Proxmox AI-development VM architecture | Medium for intent, low for live deployment |

## Production VPS

`zentari-ops` establishes that the VPS is already a real production platform rather than an empty host. The repository defines:

- Traefik
- n8n main and worker in queue mode
- PostgreSQL 15
- Redis 7
- LiteLLM
- Open WebUI
- Vaultwarden
- Portainer
- Uptime Kuma
- Homepage
- CoreDNS
- Watchtower container updater
- Prometheus
- Grafana
- node-exporter
- cAdvisor
- postgres-exporter
- Restic backups to Backblaze B2

The production VPS therefore remains the current authority for production n8n, production PostgreSQL, Redis and the production LiteLLM gateway until an explicit migration is completed.

## Citadel

The July 3 `citidel/current_state.md` snapshot showed a much broader service footprint than the target role now allows. Historical containers included Hermes, Ollama, LiteLLM, n8n, PostgreSQL/pgvector, Valkey, Qdrant, MinIO, AnythingLLM, Traefik, Uptime Kuma, Browserless, OpenCode, SearXNG, Stirling PDF, Honcho and additional custom services.

The target remains: **Citadel is Zentari-only AI compute.** A fresh live capture must identify which non-AI and duplicated services can be retired or migrated.

## Proxmox VM 104: `zentari-buzz`

The VM name aligns with `buzz-all-in-one`. That repository describes an isolated Proxmox AI-development server with:

- Coolify
- Buzz
- OmniRoute
- Goose
- OpenCode
- status dashboard
- maintenance and audit tooling

This is not proof those components are currently running. It is sufficient to classify VM 104 as a likely historical AI-development sandbox and to prioritize a live inventory before deletion or repurposing.

Production LiteLLM remains canonical. OmniRoute in VM 104 must not become a second production authority unless a future ADR explicitly changes the routing standard.

## Proxmox VM 105: `zentari-observability`

The VM name aligns with `zentari-logging`. Its core Compose stack defines:

- Grafana
- Prometheus
- Loki
- Grafana Alloy
- Alertmanager
- Uptime Kuma
- Blackbox Exporter
- OpenTelemetry Collector
- node-exporter
- cAdvisor

The repository also proposes, as separate failure domains:

- Langfuse
- PostHog
- Coolify
- Gitea + PostgreSQL
- Proxmox Backup Server
- Restic to Backblaze B2

The separate services are design intent, not confirmed live deployments.

**Decision gate:** do not deploy another full Grafana/Prometheus/Loki stack on Oracle until VM 105 is inspected. If VM 105 is healthy and close to the repository design, it should become the central observability core while Oracle supplies the offsite/external viewpoint.

## Oracle OCI

`oracle-hermes` describes an ARM64 Oracle Linux node with native/systemd Hermes, Tailscale-only management, local-only WebUI by default and optional API bridge, Telegram, tiny Ollama and Citadel routing.

The repository explicitly treats Oracle as an always-on agent control node and keeps serious local inference on Citadel. This aligns with the target Watchtower role.

The live Oracle VM must still be checked for:

- OS/version
- enabled systemd units
- Hermes version
- WebUI/API/Telegram modules actually installed
- Tailscale state
- listening ports
- firewall/OCI security-list exposure
- backup jobs
- any LiteLLM/Ollama leftovers

## Reconciliation decisions now safe to make

1. Keep production n8n on the VPS.
2. Keep production LiteLLM on the VPS for now.
3. Keep production PostgreSQL and Redis workload-local on the VPS.
4. Keep Hermes primary on Citadel and Hermes secondary on Oracle.
5. Treat Citadel n8n/LiteLLM/monitoring as duplicate candidates pending live dependency checks.
6. Treat VM 104 as an AI-development/lab candidate, not production.
7. Treat VM 105 as the leading candidate for central observability, pending live validation.
8. Do not install a third observability stack before VM 105 is inspected.
9. Keep Backblaze B2 as the offsite backup authority.
10. Keep Oracle free of customer systems of record.

## Next live captures

### VM 105

```bash
sudo bash scripts/collect-host-inventory.sh > inventory-vm105-$(date +%F).txt
```

Also collect:

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker compose ls
ss -tulpn
systemctl --type=service --state=running --no-pager
find /opt -maxdepth 3 -name 'docker-compose*.yml' -o -name 'compose*.yml' 2>/dev/null
```

### VM 104

Run the same collector and verify whether Coolify, Buzz, OmniRoute, Goose and OpenCode are still present or in use.

### Oracle

Run the collector plus:

```bash
systemctl status hermes-agent.service hermes-webui.service --no-pager
systemctl list-unit-files | grep -Ei 'hermes|ollama|litellm|telegram'
ss -tulpn
tailscale status
```

### Citadel

A fresh capture is required because the repository snapshot is from 2026-07-03 and many changes occurred afterward.
