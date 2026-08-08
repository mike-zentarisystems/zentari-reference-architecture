# Runbook: Recovery Secrets Escrow

## Goal

Ensure recovery does not depend on credentials stored only on the failed machine.

## Recovery material to escrow

At minimum, maintain recoverable access to:

- Restic repository password/key material
- Backblaze B2 application key(s)
- Tailscale account/recovery administration
- Cloudflare/DNS account recovery
- VPS/provider recovery access
- Oracle account recovery access
- GitHub organization/repository recovery
- PostgreSQL application recovery credentials or procedure
- n8n encryption key for Zentari internal n8n
- critical AI/provider keys needed for degraded operation
- password/secrets-manager recovery material

## Rules

- Do not store raw recovery secrets in this Git repository.
- Keep the escrow outside the failure domain it protects.
- Protect escrow with strong encryption/MFA and a documented break-glass process.
- Prefer scoped application credentials over broad account-owner keys.
- Test access periodically without exposing secret values in logs or tickets.

## Test

At least quarterly, verify that an authorized operator can locate the escrow, unlock it, and identify the credentials required for an Atlas rebuild without relying on Atlas, Citadel, Forge, Vault or Oracle being available.

## Success criterion

Loss of any single Zentari machine does not make the remaining backups or cloud accounts inaccessible.