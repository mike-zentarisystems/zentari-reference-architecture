# Zentari Initial RPO / RTO Targets

These are V1 engineering targets, not contractual SLAs. Replace them with measured values after recovery drills.

| System | RPO target | RTO target | Recovery approach |
|---|---:|---:|---|
| Atlas host | 4 hours for critical DB state | 4 hours | Fresh VPS + Git/Compose + restore + DNS cutover |
| Twenty CRM | 4 hours | 4 hours | PostgreSQL restore + application redeploy |
| Zentari n8n | 4 hours | 4 hours | PostgreSQL/config restore + Compose redeploy |
| LiteLLM/config | 24 hours | 2 hours | Git/config redeploy; provider state external |
| Citadel AI runtime | 24 hours | 8 hours | Rebuild runtime/config; cloud/degraded path where available |
| Qdrant index | 24 hours | 8 hours | Rebuild from authoritative documents using pinned embeddings |
| Forge staging | 24 hours | 24 hours | Restore VM or rebuild from Git |
| Vault/PBS | 24 hours | 24 hours | Rebuild backup node; offsite copies remain authoritative for disaster recovery |
| Oracle Watchtower | 24 hours | 48 hours | Recreate disposable monitoring node |
| Public Vercel/Cloudflare apps | source-controlled | 2 hours | Redeploy from Git/provider platform |

## Notes

- The Atlas RTO is deliberately honest: there is no HA failover node today.
- Critical PostgreSQL backup frequency must eventually match the chosen RPO.
- If measured restore time exceeds the target, improve the process before buying HA complexity.
- Customer-specific RPO/RTO values belong in customer contracts/design documents, not this internal baseline.