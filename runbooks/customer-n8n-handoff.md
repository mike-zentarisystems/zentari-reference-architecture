# Runbook: Customer-Owned n8n Handoff

## Goal

Deliver automation without making Zentari the permanent owner of the customer's execution environment.

## Preferred deployment

- Customer-owned n8n Cloud, or
- Customer-owned self-hosted n8n.

## Handoff checklist

1. Customer owns the n8n account/subscription or infrastructure account.
2. Customer controls billing and account recovery email/MFA.
3. Zentari receives delegated admin/developer access.
4. Workflow source/exports are stored in the agreed customer/Zentari project repository or handoff package.
5. Credentials are created in the customer's environment using customer-owned secrets.
6. Workflow purpose, triggers, dependencies and failure paths are documented.
7. Monitoring/alerting responsibility is documented.
8. A test execution succeeds.
9. Disable or revoke Zentari access temporarily and confirm the customer can still access and operate the environment.
10. Record support/managed-service responsibilities and escalation path.

## Offboarding

- Export final workflow/config documentation.
- Confirm customer credential ownership.
- Remove Zentari users/tokens/access.
- Confirm automations continue to execute.
- Deliver open issues and known limitations.

## Success criterion

The customer remains operational after Zentari access is removed.