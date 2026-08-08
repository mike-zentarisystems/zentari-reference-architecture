# Zentari Platform Architecture — Current Pressure-Tested Plan

**Status:** Canonical current architecture  
**Date:** 2026-08-07  
**Principle:** Less lab, more factory.

## 1. Purpose

This document is the current, pressure-tested Zentari platform plan. It deliberately favors simple, recoverable, Git-defined systems over enterprise-style complexity.

The platform exists to help Zentari build and operate customer solutions. The platform itself is not the product.

## 2. Core rules

- Buy no new hardware until the existing estate is fully utilized.
- Customer production must never depend on the home lab.
- All Zentari-managed devices use Tailscale for private management and east-west communication.
- Git-tracked Docker Compose is the authoritative application deployment definition.
- Coolify may simplify deployment, but must not become required to reconstruct a service.
- Caddy is the standard ingress/reverse proxy unless a documented exception exists.
- Every important workload must have a tested restore path.
- Backups are not trusted until restored successfully.
- Do not deploy software because it might be useful. Deploy it to solve a current problem.
- Prefer customer-owned SaaS/cloud accounts with Zentari delegated access.

## 3. Platform map

```text
                     Internet
                        |
              Cloudflare / Vercel
                        |
                 ATLAS - VPS
              Business Production
                        |
                   Tailscale
       +----------------+----------------+
       |                |                |
    CITADEL           FORGE            VAULT
   AI Compute      Dev / Staging    Backup / Storage
       |                |                |
       +----------------+----------------+
                        |
                  ORACLE OCI
               External Watchtower

                    Backblaze B2
                  Offsite Recovery
```

## 4. Atlas — paid production VPS

**Role:** Production business/application host.

The current VPS may be wiped and rebuilt once recovery is proven. Existing configuration is not sacred.

### Target services

- Docker / Docker Compose
- Tailscale
- Caddy
- PostgreSQL
- n8n for **Zentari internal automation only**
- LiteLLM production gateway when needed
- Twenty CRM
- Production application services
- AppFlowy only if/when adopted for Zentari company knowledge

### Not part of the baseline

- Redis until n8n queue mode/workers actually require it
- Full observability stack
- Development workloads
- AI model storage
- Long-term backups
- Customer-owned n8n workloads

### Recovery model

Atlas is a single production node by design. It is not HA.

Failure recovery is:

1. Provision a fresh VPS.
2. Join Tailscale.
3. Deploy the Git-tracked Compose stack.
4. Restore databases and persistent data from Backblaze.
5. Validate services.
6. Cut DNS/Cloudflare traffic.

Define and measure an honest RTO from this process.

## 5. Citadel — AI appliance

**Role:** Stable Zentari AI compute.

### Hardware

- Intel i7-6700
- 16 GB RAM
- NVIDIA RTX 3060 12 GB

### Baseline services

- Hermes primary
- Ollama and/or llama.cpp
- Qdrant
- Embeddings
- Reranking when required
- AI-specific tools required by agents

Citadel does **not** own CRM, customer production databases, company documents, or irreplaceable knowledge.

Qdrant is a disposable/rebuildable index. The rebuild process must be tested and the embedding model/version pinned.

## 6. Second brain / knowledge architecture

Authoritative knowledge remains outside the AI index:

- Obsidian: personal knowledge and working notes
- AppFlowy: company/team knowledge if adopted
- GitHub: code, architecture, runbooks and version-controlled documentation
- Twenty: Zentari CRM/customer business records

The flow is:

```text
Obsidian / AppFlowy / GitHub / CRM
                 |
                n8n
                 |
        normalize / chunk
                 |
             embeddings
                 |
              Qdrant
                 |
              Hermes
```

**Rule:** The documents are the second brain. Qdrant is only an index and must be rebuildable.

## 7. Forge — primary Proxmox compute

**Role:** Development, staging, testing and internal compute.

Known capacity is approximately 126 GB RAM and dual Xeon E5-2665 CPUs. Local storage is currently the constraint.

### VM plan

- VM 103: OpenManus/legacy AI development, retain only while useful
- VM 104: Buzz/AI development; OS installed, application stack not yet deployed
- VM 105: Observability; OS installed, full GitHub observability stack not yet deployed
- VM 106: Coolify control plane, optional management convenience
- VM 107: production-like staging
- VM 108: disposable lab only if needed

Do not create VMs simply to fill this plan. A VM is created when there is a current workload for it.

