#!/usr/bin/env bash
set -euo pipefail

# Isolated PostgreSQL restore harness.
# Usage:
#   ./scripts/test-postgres-restore.sh /path/to/database.sql
# or
#   PG_MAJOR=15 ./scripts/test-postgres-restore.sh /path/to/database.dump
#
# Requires Docker. Creates a temporary PostgreSQL container and never touches
# production databases.

DUMP_PATH="${1:-}"
if [[ -z "$DUMP_PATH" || ! -f "$DUMP_PATH" ]]; then
  echo "Usage: $0 /path/to/postgres-dump" >&2
  exit 2
fi

PG_MAJOR="${PG_MAJOR:-15}"
STAMP="$(date +%Y%m%d-%H%M%S)"
NAME="zentari-pg-restore-${STAMP}"
PASSWORD="zentari-temp-${STAMP}"
OUT="postgres-restore-${STAMP}.txt"

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

{
  echo "Zentari PostgreSQL Restore Test"
  echo "Time: $(date -Is)"
  echo "PostgreSQL major: ${PG_MAJOR}"
  echo "Dump: ${DUMP_PATH}"
  echo

  docker run -d --name "$NAME" \
    -e POSTGRES_PASSWORD="$PASSWORD" \
    -e POSTGRES_DB=restoretest \
    postgres:"$PG_MAJOR"

  echo "Waiting for PostgreSQL..."
  for _ in $(seq 1 60); do
    if docker exec "$NAME" pg_isready -U postgres >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  docker exec "$NAME" pg_isready -U postgres

  BASENAME="$(basename "$DUMP_PATH")"
  docker cp "$DUMP_PATH" "$NAME:/tmp/$BASENAME"

  echo
  echo "== Restore =="
  case "$DUMP_PATH" in
    *.sql)
      docker exec -e PGPASSWORD="$PASSWORD" "$NAME" \
        psql -v ON_ERROR_STOP=1 -U postgres -d restoretest -f "/tmp/$BASENAME"
      ;;
    *)
      docker exec -e PGPASSWORD="$PASSWORD" "$NAME" \
        pg_restore --exit-on-error --no-owner --no-privileges \
        -U postgres -d restoretest "/tmp/$BASENAME"
      ;;
  esac

  echo
  echo "== Database list =="
  docker exec -e PGPASSWORD="$PASSWORD" "$NAME" \
    psql -U postgres -Atc '\l'

  echo
  echo "== Table inventory =="
  docker exec -e PGPASSWORD="$PASSWORD" "$NAME" \
    psql -U postgres -d restoretest -c '\dt *.*'

  echo
  echo "== Largest tables =="
  docker exec -e PGPASSWORD="$PASSWORD" "$NAME" \
    psql -U postgres -d restoretest -c \
    "SELECT schemaname, relname, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC NULLS LAST LIMIT 25;"

  echo
  echo "RESTORE TEST COMPLETED"
} 2>&1 | tee "$OUT"

echo "Evidence file: $OUT"
echo "Temporary PostgreSQL container has been removed."
