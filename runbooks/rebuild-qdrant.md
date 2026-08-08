# Runbook: Rebuild Qdrant From Authoritative Knowledge

## Principle

Qdrant is an index, not the source of truth. Obsidian, AppFlowy, GitHub and other approved systems remain authoritative.

## Preconditions

Record:
- source repositories/collections
- embedding model and exact version
- chunking configuration
- metadata schema
- collection settings
- representative retrieval test questions

## Procedure

1. Create a new empty test collection.
2. Run the normal ingestion pipeline against authoritative sources.
3. Confirm expected document/chunk counts are plausible.
4. Run the fixed retrieval test set.
5. Confirm returned chunks reference the correct source documents.
6. Compare latency and relevance with the previous collection where possible.
7. Record rebuild duration and any missing source dependencies.
8. Only replace the active collection after validation.

## Success criteria

- Collection rebuild completes from source systems alone.
- No unique knowledge is required from the old Qdrant collection.
- Fixed test questions retrieve relevant source material.
- Embedding model/version and chunking settings are documented and reproducible.