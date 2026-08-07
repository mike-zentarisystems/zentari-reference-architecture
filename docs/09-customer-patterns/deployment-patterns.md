# Customer deployment patterns

All patterns keep customer production outside Citadel and Zentari residential infrastructure.

## Cloud-lite

Vercel/Cloudflare public app, managed Supabase backend, approved SaaS CRM, and n8n in a managed or isolated cloud environment. Best for small custom applications with low operations overhead.

## VPS

Dedicated customer or Zentari-operated VPS with isolated compose stack, application-local database, private administration, encrypted offsite backup, and external monitoring. Best for packaged self-hosted services.

## Hybrid

Public and stateful workloads remain in customer-approved cloud; approved AI calls reach a separately contracted private AI endpoint. Data classification and fallback policy are mandatory.

## Sovereign / regulated

Customer-controlled infrastructure, identity, keys, logs, backups, and model runtime. No dependency on Citadel. Compliance requirements override the generic baseline.

Each deployment receives a separate inventory, threat model, RPO/RTO, responsibility matrix, data-flow record, and exit/export plan.
