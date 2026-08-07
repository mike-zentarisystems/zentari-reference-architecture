# Recover Restic / Backblaze B2

1. Confirm incident scope and whether local credentials or repositories may be compromised.
2. Recover B2 application credentials and the Restic repository password through separate custody paths.
3. Use a clean isolated host, pinned Restic version, and read-only B2 credentials where possible.
4. Run repository integrity and snapshot listing checks; record repository, snapshot ID, timestamp, host, paths, and checksum result.
5. Restore to an empty isolated destination, not over the failed source.
6. Scan and validate restored files before application recovery.
7. If repository corruption or deletion is detected, preserve evidence, enable incident response, and use B2 version/object-lock recovery according to the approved bucket policy.

Environment-specific commands and bucket identifiers are added only after M4 inventory and must never expose secrets in logs.
