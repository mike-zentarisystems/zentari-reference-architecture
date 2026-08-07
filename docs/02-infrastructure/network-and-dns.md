# Network and DNS

## Trust zones

| Zone | Examples | Exposure |
|---|---|---|
| Public edge | Cloudflare, Vercel apps | HTTPS only |
| Production application | VPS APIs and webhooks | Explicit edge/integration routes only |
| Management | SSH, Proxmox, Grafana admin, database admin | Tailscale/private only |
| AI | Citadel APIs and model endpoints | Private; allowlisted service identities |
| Staging | Forge test services | Private; no production credentials |
| Infrastructure | Vault backups and restore tests | Private; restricted service identities |
| Offsite operations | Watchtower | Private management plus outbound checks |

Public DNS names describe stable services, not machines. Internal machine names (`atlas`, `citadel`, `forge`, `vault`, `watchtower`) resolve through the private network. DNS changes require owner, purpose, proxy mode, target, TLS source, validation, and rollback entries in the change record.

No database, Proxmox UI, Docker API, model endpoint, or backup repository is intentionally exposed to the public internet.
