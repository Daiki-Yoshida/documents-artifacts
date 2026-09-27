#!/usr/bin/env bash
# Prepare hook for diagnostics-before-recovery.
# Runs after the Artifact install commit with $TARGET pointing at the
# generated repository. Seeds git-ignored runtime state so the prepared
# tree stays clean:
#
#   .runtime/shared/package-cache.keep        (Project-scoped — present)
#   .runtime/persistent/dev-db.keep           (persistent — present)
#   .runtime/work/feat-export/port-9000.stale (Work-scoped — STALE)
#
# The healthy marker (port-9100.ready per config/work-ports.conf) is
# deliberately absent.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

mkdir -p "$TARGET/.runtime/shared" "$TARGET/.runtime/persistent" \
         "$TARGET/.runtime/work/feat-export"
touch "$TARGET/.runtime/shared/package-cache.keep" \
      "$TARGET/.runtime/persistent/dev-db.keep" \
      "$TARGET/.runtime/work/feat-export/port-9000.stale"
