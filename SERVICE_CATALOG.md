# Zentari Service Catalog

| Service | Role | Host/Platform | Criticality | Data authority | Backup | Monitoring | Status |
|---|---|---|---|---|---|---|---|
| Caddy | ingress | Atlas | High | No | Git config | availability | TARGET |
| PostgreSQL | production data | Atlas | Critical | Yes | logical backup + Restic/B2 | DB health | KEEP |
| n8n | Zentari automation | Atlas | High | Workflow execution state | DB/config backup | workflow health | KEEP/REBUILD |
| LiteLLM | model gateway | Atlas | Medium | No | Git/config | request health | KEEP IF NEEDED |
| Twenty | internal CRM | Atlas | High | CRM source of truth | PostgreSQL | availability + DB | STAGING FIRST |
| AppFlowy | company knowledge | Atlas or SaaS decision | Medium | Company knowledge if adopted | app/data backup | availability | OPTIONAL |
| Hermes primary | AI agent | Citadel | Medium | No | Git/config | agent/model health | KEEP |
| Ollama/llama.cpp | local inference | Citadel | Medium | No | Config only; models reproducible | model health | KEEP |
| Qdrant | vector index | Citadel | Medium | No, rebuildable index | optional snapshots + rebuild | index health | KEEP |
| Forge staging | test environment | Forge | Medium | No | PBS | VM health | BUILD |
| Coolify | deployment convenience | Forge | Low/Medium | No | config/state backup | availability | OPTIONAL |
| PBS | VM backup | Vault | High | Backup copy | offsite strategy | backup job health | BUILD |
| Restic repository | data backup | Vault/B2 | Critical | Backup copy | replicated/offsite | repository checks | KEEP |
| Uptime Kuma | external checks | Oracle | Medium | No | config export | self/external checks | BUILD |
| Hermes secondary | degraded AI | Oracle | Low/Medium | No | Git/config | heartbeat | OPTIONAL |
| Backblaze B2 | offsite recovery | SaaS | Critical | Offsite backup authority | provider durability + policies | backup verification | KEEP |
| Tailscale | private network | All managed hosts | High | No | recovery credentials escrow | peer reachability | STANDARD |
| Vercel | public web | SaaS | High | source-controlled apps | Git/provider | provider/endpoint | KEEP |
| Cloudflare | DNS/edge | SaaS | High | DNS/edge config | account/export docs | external checks | KEEP |

## Service admission rule

A new service must have a purpose, owner, data classification, backup/restore method, monitoring plan, dependencies and retirement condition before becoming production.