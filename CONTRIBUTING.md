# Contributing

## Change workflow

1. Update inventory from evidence before changing the target architecture.
2. Add or supersede an ADR for changes to ownership, trust, data authority, recurring cost, or recovery objectives.
3. Keep observed facts separate from target and optional components.
4. Include rollback and validation steps with operational changes.
5. Run `powershell -File scripts/validate-docs.ps1` before review.

## Pull request requirements

- State which plane and services change.
- Identify affected data, credentials, ports, DNS, backups, monitoring, and customer boundaries.
- Link the ADR and runbook.
- Provide validation evidence and a rollback trigger.
- Never commit credentials, private keys, raw `.env` files, tokens, backup passwords, or customer data.

Use conventional commit subjects such as `docs: define watchtower role` or `feat: add restic backup automation`.
