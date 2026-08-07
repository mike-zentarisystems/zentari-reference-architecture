#!/usr/bin/env bash
set -euo pipefail

# Zentari M0 host inventory collector.
# Read-only by design. It does not print environment variable values or secret file contents.
# Usage: sudo bash scripts/collect-host-inventory.sh > inventory-$(hostname)-$(date +%F).txt

section() {
  printf '\n===== %s =====\n' "$1"
}

run() {
  local label="$1"
  shift
  printf '\n--- %s ---\n' "$label"
  "$@" 2>&1 || true
}

section "IDENTITY"
run "date" date --iso-8601=seconds
run "hostname" hostnamectl
run "whoami" whoami

section "OPERATING SYSTEM"
run "os-release" cat /etc/os-release
run "kernel" uname -a
run "uptime" uptime

section "CPU AND MEMORY"
run "lscpu" lscpu
run "memory" free -h
run "swap" swapon --show

section "STORAGE"
run "block devices" lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL
run "filesystem usage" df -hT
run "lvm physical volumes" pvs
run "lvm volume groups" vgs
run "lvm logical volumes" lvs

section "NETWORK"
run "addresses" ip -br addr
run "routes" ip route
run "listening sockets" ss -lntup

section "DOCKER"
if command -v docker >/dev/null 2>&1; then
  run "docker version" docker version
  run "docker info summary" docker info --format 'ServerVersion={{.ServerVersion}} Driver={{.Driver}} CgroupDriver={{.CgroupDriver}} Containers={{.Containers}} Images={{.Images}}'
  run "containers" docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
  run "networks" docker network ls
  run "volumes" docker volume ls
  run "compose projects" docker compose ls
else
  echo "Docker not installed."
fi

section "SYSTEMD SERVICES"
run "running services" systemctl list-units --type=service --state=running --no-pager
run "failed services" systemctl --failed --no-pager

section "COMMON DATABASE PROCESSES"
run "database processes" bash -c "ps aux | grep -Ei '[p]ostgres|[m]ysqld|[m]ariadbd|[r]edis-server|[q]drant'"

section "COMMON APPLICATION PROCESSES"
run "application processes" bash -c "ps aux | grep -Ei '[n]8n|[l]itellm|[h]ermes|[o]llama|[u]vicorn|[g]unicorn|[t]raefik|[g]rafana|[p]rometheus|[l]oki|[i]nfisical'"

section "SCHEDULED JOBS"
run "root crontab" crontab -l
run "system timers" systemctl list-timers --all --no-pager

section "BACKUP SOFTWARE"
for binary in restic rclone borg kopia; do
  if command -v "$binary" >/dev/null 2>&1; then
    printf '%s: ' "$binary"
    "$binary" version 2>&1 | head -n 1 || true
  fi
done

section "TAILSCALE"
if command -v tailscale >/dev/null 2>&1; then
  run "tailscale status" tailscale status
else
  echo "Tailscale not installed."
fi

section "NVIDIA"
if command -v nvidia-smi >/dev/null 2>&1; then
  run "nvidia-smi" nvidia-smi
fi

section "NOTES"
echo "Collector intentionally excludes environment variable values, .env contents, tokens, passwords and private keys."
echo "Review output before committing it to Git. Remove public IPs, serial numbers or other sensitive metadata if repository visibility requires it."
