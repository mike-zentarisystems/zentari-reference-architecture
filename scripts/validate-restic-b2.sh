#!/usr/bin/env bash
set -euo pipefail

# Read-only Restic/B2 validation. Requires the repository/password/access
# variables to already be available in the shell environment.

STAMP="$(date +%Y%m%d-%H%M%S)"
HOST="$(hostname -s 2>/dev/null || hostname)"
OUT="restic-check-${HOST}-${STAMP}.txt"

required=(RESTIC_REPOSITORY RESTIC_PASSWORD)
for var in "${required[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: $var is not set." >&2
    exit 2
  fi
done

{
  echo "Zentari Restic Validation"
  echo "Host: ${HOST}"
  echo "Time: $(date -Is)"
  echo
  echo "== Restic version =="
  restic version
  echo
  echo "== Repository snapshots =="
  restic snapshots --compact
  echo
  echo "== Repository statistics =="
  restic stats --mode raw-data
  echo
  echo "== Repository integrity check =="
  restic check
} 2>&1 | tee "$OUT"

echo
echo "Evidence file: $OUT"
echo "Review it for secrets before committing under evidence/backups/restic-check/."
