# Zentari Current State

**As of:** 2026-08-07  
**Milestone:** M0 Inventory  
**Status:** In progress

This document records what is known to exist today. It is intentionally separate from the target architecture. Repository evidence is useful, but it is not treated as equivalent to a live host inventory unless the source itself contains a recent captured state.

## Executive summary

Zentari currently spans five infrastructure locations plus managed SaaS services:

1. **Production VPS** for business/customer production services.
2. **Citadel** for Zentari-only AI compute and the primary Hermes agent.
3. **Primary Proxmox host** for staging, development and current lab VMs.
4. **Dell R410 running ESXi 6.7** targeted for conversion to a second Proxmox infrastructure/backup host.
5. **Oracle OCI Ampere** with 4 OCPU, 24 GB RAM and 200 GB disk, currently hosting the secondary Hermes agent and targeted as the offsite Watchtower/DR node.
6. **Vercel/Cloudflare** for public-facing web applications.
7. **Backblaze B2** for offsite backup.

The two newly reconciled source repositories materially reduce M0 uncertainty:

- `mike-zentarisystems/zentari-ops` documents the production Hostinger VPS stack and should be treated as the current production configuration source pending live verification.
- `mike-zentarisystems/citidel` contains a captured Citadel current-state snapshot from 2026-07-03 plus the Citadel compose/runtime definitions. That snapshot is useful evidence but is stale enough that live validation is still required before retiring or moving services.

## Current host baseline

| Host | Current platform | Observed resources | Current role | M0 state |
|---|---|---|---|---|
| Production VPS (`atlas` target name) | AlmaLinux 10.x VPS | ~2 vCPU, ~7.7 GB RAM, 4 GB swap | Production business/customer backend | Repo-backed, live verification still required |
| Citadel | Bare metal | i7-6700, 16 GB RAM, RTX 3060 12 GB | Zentari AI compute, Hermes primary | Repo snapshot from 2026-07-03, live refresh required |
| Primary Proxmox (`forge`) | Proxmox VE 9.1.1 | 32 logical CPU, 125.85 GB RAM | Staging/development/lab | Host observed, guests incomplete |
| Dell R410 (`vault` target name) | ESXi 6.7 U2 | 12 logical CPU, 55.99 GB RAM, 1.81 TB datastore | Legacy virtualization, target backup/infrastructure Proxmox | Hardware observed, VM inventory required |
| Oracle (`watchtower`) | OCI Ampere ARM64 | 4 OCPU, 24 GB RAM, 200 GB disk | Hermes secondary, target external operations/DR | Partial inventory |

## Production VPS: repository-backed state

`zentari-ops` explicitly identifies itself as the production infrastructure repository for the Hostinger VPS, managed with Docker Compose, Traefik and Tailscale.

### Core production stack

`docker-compose.yml` currently defines:

- Traefik v3.6
- n8n main
- n8n worker
- PostgreSQL 15
- Redis 7

n8n is configured in queue mode with the worker using the same PostgreSQL database and Redis queue. The public n8n endpoint is `n8n.zentarisystems.io`.

### Production AI services

`docker-compose.ai.yml` defines:

- `zentari-litellm`
- `zentari-open-webui`

LiteLLM uses the production PostgreSQL service for its database and Redis for shared state/cache. Access is routed internally through Tailscale/Traefik rather than exposed as a general public management surface.

### Production internal services

`docker-compose.internal.yml` defines:

- Zentari Ops Panel
- Vaultwarden
- Portainer
- Uptime Kuma
- Homepage
- Watchtower
- CoreDNS

These are primarily Tailscale-only internal services.

### Production monitoring

`docker-compose.monitoring.yml` defines:

- Prometheus with 30-day retention
- Grafana
- node-exporter
- cAdvisor
- postgres-exporter

This confirms a monitoring stack already exists on the production VPS. The architecture must therefore migrate or federate this intentionally rather than creating an unrelated duplicate stack on Oracle or Proxmox.

### Production backup

`zentari-ops/docs/backup.md` documents a daily 02:00 restic backup to Backblaze B2 with:

- full PostgreSQL dump
- n8n workflow exports
- selected Docker named volumes
- `/opt/zentari-ops` repository/configuration
- 7 daily, 4 weekly and 3 monthly snapshots
- weekly repository integrity check
- Uptime Kuma push monitoring for backup success

This is a real existing backup design, not just a target-state proposal. M0 still needs proof of recent successful jobs and an actual restore test.

## Citadel: repository-backed state

The `citidel/current_state.md` snapshot was captured on 2026-07-03. At that time Citadel used Docker 29.4.1 with NVIDIA runtime enabled and placed Docker data under `/home/citadel/runtime/docker`.

### Confirmed in the 2026-07-03 snapshot