### Coolify

Coolify may manage application deployments across Docker hosts, but Git-tracked Compose remains the recovery and portability standard.

Forge/Coolify must not become an unrecoverable dependency for Atlas production. Atlas services must remain startable without Coolify.

## 8. Observability — intentionally reduced

The earlier observability design was too large for the current stage.

### Current baseline

- Oracle Uptime Kuma for outside-in availability checks
- One useful metrics pane for infrastructure/application health
- Native application logs retained sufficiently for troubleshooting

### Backlog until justified

- Loki
- Alloy
- OpenTelemetry platform
- Langfuse
- PostHog
- elaborate alert routing

VM 105 remains reserved for observability growth, but does not need the entire historical `zentari-logging` design now.

## 9. Vault — R410 / second Proxmox server

**Role:** Storage, backup and recovery.

Known capacity is approximately 56 GB RAM and 1.81 TB datastore capacity. RAID controller, disk layout and disk health must be verified before repurposing.

### Baseline responsibilities

- Proxmox VE
- Proxmox Backup Server capability
- Local backup datastore
- Restore-test workspace/VM
- ISO and template storage
- Bulk/archive storage

### Storage rule

Forge keeps latency-sensitive running VM disks local. Vault supplies bulk storage and recovery capacity.

Do not make normal Forge VM operation dependent on the R410 over NFS/iSCSI.

## 10. Backup and disaster recovery

### VM layer

```text
Forge -> PBS/Vault -> Backblaze B2
```

Use native PBS offsite sync where appropriate and supported by the deployed PBS version.

### Application/data layer

```text
Atlas / critical data -> Restic -> Backblaze B2 immutable/locked recovery tier
```

### PBS/B2 safeguards

- Validate the exact PBS/B2 configuration before production use.
- Do not casually enable bucket features that conflict with PBS datastore semantics.
- Decide mirror-versus-archive deletion behavior explicitly.
- Keep Restic to a protected/immutable bucket as the independent recovery tier.

### Required tests

- Restic repository check
- File restore
- PostgreSQL restore into an isolated environment
- Atlas-like rebuild on Forge
- Periodic PBS VM restore
- Qdrant rebuild from authoritative sources

## 11. Oracle OCI — Watchtower

**Role:** External observer and degraded AI fallback.

Hardware:

- Ampere ARM64
- 4 OCPU
- 24 GB RAM
- 200 GB storage

Only workloads that can disappear without harming the business belong here.

### Baseline

- Tailscale
- Uptime Kuma / external availability monitoring
- DNS/SSL checks
- backup verification signals
- Hermes secondary if it remains useful

Oracle is **not** Atlas disaster recovery.

If Hermes secondary is retained, it should use an independent cloud-model path with tightly scoped credentials and hard spend controls. Without replicated knowledge, it is explicitly context-free/degraded during Citadel failure.

## 12. Windows workstation

**Role:** Interactive development and experimentation only.

- 64 GB RAM
- separate RTX 3060 12 GB

Use it to test candidate models or development ideas without destabilizing Citadel. Do not turn it into production infrastructure.

## 13. Public edge

### Cloudflare

- DNS
- edge security/WAF where used
- public routing
- CDN where useful

### Vercel

- public websites
- portals
- web applications suited to Vercel

Administrative interfaces stay private over Tailscale wherever practical.

## 14. CRM strategy

### Zentari internal CRM

Twenty is the intended internal source of truth after staging validation.

Hard rule: backup before upgrades, particularly where migrations are not safely reversible.

### HubSpot

HubSpot remains a customer integration/platform target and testing reference. Zentari does not build every internal workflow against both Twenty and HubSpot.

## 15. Customer automation and n8n boundary

Zentari's n8n instance is for Zentari internal workflows.

Customer automation defaults to:

1. customer-owned n8n Cloud, or
2. customer-owned/self-hosted n8n infrastructure where appropriate.

Zentari receives delegated administrative/developer access and can sell implementation, monitoring, maintenance and optimization as recurring services.

Do not place multiple customers' workflows and credentials onto a Zentari-owned n8n deployment unless licensing and service-provider responsibilities have been deliberately resolved.

## 16. Customer/Zentari responsibility demarcation

**Customer owns:**

- SaaS/cloud accounts
- subscriptions and billing
- domains
- authoritative business data
- master credentials
- business/compliance decisions

**Zentari owns or performs under contract:**

