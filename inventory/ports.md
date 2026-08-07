# Port and exposure inventory

Record only intentional interfaces. Add confirmed addresses and firewall rules during M0.

| Interface class | Expected exposure | Rule |
|---|---|---|
| Public websites/APIs | Internet through Cloudflare/Vercel | HTTPS 443; authenticated routes where state is accessed |
| SSH | Tailscale/private | No public listener unless a time-bounded exception is recorded |
| Proxmox UI | Tailscale/private | Never public |
| Database | Local/provider-private/Tailscale service path | Never public |
| Grafana administration | Tailscale/private | Public status views require separate anonymous-safe design |
| Prometheus/Loki | Private service network | Read/write identities separated |
| LiteLLM/model APIs | Private service network | Authenticated and allowlisted |
| Backup repositories | Private service network/outbound B2 | No unauthenticated inbound access |

The live firewall, DNS, reverse proxy, Tailscale, and provider security rules are authoritative evidence. Update this file only after comparing all five.
