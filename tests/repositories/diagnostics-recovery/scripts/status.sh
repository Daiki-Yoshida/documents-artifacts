#!/bin/sh
# Observe runtime state for a Work. Never mutates anything.
set -eu
cd "$(dirname "$0")/.."
. scripts/runtime-lib.sh

slug=$(require_work "$1")
port=$(expected_port "$slug")
dir=$(work_dir "$slug")

printf 'status: work=%s slug=%s expected-port=%s\n' "$1" "$slug" "$port"
if [ -d "$dir" ]; then
  printf 'status: work-state dir present: %s\n' "$dir"
  found=0
  for marker in "$dir"/*; do
    [ -e "$marker" ] || continue
    found=1
    printf 'status:   marker %s\n' "${marker#$dir/}"
  done
  [ "$found" -eq 1 ] || printf 'status:   (no markers)\n'
else
  printf 'status: work-state dir absent: %s\n' "$dir"
fi
[ -f "$SHARED_CACHE_MARKER" ] \
  && printf 'status: shared cache present: %s\n' "$SHARED_CACHE_MARKER" \
  || printf 'status: shared cache MISSING: %s\n' "$SHARED_CACHE_MARKER"
[ -f "$PERSISTENT_DB_MARKER" ] \
  && printf 'status: persistent db present: %s\n' "$PERSISTENT_DB_MARKER" \
  || printf 'status: persistent db MISSING: %s\n' "$PERSISTENT_DB_MARKER"
