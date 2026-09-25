#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/../.." && pwd -P)"
SCENARIOS_ROOT="$REPO_ROOT/tests/scenarios"
FIXTURES_ROOT="$REPO_ROOT/tests/repositories"
RUNS_ROOT="${ARTIFACT_TEST_RUNS_ROOT:-${TMPDIR:-/tmp}/documents-artifacts-agent-tests-${UID:-user}}"
[[ "$RUNS_ROOT" == /* ]] || { printf 'Error: ARTIFACT_TEST_RUNS_ROOT must be absolute: %s\\n' "$RUNS_ROOT" >&2; exit 1; }
[[ "$RUNS_ROOT" != "/" ]] || { printf 'Error: refusing filesystem root as test run root\\n' >&2; exit 1; }
case "$RUNS_ROOT" in
  "$REPO_ROOT"|"$REPO_ROOT/"*) printf 'Error: test run root must be outside source repository: %s\\n' "$RUNS_ROOT" >&2; exit 1 ;;
esac

SCENARIO=""
FORCE=0

usage() {
  cat <<'USAGE'
Usage:
  bash tests/scripts/prepare-agent-test.sh --scenario NAME [--force]
USAGE
}
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

while (($# > 0)); do
  case "$1" in
    --scenario) (($# >= 2)) || fail "--scenario requires a name"; SCENARIO="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown argument: $1" ;;
  esac
done

[[ -n "$SCENARIO" ]] || fail "--scenario is required"
[[ "$SCENARIO" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid scenario name: $SCENARIO"

SCENARIO_DIR="$SCENARIOS_ROOT/$SCENARIO"
CONF="$SCENARIO_DIR/scenario.conf"
PROMPT="$SCENARIO_DIR/PROMPT.md"
EXPECTATIONS="$SCENARIO_DIR/EXPECTATIONS.md"
[[ -f "$CONF" ]] || fail "scenario config missing: $CONF"
[[ -f "$PROMPT" ]] || fail "scenario prompt missing: $PROMPT"
[[ -f "$EXPECTATIONS" ]] || fail "scenario expectations missing: $EXPECTATIONS"

# shellcheck disable=SC1090
source "$CONF"
[[ -n "${FIXTURE:-}" ]] || fail "scenario.conf must define FIXTURE"
[[ "$FIXTURE" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid fixture name: $FIXTURE"
FIXTURE_DIR="$FIXTURES_ROOT/$FIXTURE"
[[ -d "$FIXTURE_DIR" ]] || fail "fixture not found: $FIXTURE_DIR"
if find "$FIXTURE_DIR" -name .git -print -quit | grep -q .; then fail "fixture must not contain nested .git state"; fi
if find "$FIXTURE_DIR" -type l -print -quit | grep -q .; then fail "fixture must not contain symlinks"; fi

RUN_ROOT="$RUNS_ROOT/$SCENARIO"
[[ "$RUN_ROOT" == "$RUNS_ROOT/"* ]] || fail "refusing unsafe run path"
if [[ -e "$RUN_ROOT" ]]; then
  ((FORCE == 1)) || fail "run root already exists: $RUN_ROOT (use --force)"
  rm -rf -- "$RUN_ROOT"
fi

mkdir -p -- "$RUN_ROOT/repo"
cp -a -- "$FIXTURE_DIR/." "$RUN_ROOT/repo/"
cp -- "$PROMPT" "$RUN_ROOT/PROMPT.md"

TARGET="$RUN_ROOT/repo"
git -C "$TARGET" init -q -b main
git -C "$TARGET" config user.name "documents-artifacts test"
git -C "$TARGET" config user.email "documents-artifacts-test@example.invalid"
git -C "$TARGET" add -A
git -C "$TARGET" commit -qm "test: fixture baseline"

"$REPO_ROOT/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null
git -C "$TARGET" add documents/artifacts
git -C "$TARGET" commit -qm "test: install Artifact v2"
git -C "$TARGET" tag artifact-test-baseline
[[ -z "$(git -C "$TARGET" status --porcelain)" ]] || fail "prepared repository is not clean"

SOURCE_REPO_HEAD="$(git -C "$REPO_ROOT" rev-parse HEAD)"
BASELINE_SHA="$(git -C "$TARGET" rev-parse artifact-test-baseline)"
{
  printf 'scenario: %s\n' "$SCENARIO"
  printf 'fixture: %s\n' "$FIXTURE"
  printf 'source_repo_head: %s\n' "$SOURCE_REPO_HEAD"
  printf 'baseline_sha: %s\n' "$BASELINE_SHA"
  printf 'prepared_at_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > "$RUN_ROOT/RUN_METADATA.txt"

printf 'Prepared scenario: %s\nFixture: %s\nRepository: %s\nAgent prompt: %s\n' "$SCENARIO" "$FIXTURE" "$TARGET" "$RUN_ROOT/PROMPT.md"
printf 'Run metadata: %s\n' "$RUN_ROOT/RUN_METADATA.txt"
printf 'Evaluator expectations (do not give to agent): %s\n' "$EXPECTATIONS"
