# Roadmap

Milestones are gated outcomes, not dates or declarations of deployment.

| Milestone | Outcome | Exit evidence | Status |
|---|---|---|---|
| M0 Inventory | Authoritative host, service, DNS, data, and dependency inventory | Inventory reviewed against live systems | In progress |
| M1 VMware evacuation | ESXi workloads backed up, restored elsewhere, and dependency-free | Restore evidence and rollback window | Planned |
| M2 Vault Proxmox | Dell R410 validated and installed as infrastructure plane | Hardware tests, storage health, management access | Planned |
| M3 Private management | Administrative surfaces removed from public exposure | Tailscale ACL tests and external port scan | Planned |
| M4 Backup baseline | Encrypted local and B2 jobs with monitoring | Successful jobs plus documented restore | Planned |
| M5 Watchtower | Independent external health, DNS, TLS, and backup checks | Alert delivery and simulated failure tests | Planned |
| M6 Service consolidation | One authoritative n8n and LiteLLM per environment | Dependency map and decommission rollback | Planned |
| M7 Twenty staging | CRM schema and one end-to-end n8n workflow tested | Pilot checklist and import/export test | Planned |
| M8 CRM decision | Twenty promoted or HubSpot Free retained | ADR supersession with export/rollback proof | Planned |
| M9 Production hardening | IAM, patching, secrets, logging, and recovery controls meet baseline | Security and recovery review | Planned |
| M10 Customer patterns | Cloud-lite, hybrid, sovereign templates validated | Isolated reference deployment tests | Planned |

No milestone advances solely because documentation exists. Implementation evidence is linked from an operations log or change record when execution begins.
