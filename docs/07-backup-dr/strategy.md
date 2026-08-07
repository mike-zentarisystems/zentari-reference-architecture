# Backup and disaster recovery

## Architecture

Use a 3-2-1 pattern: live data, a local Vault recovery copy, and an encrypted Backblaze B2 copy. Production attachment/object buckets are separate from backup buckets.

## Backup classes

- PostgreSQL: roles plus application-level logical dumps; add physical/PITR backups only after requirements justify them.
- MariaDB: only for adopted services such as Mautic.
- Applications: compose/manifests, version pins, configuration, encrypted secrets export, and persistent files.
- n8n: database plus encryption key under independent secret recovery controls.
- Citadel: configuration, prompts, MCP definitions, LiteLLM policy, Qdrant snapshots, and customized artifacts.
- Platform: inventories, DNS exports, Cloudflare/Vercel configuration, IAM recovery procedures, and repository mirrors.

## Baseline objectives

| Tier | Example | Target RPO | Target RTO | Review status |
|---|---|---:|---:|---|
| 1 | CRM, n8n, production databases | 24 hours | 8 hours | Provisional until business approval |
| 2 | AppFlowy, internal services | 24 hours | 24 hours | Provisional |
| 3 | Rebuildable staging/cache/model files | Best effort | 72 hours | Provisional |

Retention target: 30 nightly, 8 weekly, 12 monthly, and 3 yearly recovery points, subject to cost, deletion-protection/object-lock, and legal review. Restic is the preferred initial encrypted backup tool; credentials and repository passwords live outside this repository. Business owners must approve maximum tolerable data loss and outage before these provisional objectives become operational.

Monthly restore tests rotate across a database, application, n8n workflow, file set, and full service. Results record backup ID, source, recovery point, chosen consistency method, manifest/checksum result, start/end time, actual RPO/RTO, application tests, exceptions, owner, reviewer, and next due date.
