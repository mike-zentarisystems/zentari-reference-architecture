# Zentari Platform Project Tracker

Status values: `BACKLOG`, `READY`, `IN PROGRESS`, `BLOCKED`, `DONE`.

| ID | Priority | Work item | Status | Milestone | Validation |
|---|---|---|---|---|---|
| ZP-001 | P0 | Complete live host inventory | IN PROGRESS | M0 | Inventory reviewed and repo updated |
| ZP-002 | P0 | Escrow recovery secrets | READY | M0 | Recovery material accessible without any single host |
| ZP-003 | P0 | Verify Restic/Backblaze repository | READY | M0 | `restic check` succeeds |
| ZP-004 | P0 | Restore sample files | READY | M0 | Restored files match source/checksum |
| ZP-005 | P0 | Restore PostgreSQL in isolation | READY | M0 | DB starts and expected tables/data exist |
| ZP-006 | P0 | Audit R410 RAID/disks | READY | M0 | Controller, RAID level and disk health recorded |
| ZP-010 | P1 | Convert R410 to Proxmox | BLOCKED | M1 | Blocked by ZP-006 and preservation review |
| ZP-011 | P1 | Configure Vault backup storage/PBS | BACKLOG | M1 | Forge VM backup and restore succeed |
| ZP-020 | P1 | Create Forge staging VM | BACKLOG | M2 | Production-like Compose deployment succeeds |
| ZP-021 | P1 | Validate Caddy ingress | BACKLOG | M2 | HTTP/HTTPS/WebSocket test passes |
| ZP-022 | P1 | Decide Coolify usage after Compose baseline | BACKLOG | M2 | Coolify optional; Compose remains sufficient alone |
| ZP-030 | P1 | Define clean Atlas Compose stack | BACKLOG | M3 | Stack starts from Git on clean host |
| ZP-031 | P1 | Rebuild Atlas-like environment on Forge | BACKLOG | M3 | Restore + validation completed |
| ZP-032 | P1 | Record Atlas recovery RTO | BACKLOG | M3 | Timed recovery documented |
| ZP-040 | P1 | Configure Oracle outside-in monitoring | BACKLOG | M4 | Failure alert tested |
| ZP-050 | P1 | Simplify Citadel services | BACKLOG | M5 | Only justified AI-local services remain |
| ZP-051 | P1 | Test Qdrant rebuild | BACKLOG | M5 | Index rebuilt from authoritative sources |
| ZP-060 | P1 | Deploy Twenty staging | BACKLOG | M6 | CRM accessible and backed up |
| ZP-061 | P1 | Configure Zentari CRM model | BACKLOG | M6 | Lead/company/opportunity workflow works |
| ZP-070 | P1 | Build lead-to-customer workflow | BACKLOG | M7 | End-to-end acceptance test passes |
| ZP-080 | P2 | Document customer n8n Cloud delivery pattern | BACKLOG | M8 | Sample customer handoff/offboarding succeeds |

## Working rule

Keep at most a few P0/P1 items in progress at once. New tooling does not become a task until it solves a documented problem.