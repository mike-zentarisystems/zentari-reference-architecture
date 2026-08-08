# First Revenue Workflow

## Objective

Prove Zentari can take a real lead from intake to a useful business outcome using the simplified platform.

## Reference workflow

```text
Lead source
  |
Web form / BotPenguin / referral
  |
  v
Customer/Zentari automation
  |
  +--> validate and normalize
  +--> deduplicate
  +--> create/update CRM
  +--> optionally enrich company/contact
  +--> AI classify fit/intent when useful
  +--> create opportunity/task
  +--> send acknowledgement through approved provider
  +--> offer scheduling or next step
  +--> notify owner
  +--> record status and outcome
```

## Zentari internal implementation

- Twenty is the CRM target once staging passes.
- Zentari internal n8n may run the workflow.
- Resend can handle transactional acknowledgement where appropriate.
- AI is optional and must add useful classification/reasoning rather than replace simple rules.

## Customer implementation pattern

- Customer owns CRM and n8n Cloud/self-hosted account.
- Zentari configures workflow using delegated access.
- Customer owns messaging provider and business data.

## Acceptance criteria

- [ ] valid lead enters once
- [ ] duplicate lead does not create duplicate customer record
- [ ] malformed lead is rejected or routed for review
- [ ] CRM record is created/updated correctly
- [ ] opportunity/task is created when qualification rules require it
- [ ] acknowledgement is sent once
- [ ] owner is notified
- [ ] workflow failure is visible
- [ ] retry does not create duplicate side effects
- [ ] workflow can be exported/documented
- [ ] customer can retain system after Zentari access is revoked

## Success metric

The workflow is successful when a nontechnical business owner can explain the result in one sentence: "A lead comes in, the right systems update automatically, the right person gets notified, and nothing important depends on someone remembering to copy data manually."
