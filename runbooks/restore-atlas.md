# Runbook: Rebuild / Restore Atlas

## Trigger

Use when Atlas is lost, intentionally rebuilt, or a clean recovery drill is being performed.

## Prerequisites

- Recovery credentials available outside Atlas.
- Git repositories accessible.
- Backblaze/Restic credentials available.
- DNS/Cloudflare access available.
- Compatible VPS/VM available.

## Procedure

1. Provision a clean supported Linux host.
2. Patch base OS and configure SSH.
3. Join Tailscale.
4. Install Docker/Compose using the documented baseline.
5. Clone authoritative infrastructure/application repos.
6. Restore required secrets from the recovery process. Do not commit them to Git.
7. Start infrastructure dependencies required by restore.
8. Restore PostgreSQL using `restore-postgres.md`.
9. Restore required persistent application data.
10. Deploy application Compose stack.
11. Start Caddy and verify internal routing first.
12. Validate Twenty, n8n and other critical applications.
13. Verify backups are configured on the rebuilt host.
14. Cut Cloudflare/DNS traffic only after validation.
15. Test external health checks.
16. Record total elapsed recovery time as measured RTO.

## Validation

- CRM records readable.
- n8n UI/workflows available.
- HTTPS routes function.
- No unexpected outbound automations fire during recovery testing.
- Backups resume successfully.

## Do not

- Overwrite the only known-good backup during a test.
- Cut production DNS before internal validation.
- Assume provider snapshots replace application/data backups.