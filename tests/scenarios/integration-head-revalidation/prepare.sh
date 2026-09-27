#!/usr/bin/env bash
# Prepare hook for integration-head-revalidation.
# Invoked by prepare-agent-test.sh after the Artifact install commit
# with $TARGET pointing at the generated repository. Builds a
# deterministic diverged-branch topology on top of the shared baseline:
#
#   base (fixture + Artifact install)
#   ├─ feature/export : adds services/export.conf at protocol=1
#   └─ main           : bumps repository protocol to 2
#
# Both branches verify green on their own and merge cleanly in Git —
# but the merged tree fails `make verify` because export.conf still
# declares protocol=1 while the repository protocol is 2.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

# --- feature/export: add the new service config on the shared baseline ---
git -C "$TARGET" checkout -qb feature/export
printf 'protocol=1\n' > "$TARGET/services/export.conf"
git -C "$TARGET" add services/export.conf
git -C "$TARGET" commit -qm "feat: add export service config"

# --- main: independently bump the repository protocol --------------------
git -C "$TARGET" checkout -q main
printf '2\n' > "$TARGET/config/protocol-version.txt"
printf 'protocol=2\n' > "$TARGET/services/core.conf"
git -C "$TARGET" add config/protocol-version.txt services/core.conf
git -C "$TARGET" commit -qm "chore: bump repository protocol to 2"
