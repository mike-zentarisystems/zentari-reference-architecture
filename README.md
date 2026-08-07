# Zentari Reference Architecture

Canonical, rebuild-oriented documentation for Zentari's internal platform and reusable customer deployment patterns.

## Non-negotiable boundaries

- Customer workloads run on the production VPS or customer-controlled cloud infrastructure.
- Citadel is Zentari-only AI compute; it is never a customer production host.
- Public web applications run on Vercel and/or Cloudflare and reach stateful services through authenticated APIs.
- Administrative interfaces stay private through Tailscale or an equivalent approved private path.
- Backups are not accepted until a restore has been tested and recorded.

## Start here

1. Read [CURRENT-STATE.md](CURRENT-STATE.md) for the M0 live-state baseline and unresolved inventory items.
2. Read [ARCHITECTURE.md](ARCHITECTURE.md) for current and target architecture.
3. Check [inventory/hosts.yml](inventory/hosts.yml) and [inventory/services.yml](inventory/services.yml) for what is observed, proposed, optional, duplicated, or pending validation.
4. Read [DECISIONS.md](DECISIONS.md) and the ADRs before changing platform ownership.
5. Use [ROADMAP.md](ROADMAP.md) for milestone gates.
6. Follow the runbooks for changes, recovery, and restores.

## M0 live inventory

Use `scripts/collect-host-inventory.sh` on Linux hosts to collect a read-only baseline of operating system, compute, storage, network listeners, Docker workloads, systemd services, database/application processes, scheduled jobs, backup tooling and Tailscale state. The collector intentionally excludes environment variable values and secret-file contents.

Track remaining M0 work in GitHub issue **#1: M0: Complete live infrastructure inventory**.

Review collector output before committing it. Do not commit passwords, tokens, private keys, `.env` contents or other secrets.

## Repository contract

This repository describes desired architecture and operational procedures. It does not imply that a component is deployed. Every asset uses lifecycle labels that clearly distinguish observed state, target state, optional components and retired components. Inventory records may add more specific transitional states such as `observed-partial`, `observed-duplicates` or `target-evaluation` when that precision avoids implying deployment.

| Core label | Meaning |
|---|---|
| `observed` | Confirmed from current evidence |
| `target` | Approved direction, not necessarily implemented |
| `optional` | Evaluation candidate with no deployment commitment |
| `retired` | Historical component that must not be restored as an active dependency |

Deployable automation belongs in `ansible/`, `terraform/`, `compose/`, `monitoring/`, and `backups/` only after secrets, rollback, and validation requirements are defined. Secrets never belong in Git.

## Repository map

- `CURRENT-STATE.md` — M0 evidence-backed current-state baseline
- `docs/` — architecture by concern
- `docs/adr/` — immutable decision records; supersede rather than rewrite
- `diagrams/` — Mermaid source diagrams
- `inventory/` — machine and service source-of-truth records
- `scripts/` — safe collection and validation helpers
- `runbooks/` — operator procedures
- `infrastructure/` — environment ownership and future deployable manifests
- `ansible/`, `terraform/`, `compose/` — future implementation surfaces

## Validation

Run `powershell -File scripts/validate-docs.ps1`. It checks required documents, local Markdown links, inventory status values, and common secret patterns.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Architecture changes require an ADR when they alter ownership, trust boundaries, data authority, recovery objectives, or recurring cost.

## License

Copyright Zentari Systems. See [LICENSE](LICENSE); this baseline is proprietary unless Zentari adopts a different license through a recorded decision.
