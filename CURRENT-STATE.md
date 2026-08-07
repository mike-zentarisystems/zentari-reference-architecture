# Zentari Current State

**As of:** 2026-08-07  
**Milestone:** M0 Inventory  
**Status:** In progress

This document records what is known to exist today. It is intentionally separate from the target architecture. Anything not verified directly from a host is marked as partial or unverified rather than inferred.

## Executive summary

Zentari currently spans five infrastructure locations plus managed SaaS services:

1. **Production VPS** for business/customer production services.
2. **Citadel** for Zentari-only AI compute and the primary Hermes agent.
3. **Primary Proxmox host** for staging, development and current lab VMs.
4. **Dell R410 running ESXi 6.7** targeted for conversion to a second Proxmox infrastructure/backup host.
5. **Oracle OCI Ampere** with 4 OCPU, 24 GB RAM and 200 GB disk, currently hosting the secondary Hermes agent and targeted as the offsite Watchtower/DR node.
6. **Vercel/Cloudflare** for public-facing web applications.
7. **Backblaze B2** for offsite backup.

The immediate M0 concern is duplicate and partially documented infrastructure. Multiple n8n, LiteLLM and PostgreSQL deployments are known to exist, but their exact host placement, data authority and dependencies have not yet been verified against the live systems.

## Current host baseline

| Host | Current platform | Observed resources | Current role | M0 state |
|---|---|---|---|---|
| Production VPS (`atlas` target name) | AlmaLinux 10.x VPS | ~2 vCPU, ~7.7 GB RAM, 4 GB swap | Production business/customer backend | Partial inventory |
| Citadel | Bare metal | i7-6700, 16 GB RAM, RTX 3060 12 GB | Zentari AI compute, Hermes primary | Partial inventory |
| Primary Proxmox (`forge`) | Proxmox VE 9.1.1 | 32 logical CPU, 125.85 GB RAM | Staging/development/lab | Host observed, guests incomplete |
| Dell R410 (`vault` target name) | ESXi 6.7 U2 | 12 logical CPU, 55.99 GB RAM, 1.81 TB datastore | Legacy virtualization, target backup/infrastructure Proxmox | Hardware observed, VM inventory required |
| Oracle (`watchtower`) | OCI Ampere ARM64 | 4 OCPU, 24 GB RAM, 200 GB disk | Hermes secondary, target external operations/DR | Partial inventory |

## Primary Proxmox observed guests

The 2026-08-07 Proxmox screenshots confirm these guests exist:

| VMID | Name | Known resources/state |
|---:|---|---|
| 101 | `PNET4.2.4` | Resources not yet captured |
| 103 | `zentari-openmanus` | Resources not yet captured |
| 104 | `zentari-buzz` | Resources not yet captured |
| 105 | `zentari-observability` | Running, 4 vCPU, 8 GB RAM, 200 GB boot disk |

VM 105 is important. Observability services must be inventoried before a new Grafana/Prometheus/Loki stack is deployed elsewhere, otherwise the cleanup effort could create another duplicate platform.

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

## Known service state

### Confirmed or strongly established

- HubSpot Free remains active as a supported zero-infrastructure CRM test/reference platform.
- Hermes primary runs on Citadel.
- Hermes secondary runs on Oracle OCI.
- Public web applications use Vercel and/or Cloudflare.
- Backblaze B2 is available for offsite backup.
- Multiple n8n instances exist.
- Multiple LiteLLM instances exist.
- Multiple PostgreSQL databases/instances exist.
- A `zentari-observability` VM already exists on Proxmox.

### Target but not yet promoted to production

- Twenty CRM
- AppFlowy
- Mautic, evaluation only initially
- Baserow, only if a concrete operational-data use case warrants it
- Supabase Pro, per custom application when Auth/RLS/Storage/Realtime justify it
- Standardized Tailscale private management plane
- Canonical observability/Watchtower design

## System-of-record decisions already established

| Capability | Current/target authority |
|---|---|
| Public web apps | Vercel / Cloudflare |
| CRM | Twenty preferred self-hosted option; HubSpot Free retained SaaS alternative |
| Workflow orchestration | n8n |
| Model routing | LiteLLM canonical gateway, exact current instances pending inventory |
| AI compute | Citadel |
| Primary Zentari agent | Hermes on Citadel |
| Secondary/offsite agent | Hermes on Oracle |
| Offsite backup | Backblaze B2 |
| Source code and infrastructure definitions | GitHub |

## Architecture boundary

A key policy decision is already final enough to enforce during M0:

> **Citadel is Zentari-only AI infrastructure. Customer systems of record and customer production applications belong on the production VPS, managed cloud services, or customer-owned infrastructure.**

Customer data must not be moved into Citadel simply because local AI compute is available.

## M0 unknowns blocking consolidation

The following must be collected live before M0 can close:

- Exact Docker containers on every Linux host.
- Exact n8n instance locations, versions, databases, volumes, credentials source and active workflows.
- Exact LiteLLM instance locations, versions, config paths, model providers and consumers.
- All PostgreSQL and MariaDB/MySQL instances, databases, owners, consumers, volume paths and backup status.
- Redis instances and consumers.
- Docker volumes and bind mounts.
- Publicly exposed ports and reverse-proxy routes.
- DNS/subdomain inventory.
- Current backup jobs and last successful restore test.
- Existing services inside Proxmox VM 105.
- Existing VMware guest inventory before R410 conversion.
- Oracle network/public exposure and current service list.
- Citadel storage, container and Qdrant/inference inventory.
- VPS free disk, resource utilization and production capacity headroom.

## M0 exit criteria

M0 is complete only when:

- Every host has a verified inventory snapshot.
- Every running service has an owner and purpose.
- Every duplicate is classified `KEEP`, `MIGRATE`, `RETIRE`, or `UNKNOWN`.
- Every database maps to at least one consuming application and an authoritative backup.
- Every public port is intentional.
- Every production service has a defined target host.
- Existing VMware workloads are understood before reinstallation.
- The inventory has been reviewed against the live machines, not only conversation history.

The repository contains a host collection script under `scripts/collect-host-inventory.sh` to make the remaining live inventory repeatable and consistent.
