# Security and IAM

## Access model

- Human access uses individual identities, MFA, least privilege, and short-lived elevation where supported.
- Tailscale is the default private management fabric. ACLs group operators, servers, and service identities by role.
- Service-to-service access uses scoped identities and rotated secrets; shared administrator credentials are prohibited.
- Cloudflare/Vercel public applications expose only intentional HTTPS routes.
- Database, hypervisor, observability admin, backup, and AI management endpoints remain private.

## Secrets

Store only templates and secret names in Git. Production secret storage requires auditability, recovery, and documented ownership. Back up required encryption keys separately from the encrypted data they unlock, using at least two controlled recovery locations.

## Break glass

Maintain sealed recovery access for DNS, VPS provider, Oracle, Backblaze, GitHub, Cloudflare, Vercel, Tailscale, and the secrets manager. Test the procedure at least annually without disclosing credentials in test records.

## Baseline hardening

Patch supported operating systems; disable password SSH where feasible; restrict inbound traffic; scan public exposure; collect authentication events; set resource and spend limits; and remove dormant accounts. Exceptions require an owner, compensating control, and expiry date.
