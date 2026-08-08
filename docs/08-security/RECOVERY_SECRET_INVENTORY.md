# Recovery Secret Inventory

## Purpose

List the recovery material that must survive loss of any single server. Do not store actual secret values in this file.

## Required escrow items

- Restic repository password
- Backblaze B2 application key ID/key
- Tailscale recovery/admin access
- VPS provider account access
- Cloudflare account recovery access
- GitHub account recovery access
- Oracle OCI account recovery access
- Proxmox root/admin recovery credentials
- PostgreSQL administrative credentials
- n8n encryption key
- LiteLLM master/recovery credentials
- Twenty application secret and DB credentials once deployed
- DNS/domain registrar recovery access
- SSH break-glass key material
- MFA recovery codes for critical platforms

## Storage requirements

Recovery material must:

- survive loss of Atlas
- survive loss of Citadel
- survive loss of Forge/Vault
- survive loss of Oracle
- not depend on one password manager instance that itself requires the missing secret to recover
- be encrypted at rest
- have at least one tested break-glass access path

## Verification checklist

- [ ] Inventory complete
- [ ] Every item has an owner
- [ ] Every item has an escrow location
- [ ] Escrow location is independent of production hosts
- [ ] MFA recovery tested where practical
- [ ] Restic repository can be opened using escrowed credentials
- [ ] n8n encryption key is recoverable before any Atlas wipe
- [ ] Review date recorded

## Rule

Never commit secret values, recovery codes, private keys, passwords, API tokens, or `.env` files containing live credentials to this repository.
