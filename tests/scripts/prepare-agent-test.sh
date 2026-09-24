#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/../.." && pwd -P)"
SCENARIOS_ROOT="$REPO_ROOT/tests/scenarios"
FIXTURES_ROOT="$REPO_ROOT/tests/repositories"
RUNS_ROOT="$REPO_ROOT/tests/.runs"
SCENARIO=""
OUTPUT=""
FORCE=0

usage() {
  cat <<'USAGE'
Usage:
  bash tests/scripts/prepare-agent-test.sh --scenario NAME [--output PATH] [--force]
USAGE
}
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

while (($# > 0)); do
  case "$1" in
    --scenario) (($# >= 2)) || fail "--scenario requires a name"; SCENARIO="$2"; shift 2 ;;
    --output) (($# >= 2)) || fail "--output requires a path"; OUTPUT="$2"; shift 2 ;;
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

if [[ -z "$OUTPUT" ]]; then OUTPUT="$RUNS_ROOT/$SCENARIO"; elif [[ "$OUTPUT" != /* ]]; then OUTPUT="$REPO_ROOT/$OUTPUT"; fi
if [[ -e "$OUTPUT" ]]; then
  ((FORCE == 1)) || fail "run root already exists: $OUTPUT (use --force)"
  rm -rf -- "$OUTPUT"
fi

mkdir -p -- "$OUTPUT/repo"
cp -a -- "$FIXTURE_DIR/." "$OUTPUT/repo/"
cp -- "$PROMPT" "$OUTPUT/PROMPT.md"

TARGET="$OUTPUT/repo"
git -C "$TARGET" init -q -b main
git -C "$TARGET" config user.name "documents-artifacts test"
git -C "$TARGET" config user.email "documents-artifacts-test@example.invalid"
git -C "$TARGET" add -A
git -C "$TARGET" commit -qm "test: fixture baseline"

"$REPO_ROOT/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null
git -C "$TARGET" add documents/artifacts
git -C "$TARGET" commit -qm "test: install Artifact v2"
[[ -z "$(git -C "$TARGET" status --porcelain)" ]] || fail "prepared repository is not clean"

printf 'Prepared scenario: %s\nFixture: %s\nRepository: %s\nAgent prompt: %s\n' "$SCENARIO" "$FIXTURE" "$TARGET" "$OUTPUT/PROMPT.md"
printf 'Evaluator expectations (do not give to agent): %s\n' "$EXPECTATIONS"
