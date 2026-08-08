# Zentari Platform — ELI10 Guide

**Status:** Plain-English companion to `ZENTARI_PLATFORM_CURRENT.md`  
**Audience:** Customers, partners, future Zentari team members, and anyone asking “what does all this actually do?”

## The 30-second explanation

Zentari is building a small digital factory.

A business has information coming from websites, forms, email, CRM systems, documents, calendars, APIs and people. Normally those systems do not work together very well. People copy information between them, forget follow-ups, repeat work and spend time searching for answers.

Zentari connects those systems, automates the repeatable work, and adds AI where reasoning or language is useful.

The important part is that the customer still owns their business systems and data. Zentari builds and operates the machinery connecting them.

```text
Customer's business systems
Forms / CRM / Email / Documents / Apps
                |
                v
        Automation and APIs
              n8n
                |
        +-------+-------+
        |               |
        v               v
   Business logic       AI
   Twenty / APIs      Hermes / LLMs
        |               |
        +-------+-------+
                |
                v
       Useful business outcome
```

## A LEGO analogy

Think of Zapier, n8n, Claude, HubSpot, Resend and other services as LEGO pieces.

None of those pieces is the whole system.

Zentari's job is to decide:

- which pieces are appropriate,
- how they connect,
- where important information lives,
- what happens when something breaks,
- who owns each account,
- how the system is backed up,
- and how it can evolve later without starting over.

The value is not owning the LEGO bricks. The value is designing and maintaining the machine built from them.

## What are we actually building?

The platform has several computers with deliberately different jobs.

```text
                         THE INTERNET
                              |
                    Cloudflare / Vercel
                              |
                              v
                         ATLAS VPS
                     Business Production
                              |
                     private Tailscale
                              |
        +---------------------+--------------------+
        |                     |                    |
        v                     v                    v
     CITADEL                FORGE                VAULT
        AI             Build & Test         Backup & Storage
        |                     |                    |
        +---------------------+--------------------+
                              |
                              v
                         ORACLE OCI
                      Outside Watchtower

                         BACKBLAZE
                       Offsite Recovery
```

## Atlas: the store

Atlas is the paid Internet VPS.

Imagine it as the actual store where the business is operating. It should be boring and dependable.

Atlas can run things such as:

- Twenty CRM,
- Zentari's internal n8n,
- PostgreSQL databases,
- LiteLLM when needed,
- production applications,
- and Caddy for directing incoming web traffic.

Why put these here?

Because customer-facing production cannot depend on a server sitting in a basement. If the house loses Internet or power, the business should keep working.

## Citadel: the brain room

Citadel is the AI machine with an RTX 3060 GPU.

Its job is AI, not running the whole company.

It can run:

- Hermes,
- local language models,
- embeddings,
- Qdrant search indexes,
- and AI tools.

Why separate it?

AI workloads are unusual. They consume GPU resources and change faster than normal business software. Separating them lets us experiment with AI without destabilizing the CRM or automation system.

If Citadel breaks, we should lose AI capability temporarily, not the company's authoritative records.

## Forge: the workshop

Forge is the large Proxmox server.

Think of it as the workshop where we build and test things before putting them in the store.

Forge is used for:

- development,
- staging,
- testing upgrades,
- testing restores,
- Buzz and AI development,
- optional Coolify deployment management,
- and temporary lab environments.

Why?

We do not want to discover that an upgrade breaks Twenty CRM by trying it first on the production server.

We test it on Forge first.

## Vault: the warehouse and emergency supply room

Vault is the older server with lots of storage.

Its main job is not to run everyday production. Its job is to protect everything else.

Vault provides:

- Proxmox backups,
- local backup storage,
- restore testing,
- ISO images and templates,
- archive space,
- and recovery workspace.

Why?

Forge has lots of compute and memory but limited storage. Vault has useful bulk storage. Each machine does the job it is naturally good at.

## Oracle: the security guard across the street

Oracle OCI is deliberately treated as an outside observer.

It can check:

- Is the website alive?
- Is Atlas responding?
- Is DNS working?
- Are certificates healthy?
- Are backups reporting success?

It may also run a limited secondary Hermes agent.

Why outside?

A monitoring system inside your own network cannot reliably tell you that your entire network disappeared.

