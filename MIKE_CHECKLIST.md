# Mike Checklist — Current Platform Build

This is the human execution order for the current phase. Work top to bottom. Do not skip destructive-change gates.

## Phase A — protect what exists

- [ ] Clone/update this repository locally.
- [ ] Read `docs/01-overview/ZENTARI_PLATFORM_CURRENT.md`.
- [ ] Review `docs/08-security/RECOVERY_SECRET_INVENTORY.md`.
- [ ] Escrow Restic password and Backblaze credentials outside any single server.
- [ ] Confirm n8n encryption key is recoverable.
- [ ] Confirm Cloudflare, GitHub, VPS provider, Oracle and Tailscale recovery access.
- [ ] Do **not** wipe Atlas or the R410 yet.

## Phase B — collect live inventory

Run the inventory collector on Atlas, Citadel, Forge and Oracle:

```bash
sudo bash scripts/collect-host-inventory.sh
```

- [ ] Atlas output captured.
- [ ] Citadel output captured.
- [ ] Forge output captured.
- [ ] Oracle output captured.
- [ ] Review each output for secrets before sharing/committing evidence.
- [ ] Return outputs to the architecture review so inventory can be reconciled.

## Phase C — prove Backblaze/Restic

On Atlas, with the repository credentials loaded into the shell:

```bash
bash scripts/validate-restic-b2.sh
```

- [ ] `restic snapshots` succeeds.
- [ ] `restic check` succeeds.
- [ ] Latest useful snapshot identified.

Then run the isolated file restore test:

```bash
bash scripts/test-restic-file-restore.sh
```

- [ ] Restore goes to a temporary directory only.
- [ ] At least one known file is present.
- [ ] File contents/checksum are reasonable.
- [ ] Record date and result under `evidence/`.

## Phase D — prove PostgreSQL recovery

Use a known-good PostgreSQL dump and the isolated test harness:

```bash
bash scripts/test-postgres-restore.sh /path/to/database.dump
```

- [ ] Temporary PostgreSQL container starts.
- [ ] Dump restores successfully.
- [ ] Expected schemas/tables exist.
- [ ] Critical application data can be queried.
- [ ] Temporary container is removed after testing.
- [ ] Record elapsed restore time.

**Gate:** Atlas cannot be rebuilt until file + database restore tests pass.

## Phase E — audit R410 before touching VMware

Run over ESXi SSH where supported:

```bash
bash scripts/audit-r410-esxi.sh
```

Also capture iDRAC/storage screenshots for:

- [ ] RAID controller model
- [ ] RAID virtual disks
- [ ] RAID level
- [ ] physical disk count
- [ ] disk models/capacities
- [ ] disk health
- [ ] predictive failures
- [ ] cache/battery health
- [ ] NIC inventory
- [ ] current VMware VM inventory

Review `docs/02-infrastructure/R410_VAULT_DECISION_SHEET.md`.

- [ ] Mark GO or HOLD.

**Gate:** Do not wipe ESXi until GO is documented.

## Phase F — build Vault

After GO:

- [ ] Preserve any VMware data/VMs that matter.
- [ ] Install Proxmox VE on the R410.
- [ ] Join Tailscale.
- [ ] Configure storage conservatively based on the verified RAID layout.
- [ ] Configure PBS/local VM backup capability.
- [ ] Add Forge as a backup source.
- [ ] Back up one noncritical Forge VM.
- [ ] Restore that VM successfully.
- [ ] Document actual restore time.
- [ ] Configure offsite PBS/B2 approach only after validating deletion/object-lock semantics.

## Phase G — build Forge staging

Read `docs/05-staging/FORGE_STAGING_SPEC.md`.

Create `zentari-staging`:

- [ ] 4 vCPU starting point
- [ ] 16 GB RAM starting point
- [ ] 100 GB local disk starting point
- [ ] Ubuntu 24.04 LTS
- [ ] Tailscale
- [ ] Docker / Compose
- [ ] Git
- [ ] Caddy

Deploy the Atlas baseline from `infrastructure/atlas/` with staging values.

- [ ] Compose validates.
- [ ] PostgreSQL is healthy.
- [ ] n8n starts.
- [ ] Caddy HTTPS test works where exposed.
- [ ] WebSocket test works.
- [ ] No customer messaging/integrations accidentally fire.

## Phase H — validate Twenty

