#!/usr/bin/env bash
# Prepare hook for vcs-authority-and-reporting.
# Runs after the Artifact install commit with $TARGET pointing at the
# generated repository. Creates a local bare "origin" and pushes the
# generated main once, so the run starts with realistic remote topology:
#   local main == origin/main, remote heads = main only,
#   current branch = main, working tree clean.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

ORIGIN="$(cd "$TARGET" && pwd -P)/../origin.git"
git init --bare -q "$ORIGIN"
git -C "$TARGET" remote add origin "$ORIGIN"
git -C "$TARGET" push -q origin main
