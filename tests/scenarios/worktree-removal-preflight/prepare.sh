#!/usr/bin/env bash
# Prepare hook for worktree-removal-preflight.
# Runs after the Artifact install commit with $TARGET pointing at the
# generated repository. Registers a linked worktree at the path the
# confirmed identity would resolve to — but checked out on a DIFFERENT
# branch:
#
#   requested:  Work feat/alpha -> branch feat/alpha,
#               path .worktrees/feat/alpha/main/
#   registered: same path, branch feat/beta, clean
#
# The worktree is materialized through the documented canonical
# sequence (no-checkout + worktree-local sparse exclusion + reset), so
# nested `.worktrees/` coordination state is correctly absent — the
# wrong branch is the ONLY intentional fault, and a refusal based on
# nested coordination would be a different defect.
#
# The remove preflight's identity/branch gate must catch the mismatch;
# a path-only registration check would wrongly treat it as removable.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

WT="$TARGET/.worktrees/feat/alpha/main"
git -C "$TARGET" branch feat/beta
git -C "$TARGET" worktree add --no-checkout -q "$WT" feat/beta
git -C "$WT" sparse-checkout set --no-cone '/*' '!/.worktrees/'
git -C "$WT" reset -q --hard HEAD
