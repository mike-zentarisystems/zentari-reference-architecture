# Customer Delivery Template

## Default ownership model

Customer owns:

- SaaS/cloud tenant
- n8n Cloud or customer-hosted automation account
- CRM tenant
- domain/DNS account
- email/SMS provider accounts
- business data
- billing
- master credentials

Zentari receives delegated access and implements/manages the solution under contract.

## Standard delivery phases

### 1. Discovery

Document:

- business outcome
- current systems
- authoritative systems of record
- users/roles
- integrations
- compliance/security requirements
- expected volume
- required RTO/RPO if relevant

### 2. Account ownership

Customer creates/owns accounts. Zentari receives scoped admin/developer access.

Never make the customer's operation depend on a Zentari personal account or Zentari-owned payment method unless the service is explicitly sold as Zentari-hosted.

### 3. Build

Preferred pattern:

```text
Customer systems
      |
Customer-owned n8n
      |
CRM / APIs / AI / Comms
      |
Business outcome
```

Use deterministic workflow logic where possible. Use AI where language/reasoning adds value.

### 4. Test

- happy path
- duplicate/retry path
- missing/invalid data
- provider/API failure
- permission failure
- notification failure
- human handoff

### 5. Handoff

Deliver:

- workflow inventory
- architecture diagram
- credential ownership map
- runbook
- support contacts
- escalation path
- backup/export instructions where relevant
- list of recurring vendor costs

### 6. Managed service

Possible recurring services:

- workflow monitoring
- break/fix
- monthly optimization
- CRM operations
- AI operations
- reporting
- new automation allowance
- security/access review

### 7. Offboarding test

Customer must be able to revoke Zentari access and retain:

- accounts
- data
- domains
- workflows/exports
- documentation
- backups where contracted

If they cannot, ownership boundaries are wrong.
