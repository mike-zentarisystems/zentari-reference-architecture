# Citadel AI plane

Citadel is a private, operator-owned Zentari AI platform. It is not a customer production host.

## Target responsibilities

- Local inference through Ollama or another approved runtime
- LiteLLM-compatible routing and policy
- Hermes and internal agents
- Qdrant, embeddings, and reranking
- Model and route observability
- Explicit cloud fallback to approved providers

## Boundary controls

- Private network access and service authentication are required.
- Customer workloads and payloads are prohibited. A customer AI requirement receives a separate deployment inside the VPS or customer-controlled cloud boundary.
- Model files that can be downloaded again are not routine backup targets; configurations, prompts, indexes, routing policies, and Qdrant snapshots are.
- Cloud fallback must be visible in logs and constrained by data classification, cost limits, and provider allowlists.
- Production systems degrade safely when Citadel is unavailable; they do not silently redirect sensitive payloads to cloud models.
