#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/../.." && pwd -P)"
SCENARIO=""
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
while (($# > 0)); do
  case "$1" in
    --scenario) (($# >= 2)) || fail "--scenario requires a name"; SCENARIO="$2"; shift 2 ;;
    -h|--help) printf '%s\n' "Usage: bash tests/scripts/inspect-agent-test.sh --scenario NAME"; exit 0 ;;
    *) fail "unknown argument: $1" ;;
  esac
done
[[ -n "$SCENARIO" ]] || fail "--scenario is required"
[[ "$SCENARIO" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid scenario name"
RUN_ROOT="$REPO_ROOT/tests/.runs/$SCENARIO"
TARGET="$RUN_ROOT/repo"
[[ -d "$TARGET/.git" ]] || fail "prepared Git repository not found: $TARGET"
git -C "$TARGET" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
  || fail "artifact-test-baseline tag missing: $TARGET"

printf '=== scenario ===\n%s\n\n' "$SCENARIO"
printf '=== status ===\n'; git -C "$TARGET" status --short
printf '\n=== changed files vs prepared baseline ===\n'; git -C "$TARGET" diff --name-status artifact-test-baseline
printf '\n=== diff stat vs prepared baseline ===\n'; git -C "$TARGET" diff --stat artifact-test-baseline
printf '\n=== recent commits ===\n'; git -C "$TARGET" --no-pager log --oneline -5
printf '\n=== managed artifact modifications ===\n'
artifact_changes="$(git -C "$TARGET" diff --name-status artifact-test-baseline -- documents/artifacts || true)"
if [[ -n "$artifact_changes" ]]; then printf '%s\n' "$artifact_changes"; else printf 'none\n'; fi
printf '\nEvaluator expectations: %s\n' "$REPO_ROOT/tests/scenarios/$SCENARIO/EXPECTATIONS.md"
