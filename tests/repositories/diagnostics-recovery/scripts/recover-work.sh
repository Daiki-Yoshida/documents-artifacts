#!/bin/sh
# Work-scoped recovery: converges .runtime/work/<slug>/ to the expected
# healthy marker. Shared and persistent state are never touched.
set -eu
cd "$(dirname "$0")/.."
. scripts/runtime-lib.sh

slug=$(require_work "$1")
port=$(expected_port "$slug")
dir=$(work_dir "$slug")
ready="port-$port.ready"

mkdir -p "$dir"
for marker in "$dir"/*; do
  [ -e "$marker" ] || continue
  if [ "${marker#$dir/}" != "$ready" ]; then
    rm -f "$marker"
    printf 'recover-work: removed stale/unexpected state %s\n' "$marker"
  fi
done
touch "$dir/$ready"
printf 'recover-work: %s now has %s\n' "$dir" "$ready"
