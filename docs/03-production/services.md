# Production services

## Core target services

| Service | Role | Data authority | Notes |
|---|---|---|---|
| Twenty | Preferred self-hosted CRM candidate | CRM records if promoted | Pilot first; export and rollback required |
| HubSpot Free | Supported SaaS CRM alternative | CRM records when selected | Never described as unsupported merely because Twenty is preferred |
| n8n | Cross-system orchestration | Workflow definitions and execution state only | Business data remains in its owning system |
| LiteLLM | OpenAI-compatible model gateway | Routing/configuration, not business records | Local-first with approved cloud fallback |
| AppFlowy | Internal knowledge/workspace candidate | Documents when adopted | Backup exports and database required |
| PostgreSQL | Primary database engine | Per-application databases | Separate roles and backups per application |

## Optional components

- Mautic: marketing automation; introduces MariaDB/MySQL and should be adopted only for a validated nurture requirement.
- Baserow: operational data interface; adopt only for a use case not better owned by CRM or a custom app.
- Supabase: managed backend for custom web applications; do not treat it as a host for packaged applications.

## Integration rules

- Public Vercel/Cloudflare applications call authenticated production APIs.
- Persist inbound leads to the selected operational ledger before asynchronous CRM/n8n synchronization when the custom-app pattern is used.
- Use signed webhooks, idempotency keys, retry limits, dead-letter handling, and correlation IDs.
- Production and staging use different credentials, databases, buckets, DNS, and webhook endpoints.
