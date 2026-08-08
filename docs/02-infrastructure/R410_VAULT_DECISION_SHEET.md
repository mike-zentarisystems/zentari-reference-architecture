# R410 / Vault Decision Sheet

## Goal

Decide how to repurpose the Dell R410 only after the current VMware state and storage health are verified.

## Known

- Dell PowerEdge R410
- approximately 56 GB RAM
- approximately 1.81 TB datastore capacity
- current ESXi 6.7 environment
- intended future role: Vault, storage, backup and recovery

## Must verify before wipe

- RAID controller model
- RAID level
- physical disk count
- disk capacities/models
- disk health / predictive failure state
- controller battery/cache state
- datastore contents
- existing VM inventory
- anything unique that must be preserved
- NIC count/speeds

## Decision gates

### GO: convert to Proxmox/Vault

Proceed when:

- no needed VMware workload remains unprotected
- RAID/storage health is acceptable
- required data is copied elsewhere
- Proxmox install media and management access are ready
- recovery plan exists if install fails

### HOLD

Hold if:

- disk health is uncertain
- RAID is degraded
- unique VM/data exists only on the R410
- controller/cache battery issues make storage unreliable

## Initial Vault layout

Keep the first build boring:

- Proxmox VE host
- PBS capability / backup datastore
- restore-test VM/workspace
- ISO/template storage
- bulk/archive storage

Do not start by adding Gitea, MinIO, registries, databases or other utility services. Add them only when a real need exists.

## Storage principle

Forge runs latency-sensitive VMs locally. Vault supplies backup and bulk storage. Do not make normal Forge operation depend on Vault via remote VM disks.

## Evidence

Attach audit output/screenshots under `evidence/` and record the final GO/HOLD decision here before wiping ESXi.
