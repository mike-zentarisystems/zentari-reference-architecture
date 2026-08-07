# Server roles

## Atlas — production VPS (target name)

Runs production business services and stateful APIs. Databases remain local to the VPS or its provider network. Public administration is prohibited.

## Citadel — Zentari AI compute

Runs local inference, LiteLLM routing, Hermes, Qdrant, embeddings, and internal AI tooling for Zentari operations. It is not a customer hosting or inference platform and does not process customer workloads or payloads. Customer AI endpoints deploy inside the VPS or customer-controlled cloud boundary.

## Forge — primary Proxmox

Runs staging, development, upgrade rehearsals, and disposable integration environments. Observed capacity is 32 logical CPUs and 126 GB RAM; storage capacity and health remain to be inventoried.

## Vault — converted Dell R410

Target infrastructure plane after ESXi evacuation and hardware validation. Runs local backup repositories, restore-test VMs, monitoring storage, templates, caches, and build utilities. It must not host customer production databases.

## Watchtower — Oracle OCI

Runs checks outside the main production and residential failure domains: HTTP, DNS, TLS, backup freshness, alerts, and recovery coordination. It may host an emergency control agent or LiteLLM fallback, but not become an undocumented production authority.

## Capacity guardrails

- Capture measured CPU, memory, storage, IOPS, and growth before allocating workloads.
- Keep at least 20% operational headroom on production and backup storage.
- Do not rely on Oracle free-tier status until billing eligibility is verified.
- Add a second VPS only for measured capacity, isolation, or availability requirements.
