# Staging and promotion

Forge is the rehearsal environment for application upgrades, CRM pilots, migrations, infrastructure changes, and restore tests.

## Promotion gate

1. Use sanitized or synthetic data; never copy production secrets into staging.
2. Record the exact image or package versions and configuration diff.
3. Run application health, dependency, data migration, backup, and rollback tests.
4. Capture resource use and expected production headroom.
5. Take a fresh production backup and verify its readability.
6. Define go/no-go owner, maintenance window, validation checks, and rollback trigger.
7. Promote immutable versions; do not rebuild from floating tags.
8. Record post-change evidence.

Twenty must complete contact/company/opportunity import, export, n8n integration, permission, email/calendar (if enabled), backup, restore, and daily-use evaluation before CRM promotion.
