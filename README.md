# Zentari Reference Architecture

Canonical, rebuild-oriented documentation for Zentari's internal platform and reusable customer deployment patterns.

## Non-negotiable boundaries

- Customer workloads run on the production VPS or customer-controlled cloud infrastructure.
- Citadel is Zentari-only AI compute; it is never a customer production host.
- Public web applications run on Vercel and/or Cloudflare and reach stateful services through authenticated APIs.
- Administrative interfaces stay private through Tailscale or an equivalent approved private path.
- Backups are not accepted until a restore has been tested and recorded.

## Start here

1. Read [ARCHITECTURE.md](ARCHITECTURE.md) for current and target states.
2. Check [inventory/hosts.yml](inventory/hosts.yml) and [inventory/services.yml](inventory/services.yml) for what is observed, proposed, or optional.
3. Read [DECISIONS.md](DECISIONS.md) and the ADRs before changing platform ownership.
4. Use [ROADMAP.md](ROADMAP.md) for milestone gates.
5. Follow the runbooks for changes, recovery, and restores.

## Repository contract

This repository describes desired architecture and operational procedures. It does not imply that a component is deployed. Every asset uses one of these lifecycle labels:

| Label | Meaning |
|---|---|
| `observed` | Confirmed from the source conversation or current inventory evidence |
| `target` | Approved direction, not necessarily implemented |
| `optional` | Evaluation candidate with no deployment commitment |
| `retired` | Historical component that must not be restored as an active dependency |

Deployable automation belongs in `ansible/`, `terraform/`, `compose/`, `monitoring/`, and `backups/` only after secrets, rollback, and validation requirements are defined. Secrets never belong in Git.

## Repository map

- `docs/` — architecture by concern
- `docs/adr/` — immutable decision records; supersede rather than rewrite
- `diagrams/` — Mermaid source diagrams
- `inventory/` — machine and service source-of-truth records
- `runbooks/` — operator procedures
- `infrastructure/` — environment ownership and future deployable manifests
- `ansible/`, `terraform/`, `compose/` — future implementation surfaces

## Validation

Run `powershell -File scripts/validate-docs.ps1`. It checks required documents, local Markdown links, inventory status values, and common secret patterns.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Architecture changes require an ADR when they alter ownership, trust boundaries, data authority, recovery objectives, or recurring cost.

## License

Copyright Zentari Systems. See [LICENSE](LICENSE); this baseline is proprietary unless Zentari adopts a different license through a recorded decision.
