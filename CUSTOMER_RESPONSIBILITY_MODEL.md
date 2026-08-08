# Customer / Zentari Responsibility Model

## Default principle

The customer owns the business accounts, data, subscriptions, domains, master credentials and policy decisions. Zentari designs, configures, integrates, operates and improves the system under delegated access.

## Responsibility matrix

| Area | Customer | Zentari |
|---|---|---|
| SaaS/cloud accounts | Owns tenant, billing and legal terms | Configures/integrates |
| n8n Cloud | Owns account and credentials | Builds, documents and maintains workflows |
| CRM | Owns data and user access | Configures schema, pipelines and integrations |
| Domains/DNS | Owns domain | Manages records when authorized |
| Email/SMS | Owns provider account and reputation | Configures automation/templates |
| API keys/secrets | Owns master credentials | Uses scoped/delegated credentials |
| Business rules | Approves policy and outcomes | Implements rules in systems/workflows |
| Backups | Approves retention/RPO/RTO and funds storage | Implements/tests when contracted |
| Security policy | Owns identity/employment/compliance decisions | Implements technical controls in scope |
| Compliance | Owns legal/regulatory obligations | Implements documented technical requirements |
| Source/workflows | Receives/owns deliverables per contract | Develops, versions, documents and supports |
| Support | Provides business context and approvals | Diagnoses/remediates per service scope |

## Preferred account pattern

```text
Customer-owned account
        |
Customer grants Zentari delegated access
        |
Zentari builds and operates
        |
Customer may revoke access and continue operating
```

## n8n

Default customer deployment:

1. Customer-owned n8n Cloud, or
2. Customer-owned self-hosted n8n.

Zentari's internal n8n is not the default execution environment for customer workflows.

## Hosting models

### Consulting
Customer owns and operates the environment. Zentari designs and implements.

### Managed
Customer owns the environment/accounts. Zentari operates them under a recurring service agreement.

### Zentari-hosted
Exception model only. Requires explicit licensing, backup, security, tenant isolation, support and contractual responsibility.

## Offboarding test

A customer deployment fails the ownership model if the customer cannot continue accessing its accounts, data, domains, workflows and backups after Zentari access is revoked.

## Recurring revenue

Customer ownership is compatible with recurring revenue through automation management, CRM operations, AI operations, infrastructure management, reporting, optimization and support. Retention should come from ongoing value, not ownership lock-in.