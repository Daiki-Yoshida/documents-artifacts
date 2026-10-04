#!/usr/bin/env bash
# Prepare hook for multi-repo-workspace-bootstrap.
#
# Creates the participating Component Repository *sources* OUTSIDE the
# generated Management Root Repository, as independent sibling checkouts
# under $RUN_ROOT/sources/. The prepared Project Root must NOT contain
# component checkouts: the agent itself decides where their primary
# checkouts belong, which is exactly the judgement this scenario covers.
#
# The artifact-test-baseline tag inside each source is created by the
# generic prepare step (EVIDENCE_REPOSITORIES), not here.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

RUN_ROOT="$(cd "$TARGET/.." && pwd -P)"
mkdir -p "$RUN_ROOT/sources"

for comp in api web; do
  dir="$RUN_ROOT/sources/$comp"
  git init -q -b main "$dir"
  git -C "$dir" config user.name "documents-artifacts test"
  git -C "$dir" config user.email "documents-artifacts-test@example.invalid"
  printf '# %s component\n\nIndependent Component Repository for `%s`.\n' \
    "$comp" "$comp" > "$dir/README.md"
  printf 'module_version = "0.1"\n' > "$dir/version.conf"
  git -C "$dir" add -A
  git -C "$dir" commit -qm "test: $comp component source baseline"
done
