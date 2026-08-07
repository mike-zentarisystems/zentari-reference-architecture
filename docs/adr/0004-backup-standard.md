# ADR-0004: Use encrypted local and Backblaze B2 backups

- Status: Proposed
- Date: 2026-08-07
- Owners: Operations
- Supersedes: None
- Review trigger: Compliance, cost, RPO, or RTO requirements change

## Context

Backblaze B2 is available as an offsite destination, and the future Vault host can provide fast local recovery. Backup success without restore evidence is insufficient.

## Decision

Use application-consistent backups, an encrypted local Vault repository, and encrypted B2 offsite copies. Restic is the preferred initial tool. Separate production object storage from backup storage and require rotating restore tests. Acceptance is gated on business-owner RPO/RTO approval, B2 deletion protection/object-lock design, key custody, and successful restore evidence.

## Consequences

This provides geographic separation and efficient recovery while adding key-management, monitoring, retention, and restore-test responsibilities.

## Alternatives considered

Cloud-only backups were rejected for slower routine restore and credential/provider concentration. Local-only backups were rejected for site risk. Raw volume copies alone were rejected because databases need application-consistent recovery.

## Reversibility and migration

Restic repositories can be restored and migrated to another destination. Keep documented export/restore commands, key custody, and a tested alternate storage path.
