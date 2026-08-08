# Zentari Platform Risk Register

| ID | Risk | Impact | Likelihood | Priority | Mitigation | Status |
|---|---|---|---|---|---|---|
| R-001 | Atlas is a single production node | High | Medium | P0 | Rebuild-from-Git recovery, tested backups, measured RTO | OPEN |
| R-002 | Recovery secrets lost with a host | High | Medium | P0 | Escrow Restic/Tailscale/DB/API recovery material outside any single machine | OPEN |
| R-003 | Backups exist but restore is unproven | High | Medium | P0 | File, DB, VM and full-host restore drills | OPEN |
| R-004 | R410 disks/RAID are aging or unhealthy | High | Medium | P0 | Audit controller, RAID, SMART/physical disk state before reuse | OPEN |
| R-005 | Customer n8n hosted incorrectly by Zentari | High | Medium | P0 | Customer-owned n8n Cloud/self-hosted by default; review licensing before exceptions | MITIGATED-BY-DESIGN |
| R-006 | Customer production depends on basement | High | Low | P0 | Hard architecture rule forbidding basement dependency | MITIGATED-BY-DESIGN |
| R-007 | Oracle tenancy/resources disappear | Medium | Medium | P1 | Only disposable watchtower/degraded services on Oracle | MITIGATED-BY-DESIGN |
| R-008 | Citadel failure removes AI context | Medium | Medium | P1 | Authoritative docs outside Qdrant; test Qdrant rebuild; degraded Oracle mode documented | OPEN |
| R-009 | Too much infrastructure delays revenue | High | Medium | P1 | Interleave customer work after recovery basics; deferred-tech backlog | ACTIVE |
| R-010 | Coolify becomes production dependency | Medium | Medium | P1 | Git/Compose remains authoritative and independently runnable | MITIGATED-BY-DESIGN |
| R-011 | Twenty upgrade causes irreversible data migration issue | High | Medium | P1 | Backup-before-upgrade hard gate; staging first | OPEN |
| R-012 | Multiple CRM targets cause workflow branching | Medium | Medium | P1 | Twenty internal source of truth; HubSpot treated as customer integration target | MITIGATED-BY-DESIGN |
| R-013 | Ingress experimentation causes instability | Medium | Low | P1 | Standardize on Caddy; exceptions documented | MITIGATED-BY-DESIGN |
| R-014 | Hidden service/configuration drift | Medium | High | P1 | Current-state inventory, Git-defined target state, periodic reconciliation | OPEN |
| R-015 | Unattended AI fallback creates cloud spend | Medium | Low | P2 | Scoped keys, provider budgets/spend caps, aggressive timeouts | OPEN |

## Review cadence

Review this register at each milestone exit and whenever a production-impacting architecture decision changes.