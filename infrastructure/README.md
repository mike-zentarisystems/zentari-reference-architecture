# Infrastructure implementation

Environment directories define ownership boundaries for future automation:

- `production/` — Atlas and customer-cloud business services
- `citadel/` — Zentari-only AI plane
- `staging/` — Forge test and promotion environments
- `vault/` — local backup/infrastructure plane
- `watchtower/` — offsite observability and DR plane
- `observability/` — shared telemetry definitions

No deployable baseline is claimed yet. Add automation only with version pins, example configuration, secret references, health checks, backup hooks, monitoring, resource limits, validation, and rollback.
