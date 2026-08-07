# ADR-0001: Separate platform planes and keep Citadel Zentari-only

- Status: Accepted
- Date: 2026-08-07
- Owners: Architecture and Operations
- Supersedes: None
- Review trigger: A customer contract requires a different hosting model

## Context

Zentari uses public edge hosting, a production VPS, private AI compute, local staging/infrastructure hosts, Oracle OCI, and Backblaze. Mixing customer production with Citadel or residential infrastructure creates unclear ownership and availability dependencies.

## Decision

Customer workloads and customer payload processing run on the production VPS or customer-controlled cloud. Citadel runs Zentari-only internal AI and is not used as a customer inference endpoint. Vercel/Cloudflare own public delivery; Forge owns staging; Vault owns local infrastructure/recovery; Watchtower owns independent checks and recovery coordination.

## Consequences

Failure domains and responsibilities are clearer. Cross-plane integrations require authentication, observability, and data classification. Some workloads may cost more because customer production cannot use idle home compute.

## Alternatives considered

Hosting customer services on Citadel or Proxmox was rejected due to tenant, connectivity, security, and residential failure-domain risk. A single all-purpose VPS was rejected as the long-term reference pattern, though the current VPS may temporarily host multiple business services.

## Reversibility and migration

The names and implementation technology are reversible. The customer isolation rule changes only through a superseding ADR with contractual, security, availability, and recovery evidence.
