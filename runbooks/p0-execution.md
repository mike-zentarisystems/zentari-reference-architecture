# P0 Execution Runbook

This runbook executes ZP-002 through ZP-006 without modifying production state.

## ZP-002 — Escrow recovery secrets

Before wiping or rebuilding anything, verify recovery material exists somewhere independent of Atlas, Citadel, Forge, Vault and Oracle.

Minimum material:

- Restic repository location and password
- Backblaze application key/credentials
- Tailscale account/recovery access
- Cloudflare account recovery/MFA recovery
- VPS provider account recovery
- GitHub account recovery
- database backup encryption/password information
- n8n encryption key
- LiteLLM/provider keys needed for recovery
- SSH break-glass keys

Do not commit these secrets to this repository. Record only that escrow has been tested and where the escrow process is documented.

Validation: from a device that does not depend on the server being protected, verify the recovery vault can be opened and the required entries are present.

## ZP-003 — Verify Restic / Backblaze

On Atlas, load the same environment variables the existing backup job uses, then run:

```bash
chmod +x scripts/validate-restic-b2.sh
./scripts/validate-restic-b2.sh
```

Expected result:

- snapshots are listed
- repository statistics return successfully
- `restic check` completes without errors

Save sanitized output under `evidence/backups/restic-check/`.

## ZP-004 — Restore sample files

On a host with enough temporary disk space and Restic credentials:

```bash
chmod +x scripts/test-restic-file-restore.sh
./scripts/test-restic-file-restore.sh
```

The script restores `latest` into `/tmp/zentari-restic-restore-*` and never overwrites production paths.

Inspect several representative files. Where an original copy still exists, compare checksums:

```bash
sha256sum /original/path/file /tmp/zentari-restic-restore-*/.../file
```

Save sanitized output under `evidence/backups/file-restore/`.

## ZP-005 — Restore PostgreSQL in isolation

First locate a PostgreSQL logical dump from the restored backup. Copy it to a Docker-capable test host, preferably Forge/staging.

Then run:

```bash
chmod +x scripts/test-postgres-restore.sh
PG_MAJOR=15 ./scripts/test-postgres-restore.sh /path/to/database.sql
```

For custom-format dumps, pass the dump file instead of `.sql`.

The harness creates a temporary PostgreSQL container, restores the dump, lists tables and basic row statistics, then destroys the temporary database container.

Do not point production applications at the temporary database.

Save sanitized output under `evidence/backups/postgres-restore/`.

## ZP-006 — Audit the R410 before wiping ESXi

If ESXi SSH is enabled, copy `scripts/audit-r410-esxi.sh` to the R410 and run:

```sh
chmod +x audit-r410-esxi.sh
./audit-r410-esxi.sh
```

Also capture iDRAC/PERC screenshots or CLI output showing:

- RAID/PERC controller model
- virtual disk count and sizes
- RAID level
- physical disk count, model, size and state
- predictive failure status
- cache/battery status
- current registered VMs
- current datastore use

Do not wipe ESXi until this information has been reviewed and any needed VMs/data have been preserved.

Store sanitized evidence under `evidence/inventory/vault-r410/`.

## Host inventory

For Atlas, Citadel, Forge and Oracle, run the existing collector:

```bash
chmod +x scripts/collect-host-inventory.sh
sudo ./scripts/collect-host-inventory.sh
```

Review outputs for sensitive values before committing or uploading them.

## Completion rule

ZP-002 through ZP-006 move to `DONE` only after the resulting evidence has been reviewed, not merely because the script ran.
