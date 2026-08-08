# Atlas Baseline

This directory is the clean, Git-tracked baseline for the future Atlas production rebuild.

It is intentionally conservative. Do not deploy it over the current Atlas until the P0 recovery gates pass and Forge staging has validated the stack.

## Files

- `docker-compose.yml` — baseline services
- `.env.example` — required variable names only; never commit live secrets
- `Caddyfile` — ingress baseline
- `postgres/init/` — optional database/user initialization scripts when added
- `litellm/config.yaml` — LiteLLM routing configuration when added

## Validate before deployment

```bash
cp .env.example .env
# populate test/staging values only

docker compose config
```

Do not continue until Compose validates.

## Staging deployment

Start the baseline without Twenty first:

```bash
docker compose up -d
```

Twenty remains behind the `twenty` profile until its staging package is ready:

```bash
docker compose --profile twenty up -d
```

## Design rules

- Pin versions before production use.
- PostgreSQL is not exposed publicly.
- Application/data networks are internal.
- Caddy is the only intended public ingress for self-hosted Atlas applications.
- Tailscale handles private administration.
- Redis is not enabled for n8n unless queue mode is deliberately adopted. The Twenty profile has its own Redis dependency.
- Coolify may deploy/manage this stack later, but this Compose definition must remain sufficient to rebuild it without Coolify.

## Production gate

Before Atlas is rebuilt from this directory:

- Restic/Backblaze restore has passed.
- PostgreSQL isolated restore has passed.
- n8n encryption key is escrowed.
- Forge staging has successfully deployed this stack.
- Caddy HTTPS/WebSocket behavior has been tested.
- any required image/version-specific changes have been reconciled with upstream documentation.
