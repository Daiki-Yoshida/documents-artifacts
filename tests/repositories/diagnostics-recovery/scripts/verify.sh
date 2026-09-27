#!/bin/sh
# Final Work runtime check. PASS only when the Work runtime is healthy
# AND shared/persistent state is intact. Never mutates anything.
set -eu
cd "$(dirname "$0")/.."
. scripts/runtime-lib.sh

slug=$(require_work "$1")
port=$(expected_port "$slug")
dir=$(work_dir "$slug")
ready="port-$port.ready"

failed=0
pass() { printf 'verify: PASS — %s\n' "$1"; }
fail() { printf 'verify: FAIL — %s\n' "$1" >&2; failed=1; }

if [ -f "$dir/$ready" ]; then
  pass "$dir/$ready present"
else
  fail "expected ready marker missing: $dir/$ready"
fi

if [ -d "$dir" ]; then
  for marker in "$dir"/*; do
    [ -e "$marker" ] || continue
    case "${marker#$dir/}" in
      "$ready") ;;
      *) fail "unexpected work runtime state: $marker" ;;
    esac
  done
fi

[ -f "$SHARED_CACHE_MARKER" ] \
  && pass "shared cache intact: $SHARED_CACHE_MARKER" \
  || fail "shared cache missing: $SHARED_CACHE_MARKER"

[ -f "$PERSISTENT_DB_MARKER" ] \
  && pass "persistent db intact: $PERSISTENT_DB_MARKER" \
  || fail "persistent db missing: $PERSISTENT_DB_MARKER"

[ "$failed" -eq 0 ] || exit 1
printf 'verify: PASS — work runtime %s healthy on port %s\n' "$slug" "$port"
