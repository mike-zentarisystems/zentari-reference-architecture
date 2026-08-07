# Recover Cloudflare / Vercel edge configuration

1. Use provider break-glass access and verify the incident is configuration loss, account compromise, DNS failure, or deployment failure.
2. Compare live state with the last reviewed DNS, domain, environment, redirect, firewall, and deployment inventory export.
3. Restore the smallest affected scope. Do not bulk apply unreviewed historical state.
4. Validate DNS resolution, TLS chain/expiry, edge security controls, public routes, authenticated API flows, and rollback deployment.
5. Rotate affected tokens, review audit logs, and export the recovered configuration.

Provider project/account IDs and exact export/import commands are supplied by M0 and future Terraform import work.
