# Restore PostgreSQL

## Preconditions

Identify application, database version, recovery point, roles dump, application dump, file/object dependencies, encryption keys, and an isolated restore target. Preserve the failed system for forensics unless capacity or security requires isolation.

## Restore

1. Provision the same major PostgreSQL version on an isolated network.
2. Restore roles with privilege review; do not blindly re-enable obsolete superusers.
3. Create the target database and restore the application dump.
4. Restore matching application files/object references and configuration.
5. Run database integrity, schema/migration, row-count, application health, authentication, and critical workflow checks.
6. Record actual recovery point and elapsed recovery time.

## Promotion

Freeze writes, take a final backup of the failed environment, update the approved application connection secret, restart the application, run smoke tests, monitor errors, and retain the old environment until the rollback window closes.

Rollback by returning the connection secret/DNS to the preserved prior database if it remains internally consistent and the change has not introduced divergent writes. Otherwise reconcile under incident command before switching.
