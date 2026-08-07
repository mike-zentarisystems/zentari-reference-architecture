# Recover CRM

## Determine authority

Read the current CRM ADR and change record. During the Twenty pilot, HubSpot is authoritative. After a future cutover, the superseding ADR must name the authority and rollback window.

## Twenty recovery

Restore the matching PostgreSQL database, application files/attachments, server and worker versions, and configuration in isolation. Validate users, permissions, companies, people, opportunities, stages, notes, activities, attachments, webhooks, and one n8n flow before ingress.

## HubSpot recovery

Use provider recovery/support and the latest approved export. Validate property definitions, owners, pipelines, contacts, companies, deals, associations, activities, consent, and attachments. Do not import over live records until deduplication and conflict rules are approved.

## Cutover controls

Freeze writes, export the authority, reconcile counts and stable IDs, validate integrations, then cut over. Prevent dual write. Preserve the prior authority read-only through the defined rollback window and quantify any activity/attachment gaps.
