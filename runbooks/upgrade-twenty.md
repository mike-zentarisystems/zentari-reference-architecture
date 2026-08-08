# Runbook: Upgrade Twenty Safely

## Rule

Never perform a stateful Twenty upgrade without a current database backup and a staging validation first.

## Procedure

1. Record current Twenty image/version and PostgreSQL version.
2. Confirm recent database backup exists.
3. Restore/refresh a staging copy if needed.
4. Pin the intended new Twenty version in staging.
5. Start the upgrade and capture migration/application logs.
6. Validate:
   - login/authentication
   - companies/contacts/opportunities
   - custom fields/objects
   - integrations/webhooks
   - n8n workflows that depend on Twenty
   - representative API operations
7. Document migration behavior and recovery path.
8. Take a fresh production backup immediately before production promotion.
9. Promote the exact tested version/configuration.
10. Run smoke/acceptance tests and monitor errors.

## Failure handling

Do not assume schema migrations are reversible. Recovery may require restoring the pre-upgrade database and prior application version rather than simply downgrading the container.

## Success criteria

- Staging passes before production.
- Pre-production backup is verified.
- Exact version is pinned.
- Critical CRM data and integrations pass post-upgrade checks.