# Zentari Platform PRD

## Product goal

Build the minimum dependable internal platform Zentari needs to deliver automation, AI, CRM, integration, and managed-operations work for customers without turning the platform itself into the product.

## Users

- Zentari operators and engineers
- Future Zentari team members
- Customers receiving implementations
- Customer admins who own the underlying SaaS/cloud accounts

## V1 outcomes

V1 is successful when Zentari can:

1. Rebuild Atlas from Git-tracked Compose and backups.
2. Restore critical PostgreSQL data in an isolated environment.
3. Stage and validate changes on Forge before production.
4. Use Citadel for stable AI workloads without making customer systems depend on the home lab.
5. Use Vault for local VM/data recovery and Backblaze for offsite recovery.
6. Monitor public availability from Oracle.
7. Run Twenty in staging and validate one complete lead-to-customer workflow.
8. Deliver customer automation using customer-owned n8n Cloud or customer-owned infrastructure by default.

## In scope

- Atlas production rebuild standard
- Caddy ingress
- Tailscale private fabric
- Git + Docker Compose as deployment authority
- Forge staging
- Vault/PBS/local restore capability
- Backblaze recovery
- Citadel AI services
- Oracle outside-in monitoring
- Twenty CRM staging validation
- customer ownership and offboarding model

## Out of scope for V1

- Kubernetes
- Ceph
- Kafka
- HA databases
- multi-region active-active
- full enterprise observability stack
- internal GitHub replacement
- centralized SSO platform unless a real need appears
- customer workloads hosted in the home lab

## Design principles

- Simple beats clever.
- Rebuildable beats immortal.
- Customer-owned accounts beat vendor lock-in.
- Deterministic automation beats AI where a rule is sufficient.
- The smallest component that solves a real problem wins.
- Revenue work proceeds in parallel with infrastructure hardening.

## Success metrics

- Atlas recovery drill completed and timed.
- PostgreSQL restore completed successfully.
- Qdrant rebuild completed successfully.
- Forge staging used before a production change.
- Twenty staging pilot completed.
- One end-to-end lead workflow demonstrated.
- No customer production dependency on basement infrastructure.
- All critical recovery secrets escrowed outside any single machine.

## Non-goal

The goal is not to build a miniature enterprise datacenter. The goal is to create a dependable factory for shipping customer outcomes.