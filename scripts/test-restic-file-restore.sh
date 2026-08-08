#!/usr/bin/env bash
set -euo pipefail

# Restores a recent snapshot to an isolated temporary directory.
# It never writes over production paths.

STAMP="$(date +%Y%m%d-%H%M%S)"
HOST="$(hostname -s 2>/dev/null || hostname)"
TARGET="${1:-/tmp/zentari-restic-restore-${STAMP}}"
OUT="restic-file-restore-${HOST}-${STAMP}.txt"

if [[ -z "${RESTIC_REPOSITORY:-}" || -z "${RESTIC_PASSWORD:-}" ]]; then
  echo "ERROR: RESTIC_REPOSITORY and RESTIC_PASSWORD must be set." >&2
  exit 2
fi

mkdir -p "$TARGET"

{
  echo "Zentari Restic File Restore Test"
  echo "Host: ${HOST}"
  echo "Time: $(date -Is)"
  echo "Restore target: ${TARGET}"
  echo
  echo "== Latest snapshot =="
  restic snapshots --latest 1
  echo
  echo "== Restore latest snapshot into isolated target =="
  restic restore latest --target "$TARGET"
  echo
  echo "== Restored file count =="
  find "$TARGET" -type f | wc -l
  echo
  echo "== Restored size =="
  du -sh "$TARGET"
  echo
  echo "== Sample files =="
  find "$TARGET" -type f | head -50
} 2>&1 | tee "$OUT"

echo
echo "Evidence file: $OUT"
echo "Restore target retained at: $TARGET"
echo "Inspect representative restored files before deleting the target."
