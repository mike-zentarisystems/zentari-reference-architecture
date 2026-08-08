# Zentari Change Management

## Goal

Make changes safely without turning a small platform into bureaucracy.

## Change classes

### Standard
Low-risk, repeatable, documented changes such as approved configuration updates.

### Significant
Version upgrades, database migrations, ingress changes, security changes, backup changes, or anything that can affect production availability/data.

### Emergency
Change required to restore service or contain a security issue.

## Rules

- Stateful/significant changes are tested on Forge first when practical.
- Back up before database/schema migrations.
- Pin production versions; avoid uncontrolled `latest` upgrades.
- Change one major component at a time.
- Define validation before making the change.
- Define a rollback/recovery path before significant changes.
- Git-tracked configuration is updated with the production change.
- Secrets never enter Git.
- Coolify may execute deployment, but Compose/config in Git remains authoritative.

## Production change checklist

- [ ] Purpose documented
- [ ] Risk understood
- [ ] Dependencies identified
- [ ] Backup current and verified
- [ ] Staging test completed or reason documented
- [ ] Rollback/recovery path known
- [ ] Maintenance impact understood
- [ ] Change deployed
- [ ] Health/acceptance checks passed
- [ ] Documentation/version state updated

## Emergency changes

Restore service first when necessary. Document the change, reconcile Git, and create follow-up corrective work as soon as practical.

## Things that require extra caution

- Twenty/database upgrades
- PostgreSQL major upgrades
- backup retention/deletion changes
- Caddy/Cloudflare DNS/ingress changes
- Tailscale ACL/recovery changes
- secret rotation
- Qdrant embedding/chunking model changes
- anything that modifies customer-owned production systems