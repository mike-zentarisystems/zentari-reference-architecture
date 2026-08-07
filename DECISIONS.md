# Decision index

ADRs are append-only records. If a decision changes, add a superseding ADR and update this index.

| ADR | Decision | Status | Review trigger |
|---|---|---|---|
| [0001](docs/adr/0001-platform-boundaries.md) | Separate platform planes; Citadel remains Zentari-only | Accepted | New customer hosting model |
| [0002](docs/adr/0002-crm-strategy.md) | Pilot Twenty; retain HubSpot Free as supported SaaS alternative | Accepted | Pilot exit or CRM pricing/capability change |
| [0003](docs/adr/0003-proxmox-standardization.md) | Convert legacy VMware host to infrastructure Proxmox | Proposed | Hardware validation and migration approval |
| [0004](docs/adr/0004-backup-standard.md) | Encrypted local plus Backblaze B2 offsite backups | Proposed | Business approval and first restore evidence |
| [0005](docs/adr/0005-private-management.md) | Private administration over Tailscale | Accepted | IAM/network redesign |

Each ADR records context, decision, consequences, alternatives, reversibility, migration path, and review triggers.
