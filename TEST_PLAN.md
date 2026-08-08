# Zentari Platform Test Plan

## Purpose

Prove the platform can be changed, restored and degraded safely before customer dependence grows.

## Test classes

### Backup integrity

- Run repository integrity check.
- Confirm latest expected backup exists.
- Verify backup size/change is plausible.
- Confirm alerting catches a failed backup job.

### File restore

1. Restore selected files to an isolated path.
2. Compare file count/checksums where practical.
3. Confirm production files were not overwritten.
4. Record restore duration.

### PostgreSQL restore

1. Start isolated PostgreSQL of compatible version.
2. Restore roles/schema/database as appropriate.
3. Confirm expected databases and tables.
4. Query representative records.
5. Start a dependent staging application if safe.
6. Record restore duration and gaps.

### VM restore

1. Back up a non-critical Forge VM to PBS/Vault.
2. Restore under a new VMID/name.
3. Boot it on an isolated network.
4. Verify OS/application state.
5. Delete test VM after evidence is recorded.

### Atlas rebuild drill

1. Start a clean Atlas-like VM on Forge.
2. Join Tailscale.
3. Clone infrastructure/application Git configuration.
4. Deploy using Compose without requiring Coolify.
5. Restore database/persistent data.
6. Validate Caddy and application health.
7. Measure total recovery time.

### Caddy ingress

Test:
- HTTPS issuance/renewal path
- HTTP -> HTTPS redirect
- standard web application
- WebSocket application
- application restart/redeploy
- private-only administrative route where applicable

### Qdrant rebuild

1. Record/pin embedding model and chunking configuration.
2. Delete or use an empty test collection.
3. Re-index authoritative source documents.
4. Run a fixed retrieval question set.
5. Compare expected relevant sources/results.
6. Record rebuild duration.

### Citadel outage

1. Stop Citadel AI endpoint intentionally.
2. Confirm business/CRM systems remain available.
3. Test cloud/degraded AI behavior if configured.
4. Test Oracle-Hermes if retained.
5. Record AI-layer recovery/degraded-mode time.

### Oracle outage

Stop/disable Watchtower service and confirm Atlas/Citadel/Forge continue normally. Verify no production dependency exists.

### Twenty upgrade

1. Backup database first.
2. Reproduce upgrade in staging.
3. Validate CRM records, workflows and integrations.
4. Do not promote if rollback/recovery procedure is unclear.

### Customer handoff

For a sample customer-owned automation deployment:
- customer owns account/billing
- Zentari uses delegated access
- workflow export/source is available
- secrets remain customer-owned
- revoke Zentari access and confirm customer operation continues

## Evidence

Every test should record date, operator, environment, versions, result, elapsed time, defects/gaps and follow-up task IDs.