# P0 Evidence Collection

Store sanitized outputs from live validation here. Do not commit passwords, API tokens, private keys, `.env` contents, database credentials, Restic passwords, Tailscale auth keys, or customer data.

Recommended layout:

```text
evidence/
├── inventory/
│   ├── atlas/
│   ├── citadel/
│   ├── forge/
│   ├── oracle/
│   └── vault-r410/
├── backups/
│   ├── restic-check/
│   ├── file-restore/
│   └── postgres-restore/
└── recovery/
    ├── qdrant/
    └── atlas/
```

## Naming convention

Use:

`YYYY-MM-DD_host_test-name.txt`

Example:

`2026-08-08_atlas_restic-check.txt`

## Evidence rule

A tracker item is only marked `DONE` when evidence proves the validation succeeded. Screenshots are acceptable for RAID/iDRAC hardware checks; text output is preferred for repeatability.
