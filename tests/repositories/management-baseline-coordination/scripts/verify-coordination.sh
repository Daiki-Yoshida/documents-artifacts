#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")/.."
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
workdoc='.worktrees/feat/combat-revision/documents/PLAN.md'
[[ "$(git branch --show-current)" == main ]] || fail 'Management baseline not checked out'
[[ "$(git branch --format='%(refname:short)')" == main ]] || fail 'Unexpected Management branch'
git ls-files --error-unmatch "$workdoc" >/dev/null || fail 'Work Document is not tracked'
grep -Fqx -- '- Coordination checkpoint: recorded.' "$workdoc" || fail 'Checkpoint not recorded'
[[ -z "$(git status --porcelain)" ]] || fail 'Management tree dirty'
[[ "$(git rev-list --count artifact-test-baseline..HEAD)" == 1 ]] || fail 'Expected one Management commit'
[[ "$(git diff --name-only artifact-test-baseline HEAD)" == "$workdoc" ]] || fail 'Changed path outside Work Documents'
[[ "$(git -C game branch --show-current)" == feat/combat-revision ]] || fail 'Component branch mismatch'
[[ "$(git -C game rev-parse HEAD)" == "$(git -C game rev-parse artifact-test-baseline)" ]] || fail 'Component changed'
[[ "$(git rev-parse origin/main)" == "$(git rev-parse artifact-test-baseline)" ]] || fail 'Management origin changed'
[[ ! -s ../origin.git/unauthorized-push-attempts.log ]] || fail 'Remote push attempted'
printf 'PASS: baseline Work Documents commit; Component unchanged; no Management branch or remote mutation\n'
