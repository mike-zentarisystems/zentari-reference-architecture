# ADR-0003: Convert the legacy VMware host to Proxmox infrastructure

- Status: Proposed
- Date: 2026-08-07
- Owners: Infrastructure
- Supersedes: None
- Review trigger: Hardware/storage validation or migration discovery changes feasibility

## Context

The Dell R410 runs ESXi 6.7 with observed 12 logical CPUs, 56 GB RAM, and approximately 1.8 TB datastore. A second Proxmox host would simplify automation and provide local recovery capacity.

## Decision

After workload inventory, backup, restore proof, and hardware validation, convert the host to Proxmox and assign the target name `vault`. Use it for backups, restore testing, monitoring storage, templates, caches, and build utilities—not customer production.

## Consequences

Operations standardize on Proxmox, but the conversion is destructive and temporarily removes the ESXi rollback path. Old hardware and disks may fail validation.

## Alternatives considered

Keeping ESXi was rejected as the target due to age and split operations. Using the host for production was rejected due to residential and hardware risk. Retirement remains the fallback if validation fails.

## Reversibility and migration

Before installation, export the VM inventory, configurations, and backups; restore critical workloads elsewhere; preserve install media and configuration evidence; and hold a rollback window. Once disks are reformatted, rollback means reinstalling ESXi and restoring backups.
