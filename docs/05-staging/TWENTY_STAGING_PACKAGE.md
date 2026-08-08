# Twenty Staging Package

## Goal

Validate Twenty as Zentari's internal CRM before production deployment.

## Rules

- Staging first.
- Pin the image version.
- Back up PostgreSQL before every upgrade or migration.
- Never test irreversible schema changes first on Atlas.
- Treat HubSpot as a customer integration target, not a parallel internal source of truth.

## Initial CRM model

### Company

- Name
- Industry
- Company size
- Lead source
- Lifecycle stage
- Account owner
- AI/automation readiness
- Notes

### Person

- Name
- Company
- Role
- Email
- Phone
- Decision maker
- Lead source
- Consent status

### Opportunity

- Company
- Primary contact
- Service / solution
- Stage
- Estimated value
- Probability
- Source
- Pain point
- Next action
- Close date

## Initial pipeline

1. New lead
2. Qualified
3. Discovery scheduled
4. Discovery complete
5. Solution / proposal
6. Decision
7. Won
8. Lost

Keep it simple until real sales behavior proves the need for more stages.

## Acceptance tests

- Create company.
- Create person linked to company.
- Create opportunity linked to company/person.
- Move opportunity through pipeline.
- Search/update records through API or supported automation path.
- n8n can upsert a lead without duplicates.
- Export/backup succeeds.
- Restore into isolated staging succeeds.
- Upgrade test is performed only after backup.

## Promotion to Atlas

Promote only after the CRM has been used for a realistic test workflow and the backup/restore path is proven.
