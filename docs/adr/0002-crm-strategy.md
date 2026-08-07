# ADR-0002: Pilot Twenty and support HubSpot Free

- Status: Accepted
- Date: 2026-08-07
- Owners: Business Systems and Operations
- Supersedes: None
- Review trigger: Twenty pilot exit, material pricing change, or missing required capability

## Context

Zentari needs an API-friendly CRM while preserving a low-operations SaaS option and an exit path. Documentation alone cannot establish which CRM is best in daily use.

## Decision

Twenty is the preferred self-hosted candidate and will be evaluated in Forge. HubSpot Free remains a fully supported SaaS alternative. n8n owns cross-system orchestration, not CRM record authority.

During the pilot, HubSpot remains authoritative. Twenty receives a one-way, time-bounded test import using non-production or approved copied records; dual write is prohibited. The pilot mapping covers contacts, companies, opportunities/deals, owners, stages, notes, activities, attachments, consent, and stable external IDs. Conflicts resolve in favor of HubSpot until cutover.

## Consequences

Zentari gains a programmable self-hosted path without prematurely abandoning SaaS. The pilot requires schema mapping, import/export, workflow, backup/restore, permission, and daily-use tests.

## Alternatives considered

Mandating Twenty immediately was rejected because the pilot is incomplete. Mandating HubSpot was rejected because it limits control and extensibility. Mautic is marketing automation, not the CRM authority.

## Reversibility and migration

Maintain canonical field mappings and tested exports. Promotion requires a change freeze, final export/import reconciliation, named cutover owner, acceptance checks, and a defined rollback window during which the HubSpot snapshot is retained read-only. Rejection deletes pilot copies under the retention policy. Promotion or rejection requires a superseding ADR identifying the selected authority and migration evidence.
