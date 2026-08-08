# Zentari Platform — Expanded / Future Roadmap Reference

**Status:** NON-CANONICAL  
**Purpose:** Historical comparison, future roadmap and reminder not to overbuild  
**Current architecture:** `ZENTARI_PLATFORM_CURRENT.md`

> This document intentionally preserves the larger architecture we considered before pressure testing. It is not a deployment checklist. Do not implement items here simply because they appear in the diagram.

## Why keep this document?

The expanded design contained useful ideas, but too many of them were being treated as near-term requirements. Keeping it serves three purposes:

1. Preserve potentially useful future patterns.
2. Show how quickly a small platform can turn into a miniature enterprise environment.
3. Provide a roadmap when real scale, customers or operational pain justify additional components.

## Expanded architecture concept

```text
                         INTERNET
                            |
                   Cloudflare / Vercel
                            |
             +--------------+---------------+
             |                              |
             v                              v
       PUBLIC WEB APPS                PRODUCTION VPS
                                        ATLAS
                                           |
                             +-------------+-------------+
                             |             |             |
                           Twenty         n8n         AppFlowy
                             |             |             |
                             +------+------+------+------+
                                    |             |
                                PostgreSQL      Redis
                                    |
                              LiteLLM Gateway
                                    |
                                Tailscale
                                    |
                                    v
                              CITADEL - AI
                         Hermes / Models / Qdrant

             BASEMENT                          CLOUD
                |                                |
       +--------+---------+                ORACLE OCI
       |                  |                  Watchtower
       v                  v                     |
    FORGE               VAULT                   + Hermes #2
  Proxmox #1          Proxmox #2                + external checks
       |                  |                     + backup verification
       |                  |                     + emergency access
       + Buzz             + PBS
       + Observability    + Restic cache
       + Coolify          + restore VM
       + staging          + long logs
       + dev              + Git mirror
       + lab              + infra databases
                          + storage services

                         |
                         v
                    Backblaze B2
```

## Expanded service catalog considered

### Atlas

- Twenty
- n8n production + workers
- PostgreSQL
- Redis
- LiteLLM
- AppFlowy
- Mautic
- Baserow
- Vaultwarden
- Homepage
- Portainer
- reverse proxy

### Citadel

- Hermes
- Ollama
- llama.cpp
- Qdrant
- embeddings
- rerankers
- Browserless
- SearXNG
- MCP servers
- AI development tools

### Forge

- OpenManus VM
- Buzz VM
- Goose
- OpenCode
- OmniRoute
- Coolify control VM
- staging VM
- disposable lab VM
- dedicated observability VM

### Full observability concept

- Grafana
- Prometheus
- Loki
- Alloy
- Alertmanager
- Blackbox Exporter
- OpenTelemetry Collector
- Uptime Kuma
- Langfuse
- PostHog

### Vault

- Proxmox Backup Server
- Restic repository/cache
- restore-test VM
- ISO repository
- template repository
- Git mirror / Gitea
- container registry/cache
- long-term log storage
- infrastructure PostgreSQL
- NFS/SMB storage services
- MinIO
- utility VMs

### Security / identity ideas

- Infisical
- Vaultwarden
- Authentik
- centralized SSO

### Infrastructure inventory ideas

- NetBox
- Baserow
- infrastructure CMDB/reporting database

## Why this was too much for V1

Each component is defensible individually. Together they create a large maintenance surface before Zentari has a business requirement for it.

The hidden costs are:

- patching
- backups
- restore procedures
- credentials
- monitoring
- integration drift
- upgrades/migrations
- troubleshooting
- documentation
- dependency chains
- attention diverted from customer delivery

The architecture risk was not that these technologies were bad. The risk was deploying them before their problems existed.

## Ideas intentionally retained for future use

### Full observability

Promote VM 105 into the larger Grafana/Prometheus/Loki/Alloy/OTel design when basic monitoring no longer answers operational questions quickly enough.

### Langfuse

Add when AI tracing/evaluation becomes important to real production agents or customer SLAs.

### PostHog

Add when product analytics materially informs a real product or customer portal.

### Authentik / centralized identity

Add when the number of internal applications/users makes separate authentication materially painful or risky.

### Infisical

Add as a platform when secret distribution/rotation across environments becomes difficult to manage safely with the simpler approach.

### Gitea mirror

Add when GitHub availability/independence becomes a meaningful recovery requirement. Until then, GitHub plus local clones/backups is sufficient.

### NetBox

Add when infrastructure inventory becomes large enough that Git/YAML documentation is no longer sufficient.

### Private registry/cache

Add when repeated image pulls, bandwidth, supply-chain control or deployment speed create a measurable need.

### Mautic

Add only when Zentari needs self-hosted marketing automation that cannot be adequately served by the chosen SaaS/customer tools.

### Baserow

Add only when a real low-code operational database use case appears.

### MinIO

Add only when an S3-compatible local object-storage requirement exists.

### Advanced HA

Potential future patterns include redundant databases, additional production nodes and more sophisticated failover. These should be driven by measured RTO/RPO/customer SLA requirements, not by architectural aesthetics.

## Explicit anti-roadmap

Do not adopt these merely to make the architecture look mature:

- Kubernetes
- Ceph
- Kafka
- service mesh
- multi-region active-active
- database clustering without an SLA requiring it
- elaborate internal PKI without a concrete requirement
- duplicated gateways with no distinct failure-domain purpose

## Trigger-based roadmap

A future component graduates from this document to the current architecture only when at least one trigger exists:

- paying customer requirement
- contractual SLA
- demonstrated reliability problem
- demonstrated security/compliance requirement
- measured performance/capacity limit
- repeated operational toil
- material cost reduction
- clear revenue opportunity

The change should then be documented as an architecture decision rather than silently added.

## Reminder

The expanded design is a toolbox, not a todo list.

The pressure-tested platform deliberately chose:

```text
Git + Compose
Caddy
Atlas
Citadel
Forge
Vault
Oracle Watchtower
Backblaze
Tailscale
basic monitoring
customer-owned customer infrastructure
```

over building every possible platform capability upfront.

When the simple architecture hurts, come back here and select the smallest additional capability that removes that pain.