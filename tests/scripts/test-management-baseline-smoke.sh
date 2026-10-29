#!/usr/bin/env bash
# Deterministic Git-state smoke for Issue #216; this is NOT a blind AI-agent run.
set -euo pipefail
REPO_ROOT="$(cd -- "$(dirname -- "$0")/../.." && pwd -P)"
fixture="$REPO_ROOT/tests/repositories/management-baseline-coordination"
hook="$REPO_ROOT/tests/scenarios/management-baseline-coordination/prepare.sh"
[[ -d "$fixture" && -f "$hook" ]] || { echo 'missing scenario fixture/hook' >&2; exit 1; }
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
repo="$tmp/repo"
mkdir -p "$repo"
cp -a -- "$fixture/." "$repo/"
git -C "$repo" init -q -b main
git -C "$repo" config user.name 'documents-artifacts test'
git -C "$repo" config user.email 'documents-artifacts-test@example.invalid'
git -C "$repo" add -A
git -C "$repo" commit -qm 'test: fixture baseline'
TARGET="$repo" bash "$hook"
git -C "$repo" tag artifact-test-baseline
git -C "$repo/game" tag artifact-test-baseline
if (cd "$repo" && make verify >/dev/null 2>&1); then
  echo 'FAIL: baseline unexpectedly passes' >&2; exit 1
fi
workdoc="$repo/.worktrees/feat/combat-revision/documents/PLAN.md"
sed -i 's/Coordination checkpoint: pending/Coordination checkpoint: recorded/' "$workdoc"
git -C "$repo" add .worktrees/feat/combat-revision/documents/PLAN.md
git -C "$repo" commit -qm 'docs(work): record active coordination checkpoint'
(cd "$repo" && make verify)
# Ref-scoped Git tracking and checkout status can both be true.
ref_repo="$tmp/ref-state"
mkdir -p "$ref_repo"
git -C "$ref_repo" init -q -b main
git -C "$ref_repo" -c user.name=test -c user.email=test@example.invalid commit -qm base --allow-empty
git -C "$ref_repo" switch -qc feat/work
tracked_rel='.worktrees/feat/work/documents/RECORD.md'
mkdir -p "$ref_repo/$(dirname "$tracked_rel")"
printf 'tracked on feature\n' > "$ref_repo/$tracked_rel"
git -C "$ref_repo" add -A
git -C "$ref_repo" -c user.name=test -c user.email=test@example.invalid commit -qm 'work record'
git -C "$ref_repo" switch -q main
mkdir -p "$ref_repo/$(dirname "$tracked_rel")"
printf 'untracked on main\n' > "$ref_repo/$tracked_rel"
[[ -z "$(git -C "$ref_repo" ls-tree -r main -- "$tracked_rel")" ]] || { echo 'FAIL: main unexpectedly tracks the record' >&2; exit 1; }
[[ -n "$(git -C "$ref_repo" ls-tree -r feat/work -- "$tracked_rel")" ]] || { echo 'FAIL: branch missing the record' >&2; exit 1; }
[[ "$(git -C "$ref_repo" status --porcelain --untracked-files=all)" == "?? $tracked_rel" ]] || { echo 'FAIL: main checkout untracked state mismatch' >&2; exit 1; }
printf 'PASS: ref-specific tracking and checkout status coexist\n'
