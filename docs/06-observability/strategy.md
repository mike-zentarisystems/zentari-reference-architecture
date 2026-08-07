# Observability strategy

Watchtower provides independent external checks; Vault provides capacity for longer-lived local metrics/logs after conversion. Exact placement of Grafana, Prometheus, Loki, Alertmanager, and Uptime Kuma is decided during M5 based on connectivity and storage measurements.

## Minimum signals

- Public HTTP availability, latency, and certificate expiry
- DNS resolution from outside Zentari networks
- Service health and dependency reachability
- Host CPU, memory, disk, I/O, temperature, and restart state
- Backup completion, age, size anomaly, offsite copy, and last restore-test age
- n8n failure and queue depth
- LiteLLM local/cloud route, latency, errors, and spend
- Database availability, connections, replication (if any), and storage growth

Alerts must name impact, affected dependency, evidence, owner, and a runbook. Test at least one delivery path quarterly and after routing changes. Monitoring credentials are read-only wherever possible.
