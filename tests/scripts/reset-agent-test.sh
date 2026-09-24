#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/../.." && pwd -P)"
RUNS_ROOT="${ARTIFACT_TEST_RUNS_ROOT:-${TMPDIR:-/tmp}/documents-artifacts-agent-tests-${UID:-user}}"
[[ "$RUNS_ROOT" == /* ]] || { printf 'Error: ARTIFACT_TEST_RUNS_ROOT must be absolute: %s\\n' "$RUNS_ROOT" >&2; exit 1; }
[[ "$RUNS_ROOT" != "/" ]] || { printf 'Error: refusing filesystem root as test run root\\n' >&2; exit 1; }
case "$RUNS_ROOT" in
  "$REPO_ROOT"|"$REPO_ROOT/"*) printf 'Error: test run root must be outside source repository: %s\\n' "$RUNS_ROOT" >&2; exit 1 ;;
esac

SCENARIO=""
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
while (($# > 0)); do
  case "$1" in
    --scenario) (($# >= 2)) || fail "--scenario requires a name"; SCENARIO="$2"; shift 2 ;;
    -h|--help) printf '%s\n' "Usage: bash tests/scripts/reset-agent-test.sh --scenario NAME"; exit 0 ;;
    *) fail "unknown argument: $1" ;;
  esac
done
[[ -n "$SCENARIO" ]] || fail "--scenario is required"
[[ "$SCENARIO" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid scenario name"
RUN_ROOT="$RUNS_ROOT/$SCENARIO"
[[ "$RUN_ROOT" == "$RUNS_ROOT/"* ]] || fail "refusing unsafe run path"
if [[ -e "$RUN_ROOT" ]]; then rm -rf -- "$RUN_ROOT"; printf 'Removed run: %s\n' "$RUN_ROOT"; else printf 'Run already absent: %s\n' "$RUN_ROOT"; fi
