#!/usr/bin/env bash
set -euo pipefail

# Capture machine-generated run evidence from a prepared behavior-test run
# into tests/results/<scenario>/<run-id>/evidence/ before the temporary run
# disappears. The agent-authored REPORT.md lives next to evidence/ but is
# written by the execution agent, not by this script.

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/../.." && pwd -P)"
SCENARIOS_ROOT="$REPO_ROOT/tests/scenarios"
RUNS_ROOT="${ARTIFACT_TEST_RUNS_ROOT:-${TMPDIR:-/tmp}/documents-artifacts-agent-tests-${UID:-user}}"
RESULTS_ROOT="${ARTIFACT_TEST_RESULTS_ROOT:-$REPO_ROOT/tests/results}"

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

[[ "$RUNS_ROOT" == /* ]] || fail "ARTIFACT_TEST_RUNS_ROOT must be absolute: $RUNS_ROOT"
[[ "$RUNS_ROOT" != "/" ]] || fail "refusing filesystem root as test run root"
case "$RUNS_ROOT" in
  "$REPO_ROOT"|"$REPO_ROOT/"*) fail "test run root must be outside source repository: $RUNS_ROOT" ;;
esac
[[ "$RESULTS_ROOT" == /* ]] || fail "ARTIFACT_TEST_RESULTS_ROOT must be absolute: $RESULTS_ROOT"
[[ "$RESULTS_ROOT" != "/" ]] || fail "refusing filesystem root as results root"

usage() {
  cat <<'USAGE'
Usage:
  bash tests/scripts/capture-agent-test.sh --scenario NAME --run-id RUN_ID

Captures machine-generated evidence from the prepared run into
  tests/results/<scenario>/<run-id>/evidence/

RUN_ID: lowercase letters, digits, hyphens (e.g. 2026-09-25-devin).
ARTIFACT_TEST_RESULTS_ROOT overrides the default tests/results output root.
USAGE
}

SCENARIO=""
RUN_ID=""
while (($# > 0)); do
  case "$1" in
    --scenario) (($# >= 2)) || fail "--scenario requires a name"; SCENARIO="$2"; shift 2 ;;
    --run-id) (($# >= 2)) || fail "--run-id requires an id"; RUN_ID="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown argument: $1" ;;
  esac
done

[[ -n "$SCENARIO" ]] || fail "--scenario is required"
[[ -n "$RUN_ID" ]] || fail "--run-id is required"
[[ "$SCENARIO" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid scenario name: $SCENARIO"
[[ "$RUN_ID" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid run id: $RUN_ID (lowercase, digits, hyphens)"

CONF="$SCENARIOS_ROOT/$SCENARIO/scenario.conf"
[[ -f "$CONF" ]] || fail "scenario config missing: $CONF"
unset FIXTURE || true
# shellcheck disable=SC1090
source "$CONF"
[[ -n "${FIXTURE:-}" ]] || fail "scenario.conf must define FIXTURE"

RUN_ROOT="$RUNS_ROOT/$SCENARIO"
TARGET="$RUN_ROOT/repo"
[[ "$RUN_ROOT" == "$RUNS_ROOT/"* ]] || fail "refusing unsafe run path"
[[ -d "$TARGET/.git" ]] || fail "prepared run not found: $TARGET (run prepare-agent-test.sh first)"
git -C "$TARGET" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
  || fail "artifact-test-baseline tag missing: $TARGET"

OUT="$RESULTS_ROOT/$SCENARIO/$RUN_ID"
[[ "$OUT" == "$RESULTS_ROOT/"* ]] || fail "refusing unsafe output path"
EV="$OUT/evidence"
[[ ! -e "$EV" ]] || fail "evidence already captured for this run id: $EV"
mkdir -p -- "$EV"

TMP_INDEX="$(mktemp)"
trap 'rm -f -- "$TMP_INDEX"' EXIT

BASE_SHA="$(git -C "$TARGET" rev-parse artifact-test-baseline)"
HEAD_SHA="$(git -C "$TARGET" rev-parse HEAD)"
SRC_SHA="$(git -C "$REPO_ROOT" rev-parse HEAD)"

{
  printf 'scenario: %s\n' "$SCENARIO"
  printf 'run_id: %s\n' "$RUN_ID"
  printf 'fixture: %s\n' "$FIXTURE"
  printf 'captured_at_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'source_repo_head: %s\n' "$SRC_SHA"
  printf 'generated_repo: %s\n' "$TARGET"
  printf 'baseline_tag: artifact-test-baseline\n'
  printf 'baseline_sha: %s\n' "$BASE_SHA"
  printf 'head_sha_at_capture: %s\n' "$HEAD_SHA"
} > "$EV/metadata.txt"

{
  printf '=== git status --short ===\n'
  env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" status --short
  printf '\n=== ignored paths present (names only) ===\n'
  ignored="$(env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" status --porcelain --ignored | grep '^!!' || true)"
  if [[ -n "$ignored" ]]; then printf '%s\n' "$ignored"; else printf 'none\n'; fi
} > "$EV/status.txt"

# Temp-index diff: seed an alternate index with the baseline tree, overlay the
# worktree, then diff. This represents untracked new files in the patch without
# touching the generated repository's real index/worktree. Ignored files stay
# out of the patch; their existence is recorded in status.txt/filesystem.txt.
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" read-tree artifact-test-baseline
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" add -A
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" --no-pager diff --cached --binary artifact-test-baseline \
  > "$EV/changes.patch"
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" --no-pager diff --cached --name-status artifact-test-baseline \
  > "$EV/changed-files.txt"
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" --no-pager diff --cached --stat artifact-test-baseline \
  > "$EV/diff-stat.txt"
env GIT_INDEX_FILE="$TMP_INDEX" git -C "$TARGET" --no-pager diff --cached --binary artifact-test-baseline \
  -- documents/artifacts > "$EV/managed-artifacts.patch"

# Existence/type evidence for every path including ignored runtime state.
# Names and sizes only — never arbitrary file contents.
(cd "$TARGET" && find . -path ./.git -prune -o -printf '%y %10s %p\n' | sort) > "$EV/filesystem.txt"

{
  printf '=== recent commits ===\n'
  git -C "$TARGET" --no-pager log --oneline -10
  printf '\n=== tags ===\n'
  git -C "$TARGET" tag -l
  printf '\n=== ignored/untracked paths (gitignore-excluded, names only) ===\n'
  ignored_files="$(env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" ls-files --others --ignored --exclude-standard)"
  if [[ -n "$ignored_files" ]]; then printf '%s\n' "$ignored_files"; else printf 'none\n'; fi
} > "$EV/inspection.txt"

printf 'Captured evidence: %s\n' "$EV"
printf 'Agent-authored report goes to: %s\n' "$OUT/REPORT.md"