Oracle is not disaster recovery. If it vanishes, Zentari should continue operating.

## Backblaze: the copy somewhere else

Vault protects us from normal failures, but Vault is still physically in the same general environment as Forge and Citadel.

Backblaze keeps important recovery data offsite.

The simple rule is:

> A backup sitting next to the computer it protects is not enough.

We also periodically restore the backups. A backup we have never restored is only a hope.

## Tailscale: the private hallway

All Zentari machines communicate privately using Tailscale.

Instead of exposing database ports, admin panels and management interfaces to the whole Internet, the machines communicate through a private encrypted network.

Think of the public Internet as the front door and Tailscale as the employee hallway behind the building.

Customers use the front door. Administrators use the private hallway.

## Caddy: the receptionist

Caddy receives appropriate incoming web requests and sends them to the correct application.

For example:

```text
crm.example.com  -> CRM
app.example.com  -> customer app
automation.example.com -> automation service
```

Caddy also makes HTTPS certificate management relatively simple.

We picked one standard so we stop spending time comparing reverse proxies.

## Docker Compose: the instruction manual

A server should not depend on somebody remembering how it was configured six months ago.

Important applications are described in Git using Docker Compose.

Conceptually:

```text
GitHub
   |
   v
Docker Compose
   |
   v
Server
   |
   v
Running application
```

If Atlas dies, the goal is not to repair that exact machine forever.

The goal is to be able to create another VPS, retrieve the instructions from Git, restore the data, and run the system again.

That is why Git and backups are more important than making any individual server immortal.

## Coolify: optional remote control

Coolify can make deployments easier through a friendly management interface.

But it is a convenience, not the foundation.

If Coolify disappears, the Compose files should still tell us how to run the applications.

This avoids locking the architecture to a management dashboard.

## Twenty: Zentari's CRM

Twenty is the intended CRM for Zentari's own operations once staging testing is complete.

It tracks things like:

- leads,
- companies,
- contacts,
- opportunities,
- and sales activity.

HubSpot remains important because customers may use HubSpot. Zentari should know how to integrate with it.

But Zentari does not need to maintain two internal CRMs containing the same authoritative information.

## n8n: the conveyor belts

n8n moves information and triggers work between systems.

Example:

```text
Website form
     |
     v
    n8n
     |
     +--> create CRM lead
     |
     +--> enrich information
     |
     +--> ask AI to classify the request
     |
     +--> send acknowledgement
     |
     +--> notify salesperson
     |
     +--> schedule follow-up
```

For Zentari itself, Zentari can operate its own n8n.

For customers, the preferred model is customer-owned n8n Cloud or customer-owned infrastructure. Zentari gets permission to build and manage the workflows.

The customer owns the account and data.

## The second brain

The AI itself is not the source of truth.

Important knowledge lives in durable systems:

- Obsidian for personal knowledge,
- AppFlowy for company/team knowledge if adopted,
- GitHub for code and technical documentation,
- Twenty for CRM records.

n8n can feed those documents through an embedding process into Qdrant so Hermes can search them intelligently.

```text
Real documents
     |
     v
   Index
  Qdrant
     |
     v
   Hermes
```

If Qdrant breaks, we rebuild it from the real documents.

We do not want the only copy of important knowledge trapped inside an AI memory system.

## Where does Claude fit?

Claude, ChatGPT and other cloud AI systems can be excellent reasoning engines.

They are not replacements for the architecture.

An AI agent can think, write, classify, summarize, research or decide what tool to call. But the surrounding system still needs to answer questions such as:

- Where is the customer's authoritative record?
- Who owns the credentials?
- What triggers the agent?
- What is it allowed to change?
- Where are actions logged?
- What happens when the AI provider is unavailable?
- How are workflows tested?
- How are business systems restored?

So Zentari can absolutely use Claude, OpenAI models, Gemini, local models or future providers inside this architecture.

The architecture makes the model a replaceable component instead of making the whole business dependent on one AI vendor.

## Where does Zapier fit?

Zapier is excellent for many straightforward SaaS automations.

For example:

```text
New form submission -> add CRM contact -> send email
```

For a small requirement, Zapier may be the correct answer. Zentari should not replace a five-minute Zap with a custom platform merely because we can.

