# ADR-0005: Use Tailscale for private management

- Status: Accepted
- Date: 2026-08-07
- Owners: Security and Operations
- Supersedes: None
- Review trigger: Identity provider, network scale, or regulatory requirements change

## Context

Administrative surfaces span cloud and local environments. Publicly exposing them increases attack surface and creates inconsistent controls.

## Decision

Use Tailscale as the default management network with individual identities, MFA, role-based ACLs, and scoped service identities. Public ingress remains limited to intentional application routes.

## Consequences

Management becomes consistent and private, but Tailscale identity/control availability becomes an operational dependency requiring break-glass access.

## Alternatives considered

Public IP allowlists were rejected as brittle. A self-managed VPN remains a future option but adds operational burden. SSH tunnels alone do not cover all administrative services.

## Reversibility and migration

Document private addressing and ACL intent independently of Tailscale. Preserve provider consoles and sealed recovery access so the network can be replaced or repaired.
