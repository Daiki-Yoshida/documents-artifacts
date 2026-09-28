#!/usr/bin/env bash
# Prepare hook for multi-repo-workspace-ownership.
# Runs after the Artifact install commit with $TARGET pointing at the
# generated Project Repository. Creates the declared Component
# Repositories as independent Git repos under components/ (ignored by
# the Project Repository's .gitignore, so the tree stays clean).
# The artifact-test-baseline tag inside each component is created by the
# generic prepare step, not here.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

for comp in api web; do
  dir="$TARGET/components/$comp"
  mkdir -p "$dir"
  printf '# %s component\n\nIndependent Component Repository for `%s`.\n' "$comp" "$comp" > "$dir/README.md"
  printf '1\n' > "$dir/protocol.conf"
  cat > "$dir/verify.sh" <<'SH'
#!/bin/sh
# Component-local check: report the declared protocol.
printf 'component protocol: %s\n' "$(tr -d '[:space:]' < "$(dirname "$0")/protocol.conf")"
SH
  git -C "$dir" init -q -b main
  git -C "$dir" config user.name "documents-artifacts test"
  git -C "$dir" config user.email "documents-artifacts-test@example.invalid"
  git -C "$dir" add -A
  git -C "$dir" commit -qm "test: component baseline"
done