- Ollama running in Docker as `citadel-ollama`
- LiteLLM running in Docker as `citadel-litellm`
- Hermes primary as `citadel-hermes-agent`
- n8n as `citadel-n8n`
- PostgreSQL 16 with pgvector as `citadel-postgres`
- Valkey/Redis-compatible cache as `citadel-redis`
- Qdrant as `citadel-qdrant`
- MinIO
- Uptime Kuma
- Traefik
- AnythingLLM
- Browserless
- Portainer
- OpenCode
- SearXNG
- Stirling PDF
- Honcho API/deriver
- Zentari ingestion hub
- Zentari memory core
- Intelligence API
- Cockpit UI
- Hermes Web UI
- ntfy
- Cloudflared/DDNS components
- YouTube transcript API
- ScrapeGraph API
- RustDesk server components

The same snapshot shows approximately 875 GB mounted for `/home`, about 634 GB used and 241 GB free at capture time, with several historical model and Docker-volume locations still present. This strongly supports keeping Citadel focused on AI compute and cleaning up legacy/application services after live validation.

### Citadel consolidation implications

The repository evidence proves that at least two n8n instances and two LiteLLM instances existed across the production VPS and Citadel. It also proves separate PostgreSQL services existed on both systems. Therefore these are no longer merely suspected duplicates.

The target-state intent remains:

- production/business n8n on the VPS
- staging n8n on Proxmox
- Citadel n8n retired unless a documented AI-local workflow requires a dedicated instance
- production LiteLLM remains the canonical cloud/customer-facing gateway unless a later ADR changes placement
- Citadel LiteLLM may remain only as an AI-local gateway if it has a distinct documented purpose
- Citadel PostgreSQL should serve only Citadel-local AI state that cannot move cleanly to purpose-specific stores

No Citadel service should be removed based only on the 2026-07-03 snapshot. Live dependency checks come first.

## Primary Proxmox observed guests

The 2026-08-07 Proxmox screenshots confirm these guests exist:

| VMID | Name | Known resources/state |
|---:|---|---|
| 101 | `PNET4.2.4` | Resources not yet captured |
| 103 | `zentari-openmanus` | Resources not yet captured |
| 104 | `zentari-buzz` | Resources not yet captured |
| 105 | `zentari-observability` | Running, 4 vCPU, 8 GB RAM, 200 GB boot disk |

VM 105 remains a priority inventory item. Because production VPS monitoring is now confirmed, VM 105 must be inspected before any observability migration plan is finalized.

## Legacy VMware host

Observed from the ESXi screenshot:

- Dell PowerEdge R410
- VMware ESXi 6.7.0 Update 2, build 13006603
- 12 logical CPUs, Intel Xeon E5645 @ 2.40 GHz
- 55.99 GB RAM
- 1.81 TB datastore, approximately 1.61 TB free
- Management IPv4: `192.168.1.40`
- Default gateway: `192.168.1.1`
- At least one VM appears to be registered

**Do not reinstall this host yet.** M1 requires identifying and backing up every existing VM and validating storage/RAID health before ESXi is removed.

## System-of-record decisions already established

| Capability | Current/target authority |
|---|---|
| Public web apps | Vercel / Cloudflare |
| CRM | Twenty preferred self-hosted option; HubSpot Free retained SaaS alternative |
| Workflow orchestration | production n8n on VPS; staging on Proxmox |
| Model routing | production LiteLLM on VPS currently; Citadel LiteLLM requires role/dependency decision |
| AI compute | Citadel |
| Primary Zentari agent | Hermes on Citadel |
| Secondary/offsite agent | Hermes on Oracle |
| Production metrics today | Prometheus/Grafana on VPS |
| Offsite backup | Backblaze B2 via restic |
| Source code and infrastructure definitions | GitHub |

## Architecture boundary

> **Citadel is Zentari-only AI infrastructure. Customer systems of record and customer production applications belong on the production VPS, managed cloud services, or customer-owned infrastructure.**

Customer data must not be moved into Citadel simply because local AI compute is available.

## M0 unknowns still blocking consolidation

- Live production VPS inventory to verify repository state matches deployed state.
- Live Citadel inventory newer than the 2026-07-03 snapshot.
- Exact dependencies on Citadel n8n, LiteLLM, PostgreSQL, Valkey, MinIO, Uptime Kuma and Traefik before retirement decisions.
- Existing services inside Proxmox VM 105.
- Existing VMware guest inventory before R410 conversion.
- Oracle network/public exposure and current service list.
- Current backup job success and first documented restore test.
- Exact DNS/subdomain inventory outside those represented in `zentari-ops`.
- Production VPS capacity headroom before adding Twenty/AppFlowy/Mautic.

## M0 exit criteria

M0 is complete only when:

- Every host has a verified live inventory snapshot.
- Every running service has an owner and purpose.
- Every duplicate is classified `KEEP`, `MIGRATE`, `RETIRE`, or `UNKNOWN`.
- Every database maps to at least one consuming application and an authoritative backup.
- Every public port is intentional.
- Every production service has a defined target host.
- Existing VMware workloads are understood before reinstallation.
- Existing production backups have been restored successfully in an isolated test environment.

The repository contains `scripts/collect-host-inventory.sh` to make the remaining live inventory repeatable and consistent.