- architecture
- implementation
- integration logic
- workflow development
- configuration
- operational monitoring/support
- documented backup/restore procedures when in scope
- ongoing optimization

Preferred pattern:

```text
Customer-owned account
        |
Delegated Zentari access
        |
Zentari builds and operates
        |
Customer can revoke access and continue operating
```

The offboarding test is simple: if Zentari disappeared tomorrow, the customer must retain access to their accounts, data, domains, workflows and backups.

## 17. Recurring revenue model

Customer ownership does not eliminate recurring revenue. Zentari sells ongoing stewardship rather than lock-in:

- automation management
- CRM operations
- AI operations
- infrastructure management
- marketing automation management
- reporting and optimization
- support/SLA services

## 18. Intentional redundancy

| Capability | Primary | Secondary / other | Why |
|---|---|---|---|
| AI inference | Citadel RTX 3060 | Windows RTX 3060 / cloud fallback | stable vs experimental/fallback |
| Hermes | Citadel | Oracle optional | degraded availability |
| Backups | Vault/PBS | Backblaze B2 | local recovery + offsite disaster recovery |
| Data backup | Restic | PBS at VM layer | independent recovery methods |
| Monitoring | local/basic metrics | Oracle external checks | inside vs outside perspective |
| Environments | Atlas production | Forge staging | safe change validation |
| PostgreSQL | production / staging separated | infrastructure instances only when needed | failure-domain and environment isolation |

## 19. Redundancy to remove or avoid

- random n8n instances
- multiple production CRM backends
- random LiteLLM gateways
- unnecessary PostgreSQL instances
- multiple Uptime Kuma installations without distinct purposes
- multiple dashboards that answer the same question
- duplicated AI tools with no active use case
- unnecessary caches, registries, Git mirrors and CMDB products

## 20. Deferred technology backlog

These are not rejected. They are deferred until a demonstrated problem justifies them:

- full Grafana/Prometheus/Loki/Alloy/OTel stack
- Langfuse
- PostHog
- Gitea mirror
- NetBox
- Authentik
- Infisical platform deployment
- Mautic
- Baserow
- MinIO
- private container registry/cache
- HA database clusters
- Ceph
- Kubernetes
- Kafka

## 21. Immediate build order

Infrastructure and revenue work proceed in parallel. Revenue work is not gated behind completing the entire infrastructure roadmap.

### P0 — protect what exists

1. Inventory hardware and current services.
2. Escrow Restic recovery credentials, critical API/DB recovery secrets and Tailscale recovery information somewhere that survives loss of any single machine.
3. Verify Backblaze/Restic repository health.
4. Perform isolated file and PostgreSQL restore tests.
5. Audit R410 RAID/controller/disks before wiping ESXi.

### P1 — establish the boring platform

6. Convert the R410 to Vault once its data and hardware are verified.
7. Establish PBS/local VM backup and offsite strategy.
8. Build a production-like staging environment on Forge.
9. Standardize Caddy and Git-tracked Compose.
10. Rebuild Atlas only after the staging restore/redeploy procedure succeeds.

### P2 — start shipping

11. Deploy Twenty to staging and validate it.
12. Build one complete lead-to-customer workflow.
13. Use customer-owned n8n Cloud as the default customer automation pattern.
14. Begin delivering customer work while infrastructure hardening continues.

### P3 — prove resilience

15. Time an Atlas rebuild and record the real RTO.
16. Test Citadel failure and Oracle-Hermes degraded behavior if retained.
17. Rebuild Qdrant from authoritative documents.
18. Perform periodic VM and application restore drills.

## 22. Decision filter

Before adding a technology, answer:

- What current problem does it solve?
- Is that problem blocking revenue, delivery, security or recovery?
- Can an existing component solve it adequately?
- Who owns it?
- How is it backed up?
- How is it restored?
- How is it monitored?
- How is it removed?

If those answers are weak, the technology stays in the backlog.

## 23. Summary

The current architecture is intentionally small:

```text
Atlas       = production business applications
Citadel     = AI
Forge       = development, staging and compute
Vault       = storage, backup and recovery
Oracle      = outside watchtower / optional degraded AI
Cloudflare  = edge
Vercel      = public web apps
Backblaze   = offsite recovery
Tailscale   = private fabric
Git/Compose = rebuild authority
Caddy       = ingress standard
```

The goal is not to build a miniature enterprise datacenter. The goal is to create a dependable factory for shipping Zentari and customer solutions.