The architecture becomes more useful when the automation needs things such as:

- complex branching,
- custom APIs,
- databases,
- AI reasoning,
- private systems,
- reusable code,
- multiple AI providers,
- detailed ownership boundaries,
- custom customer applications,
- portability,
- or a recovery strategy spanning several systems.

The difference is not “Zentari is better than Zapier.”

The difference is:

> Zapier is one possible automation tool. Zentari designs the complete business system and can use Zapier when Zapier is the right tool.

## Why not just build a Claude agent?

Because an agent is a worker, not the company.

Imagine hiring an incredibly capable employee but giving them no filing system, no CRM, no backup plan, no operating procedures, no security rules and no clear authority.

That employee might still accomplish impressive things, but the business around them would be fragile.

The Zentari architecture supplies the workplace around the agent:

```text
                    BUSINESS SYSTEM

 CRM        Documents       Databases       APIs
  |             |               |            |
  +-------------+-------+-------+------------+
                        |
                   Automation
                        |
                        v
                  AI / Agents
            Claude / OpenAI / Hermes
                        |
                        v
                 Business Action
                        |
                        v
                Logs / Records / CRM
```

The AI is powerful because it has controlled access to real tools and trustworthy information.

## Why is this approach better?

It is better **when the problem requires it** because it separates things that should not be tangled together.

### Customer ownership

The customer owns their important accounts and data. Zentari manages them with delegated access.

If the relationship ends, the customer still owns their business.

### Vendor flexibility

Claude can be replaced by OpenAI, Gemini, a local model or whatever comes next without redesigning the entire company.

n8n can also be replaced if requirements or licensing change.

### Recoverability

Servers are disposable. Data and configuration are protected.

### Testability

Forge gives us somewhere to break things before production.

### Security

Administrative systems communicate privately over Tailscale instead of exposing everything publicly.

### Appropriate AI

AI is used where reasoning helps. Deterministic automation remains deterministic where possible.

We do not ask an LLM to perform work that a simple rule can do more reliably.

### Recurring value without lock-in

Zentari can earn recurring revenue by operating and improving the system:

- automation management,
- CRM operations,
- AI operations,
- infrastructure management,
- reporting,
- optimization,
- support,
- and ongoing development.

Customers stay because the system keeps creating value, not because Zentari holds their credentials hostage.

## An example customer journey

Imagine a roofing company.

A homeowner fills out a form requesting a quote.

A simple Zentari implementation could do this:

```text
Website form
     |
     v
Customer-owned n8n
     |
     +--> validate information
     |
     +--> create/update CRM lead
     |
     +--> AI classifies urgency and request type
     |
     +--> send personalized acknowledgement
     |
     +--> notify correct salesperson
     |
     +--> create follow-up task
     |
     +--> update reporting
```

Later we could add document processing, an AI receptionist, lead scoring, scheduling, quote assistance or customer portals without replacing the foundation.

That is the advantage of architecture over a pile of disconnected automations.

## What we deliberately are NOT building yet

The earlier design considered many useful technologies:

- giant observability stacks,
- Gitea,
- NetBox,
- Authentik,
- MinIO,
- Mautic,
- Baserow,
- private registries,
- HA databases,
- Kubernetes,
- Ceph,
- and other infrastructure.

Those are tools, not achievements.

They stay in the future roadmap until a real problem earns them a place.

## The simplest possible summary

```text
Atlas     = runs the business
Citadel   = does AI
Forge     = builds and tests
Vault     = protects and stores
Oracle    = watches from outside
Backblaze = keeps an offsite copy
Tailscale = private network
Git       = remembers how to rebuild things
Caddy     = sends web traffic to the right place
```

And for customers:

```text
Customer owns the accounts and data
              +
Zentari designs and operates the system
              +
AI providers and automation tools are replaceable parts
              =
A system that can grow without trapping the customer
```

## The rule to remember

> Zentari is not trying to beat Claude, Zapier, HubSpot, n8n or any other individual tool. Zentari's value is knowing how to combine the right tools into a secure, maintainable, recoverable business system that produces a useful outcome.

Sometimes the right solution really is just Zapier.

Sometimes it is a Claude agent.

Sometimes it is the full Zentari architecture.

Good architecture means knowing the difference.