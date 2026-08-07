# Platform principles

1. Keep customer production off Citadel and residential infrastructure.
2. Put state close to the application that owns it.
3. Prefer private management paths and least privilege.
4. Treat Git plus encrypted backups as the rebuild kit, not Git alone.
5. Rehearse in staging, promote with evidence, and retain a rollback path.
6. Prefer recoverability and clear ownership over premature high availability.
7. Mark optional tools as optional until they pass a named use-case evaluation.
8. Monitor from outside the failure domain being monitored.
9. A backup is unproven until restored.
10. Record decisions so they can be reversed deliberately.
