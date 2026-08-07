# Recover Tailscale / private management

1. Determine whether the failure is endpoint, ACL, identity provider, DNS, subnet routing, or control-plane related.
2. Use provider console access or the sealed break-glass path for one host; do not expose management ports publicly as a shortcut.
3. Restore time/DNS/connectivity, validate the node identity, and compare intended ACL policy with last reviewed configuration.
4. Re-establish least-privilege operator access, then service identities and routes in controlled order.
5. Test SSH, Proxmox, observability admin, database admin, and backup paths from an authorized operator device.
6. Revoke temporary access and rotate any recovery credentials.

M3 must add tailnet, identity, ACL source, console, timeout, and provider-specific recovery details.
