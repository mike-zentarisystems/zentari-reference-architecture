# Zentari Platform Milestones

## M0 — Inventory and recovery prerequisites

**Objective:** Know what exists and protect the ability to recover it.

**Exit criteria:**
- Current hardware/services inventory reviewed.
- R410 RAID/controller/disks verified.
- Restic and critical recovery secrets escrowed outside any single host.
- Backblaze repository passes integrity check.
- One file restore and one PostgreSQL restore succeed in isolation.

## M1 — Vault

**Objective:** Convert the R410 into the storage/recovery node.

**Exit criteria:**
- Existing ESXi data intentionally preserved or retired.
- Proxmox VE installed.
- Backup storage configured.
- PBS capability configured.
- Forge can complete and restore a test VM backup.

## M2 — Forge staging

**Objective:** Make Forge the safe proving ground.

**Exit criteria:**
- Production-like staging VM exists.
- Tailscale works.
- Caddy/Compose deployment pattern validated.
- Staging can consume restored production-like data safely.

## M3 — Atlas rebuild standard

**Objective:** Make Atlas reproducible rather than precious.

**Exit criteria:**
- Git-tracked Compose defines Atlas baseline.
- Clean Atlas-like environment proven on Forge.
- Backup/restore procedure documented.
- Actual or simulated rebuild timed and RTO recorded.

## M4 — Basic monitoring

**Objective:** Detect failures without building an SRE platform.

**Exit criteria:**
- Oracle performs outside-in checks.
- One metrics pane shows host/application health.
- Alert path tested.

## M5 — Citadel simplification

**Objective:** Make Citadel a stable AI appliance.

**Exit criteria:**
- Hermes primary stable.
- Local inference stable.
- Qdrant consumers documented.
- Qdrant rebuild tested.
- General-purpose duplicate services retired or explicitly justified.

## M6 — CRM pilot

**Objective:** Validate Twenty as Zentari's internal CRM.

**Exit criteria:**
- Twenty deployed to staging.
- Backup-before-upgrade process tested.
- Basic company/contact/opportunity model configured.
- HubSpot retained as customer integration/reference target.

## M7 — First complete business workflow

**Objective:** Prove the platform creates a business outcome.

**Example:** lead intake -> qualification -> CRM -> acknowledgement -> follow-up -> reporting.

**Exit criteria:**
- End-to-end workflow works.
- Failure/retry behavior understood.
- Human handoff exists.
- Workflow is documented and reusable.

## M8 — Customer delivery pattern

**Objective:** Package a safe repeatable customer model.

**Exit criteria:**
- Customer-owned n8n Cloud/self-hosted pattern documented.
- Delegated-access model documented.
- Offboarding test passes on a sample deployment.
- Recurring support/operations scope defined.

## Rule

Milestones do not gate all revenue work. Customer delivery proceeds in parallel after M0 recovery basics are trustworthy.