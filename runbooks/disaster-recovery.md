# Disaster recovery

## Declare and contain

Name an incident commander, affected planes, customer impact, data risk, last known good time, and communication channel. Revoke compromised credentials and isolate affected systems without destroying evidence.

## Recovery order

1. Identity, secrets recovery, Tailscale, DNS, and provider access
2. Production network/ingress and database services
3. CRM and n8n business workflows
4. Public application connectivity
5. Citadel AI routes, only after core business paths work safely without them
6. AppFlowy and optional services
7. Staging, caches, build services, and long-term telemetry

## Source selection

Choose the newest verified recovery point before the incident. Prefer Vault for speed when site integrity is trusted; use B2 when the site or local repository is suspect. Validate manifests, checksums, repository integrity, and required decryption keys before rebuilding.

## Exit criteria

Critical workflows pass, monitoring observes the recovered system, data loss and recovery time are quantified, customer/security notifications are complete, backups resume to clean repositories, temporary access is revoked, and follow-up actions have owners and dates.