Read `docs/05-staging/TWENTY_STAGING_PACKAGE.md`.

- [ ] Pin a tested Twenty version.
- [ ] Enable the `twenty` Compose profile in staging.
- [ ] Create sample company.
- [ ] Create sample person.
- [ ] Create sample opportunity.
- [ ] Move opportunity through pipeline.
- [ ] Test n8n upsert/deduplication.
- [ ] Back up Twenty/PostgreSQL.
- [ ] Restore into isolated staging.
- [ ] Test upgrade only after backup.

## Phase I — clean Atlas rebuild

Only after Forge proves the target stack:

- [ ] Export/preserve everything from current Atlas that is still needed.
- [ ] Confirm recovery-secret checklist again.
- [ ] Confirm Restic and PostgreSQL restore tests again.
- [ ] Confirm current Compose stack exists in Git.
- [ ] Schedule maintenance window.
- [ ] Rebuild Atlas cleanly.
- [ ] Install Tailscale, Docker and Compose.
- [ ] Deploy `infrastructure/atlas/`.
- [ ] Restore PostgreSQL/application state.
- [ ] Validate Caddy and service health.
- [ ] Validate DNS/Cloudflare.
- [ ] Record the actual rebuild RTO.

## Phase J — simplify Citadel

Target role: AI only.

- [ ] Keep Hermes primary.
- [ ] Keep current local inference runtime.
- [ ] Keep Qdrant.
- [ ] Keep embeddings/reranking required by real workflows.
- [ ] Identify duplicate n8n/Postgres/LiteLLM/monitoring/general tooling.
- [ ] Migrate or retire duplicates only after confirming no dependencies.
- [ ] Run Qdrant rebuild test from authoritative documents.
- [ ] Pin the embedding model/version used for rebuilds.

## Phase K — configure Oracle Watchtower

- [ ] Tailscale healthy.
- [ ] External Atlas check.
- [ ] External public-web check.
- [ ] DNS check.
- [ ] TLS/certificate check.
- [ ] Backup heartbeat/check.
- [ ] Alert path tested.
- [ ] If Hermes secondary remains, document degraded-mode limitations and cloud spend cap.

Keep Oracle disposable. Nothing critical should exist only there.

## Phase L — first working business workflow

Read `docs/01-overview/FIRST_REVENUE_WORKFLOW.md`.

Build:

```text
Lead intake
  -> validate/deduplicate
  -> CRM
  -> classify/enrich if useful
  -> opportunity/task
  -> acknowledgement
  -> notify owner
  -> next step / scheduling
```

- [ ] Happy path works.
- [ ] Duplicate path works.
- [ ] Bad-data path works.
- [ ] Retry does not duplicate side effects.
- [ ] Failure is visible.
- [ ] Workflow is documented/exportable.

## Phase M — customer delivery readiness

Read `docs/09-customer-patterns/CUSTOMER_DELIVERY_TEMPLATE.md`.

- [ ] Customer-owned n8n Cloud pattern documented.
- [ ] Customer-owned CRM pattern documented.
- [ ] Delegated-access model documented.
- [ ] Support/managed-service boundary clear.
- [ ] Offboarding test clear.
- [ ] Recurring service packages can be described without Zentari owning customer accounts.

## Stop conditions

Stop and review before continuing if:

- a restore fails
- required recovery credentials are missing
- R410 storage is degraded
- production data exists only on one host
- a migration requires an untested irreversible schema change
- a new tool is being added without a current problem it solves

## Definition of this phase complete

This phase is complete when:

- [ ] hardware inventory is reconciled
- [ ] recovery secrets are escrowed
- [ ] Restic/B2 restore is proven
- [ ] PostgreSQL restore is proven
- [ ] R410 is safely converted to Vault or explicitly held
- [ ] one Forge VM can be backed up/restored through Vault
- [ ] staging can deploy the Atlas Compose stack from Git
- [ ] Caddy is validated
- [ ] Twenty works in staging with backup/restore proven
- [ ] Atlas can be rebuilt from Git + backups
- [ ] actual Atlas RTO is measured
- [ ] Citadel is simplified toward AI-only
- [ ] Oracle monitors from outside
- [ ] first lead-to-customer workflow works end-to-end

When all boxes above are checked, stop infrastructure work for a moment and reassess against actual business/customer needs before adding anything from the future-roadmap document.
