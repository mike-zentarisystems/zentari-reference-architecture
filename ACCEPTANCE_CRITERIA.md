# Zentari Platform Acceptance Criteria

## Recovery

- A Restic file restore succeeds from Backblaze into an isolated path.
- A PostgreSQL backup restores into an isolated database and expected tables/data are readable.
- A Forge VM restores successfully from Vault/PBS.
- An Atlas-like host can be rebuilt from Git-tracked Compose plus backup data.
- Atlas recovery time is measured and recorded.

## Networking and ingress

- All managed hosts join Tailscale.
- Management services are reachable privately without public exposure unless explicitly required.
- Caddy terminates HTTPS and routes at least one HTTP app and one WebSocket-capable app successfully.

## Staging

- A production-like stack starts on Forge from Git.
- Upgrade testing occurs in staging before production for stateful applications.
- Staging can use sanitized or restored data without triggering real outbound customer actions.

## Citadel / AI

- Hermes can call the intended model path reliably.
- Citadel loss does not remove authoritative CRM/business documents.
- Qdrant can be deleted and rebuilt from authoritative sources.
- Embedding model/version used for rebuild is pinned and documented.

## Oracle / Watchtower

- Oracle detects a deliberate endpoint failure.
- Alert delivery is verified.
- Loss of Oracle does not interrupt Atlas production.

## Twenty

- Twenty runs in staging.
- Company/contact/opportunity workflow works.
- Database backup is taken before upgrade testing.
- Restore procedure is documented before production promotion.

## Customer automation

- Default customer design uses customer-owned n8n Cloud or customer-owned infrastructure.
- Zentari access is delegated and revocable.
- Customer can access accounts, workflows, data and backups without Zentari ownership credentials.
- A sample offboarding/handoff procedure succeeds.

## V1 complete

V1 is accepted only when the core recovery tests, staging path, Twenty pilot and one complete lead-to-customer workflow have all passed.