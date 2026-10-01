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
# The remove preflight's identity/branch gate must catch the mismatch;
# a path-only registration check would wrongly treat it as removable.
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

git -C "$TARGET" branch feat/beta
git -C "$TARGET" worktree add -q "$TARGET/.worktrees/feat/alpha/main" feat/beta
