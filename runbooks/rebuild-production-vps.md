# Rebuild production VPS

1. Declare the recovery point and provision a supported replacement in the same approved region/network class.
2. Apply baseline IAM, patching, firewall, Tailscale, time sync, logging, storage, and monitoring before application data.
3. Restore secrets through controlled recovery, then databases, file/object dependencies, and pinned application definitions in recovery order.
4. Keep public ingress disabled while running database, authentication, webhook, CRM, n8n, and backup smoke tests.
5. Lower DNS TTL only through the approved edge change, direct a controlled test hostname first, then cut over production.
6. Monitor errors and business transactions through the rollback window; preserve the failed host isolated for investigation.

M0 must add provider image, size, volume, firewall, DNS, secrets, artifact, expected-output, timeout, and abort details before execution.
