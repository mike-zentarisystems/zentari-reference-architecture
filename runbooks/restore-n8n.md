# Restore n8n

n8n recovery requires both its database and the matching encryption key. Without the key, stored credentials are unusable.

1. Provision the pinned n8n version and matching database major version in isolation.
2. Restore PostgreSQL using [restore-postgres.md](restore-postgres.md).
3. Recover the n8n encryption key from controlled secret recovery storage.
4. Restore binary-data storage if the deployment does not use database mode.
5. Start without production webhook ingress and disable scheduled workflows initially.
6. Verify credentials decrypt, workflows load, executions are readable, and one synthetic workflow completes.
7. Re-enable schedules in controlled batches, then direct webhook traffic to the restored service.
8. Confirm idempotency before replaying failed events; never bulk replay without downstream impact review.

Record version, recovery point, workflows tested, credentials tested, execution gaps, replay decisions, and elapsed recovery time.
