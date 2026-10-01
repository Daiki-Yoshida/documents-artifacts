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

unset FIXTURE PREPARE_HOOK EXPECTED_HEAD_COMMIT_COUNT EVIDENCE_REPOSITORIES || true
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

# Optional per-scenario prepare hook: a validated file inside the
# scenario directory (a plain filename — never an arbitrary shell string
# or a path outside the scenario). It runs after the Artifact install
# commit so hooks build on the common baseline, e.g. deterministic Git
# topologies such as a diverged feature branch.
if [[ -n "${PREPARE_HOOK:-}" ]]; then
  [[ "$PREPARE_HOOK" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]] \
    || fail "PREPARE_HOOK must be a plain file name inside the scenario directory: $PREPARE_HOOK"
  HOOK="$SCENARIO_DIR/$PREPARE_HOOK"
  [[ -f "$HOOK" && ! -L "$HOOK" ]] || fail "PREPARE_HOOK file not found in scenario directory: $HOOK"
  TARGET="$TARGET" SCENARIO_DIR="$SCENARIO_DIR" bash "$HOOK" \
    || fail "prepare hook failed: $PREPARE_HOOK"
fi

# Optional declared Component Repositories: EVIDENCE_REPOSITORIES carries
# space-separated "selector=run-root-relative-path" pairs. Each selector
# must resolve to an independent, clean Git repository inside the run
# root — no absolute paths, no traversal, no symlink escapes, no
# arbitrary discovery commands.
EVIDENCE_REPOS=()
if [[ -n "${EVIDENCE_REPOSITORIES:-}" ]]; then
  RUN_ROOT_REAL="$(cd "$RUN_ROOT" && pwd -P)"
  TARGET_REAL="$(cd "$TARGET" && pwd -P)"
  declare -A SEEN_SEL=() SEEN_REAL=()
  for pair in $EVIDENCE_REPOSITORIES; do
    [[ "$pair" == *=* ]] || fail "invalid EVIDENCE_REPOSITORIES entry: $pair (expected selector=relpath)"
    sel="${pair%%=*}"; rel="${pair#*=}"
    [[ "$sel" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid evidence repository selector: $sel"
    [[ -n "$rel" && "$rel" != /* && "$rel" != *..* ]] \
      || fail "evidence repository path must be non-empty, relative, traversal-free: $rel"
    [[ "$rel" =~ ^[a-zA-Z0-9_./-]+$ ]] \
      || fail "unsafe characters in evidence repository path: $rel"
    [[ ! -L "$RUN_ROOT/$rel" ]] || fail "evidence repository path is a symlink: $rel"
    [[ -d "$RUN_ROOT/$rel" ]] || fail "declared evidence repository does not exist: $rel"
    REAL="$(cd "$RUN_ROOT/$rel" && pwd -P)"
    [[ "$REAL" == "$RUN_ROOT_REAL/"* ]] \
      || fail "evidence repository resolves outside run root: $rel"
    [[ "$REAL" != "$TARGET_REAL" ]] \
      || fail "evidence repository must be independent of the primary repository: $rel"
    [[ -d "$REAL/.git" && ! -L "$REAL/.git" ]] || fail "not a safe independent Git repository: $rel"
    git -C "$REAL" rev-parse -q --verify HEAD >/dev/null \
      || fail "declared evidence repository has no commits: $sel"
    [[ -z "$(git -C "$REAL" status --porcelain)" ]] \
      || fail "declared evidence repository is dirty: $sel"
    [[ -z "${SEEN_SEL[$sel]:-}" ]] || fail "duplicate evidence repository selector: $sel"
    [[ -z "${SEEN_REAL[$REAL]:-}" ]] || fail "duplicate evidence repository path: $rel"
    SEEN_SEL[$sel]=1; SEEN_REAL[$REAL]=1
    EVIDENCE_REPOS+=("$sel|$rel|$REAL")
  done
fi

[[ -z "$(git -C "$TARGET" status --porcelain)" ]] || fail "prepared repository is not clean"

EXPECTED_HEAD_COMMIT_COUNT="${EXPECTED_HEAD_COMMIT_COUNT:-2}"
[[ "$EXPECTED_HEAD_COMMIT_COUNT" =~ ^[0-9]+$ ]] \
  || fail "invalid EXPECTED_HEAD_COMMIT_COUNT: $EXPECTED_HEAD_COMMIT_COUNT"
[[ "$(git -C "$TARGET" rev-list --count HEAD)" == "$EXPECTED_HEAD_COMMIT_COUNT" ]] \
  || fail "HEAD commit count mismatch: expected $EXPECTED_HEAD_COMMIT_COUNT"

git -C "$TARGET" tag artifact-test-baseline
if ((${#EVIDENCE_REPOS[@]})); then
  for entry in "${EVIDENCE_REPOS[@]}"; do
    sel="${entry%%|*}"; rest="${entry#*|}"; REAL="${rest#*|}"
    git -C "$REAL" tag artifact-test-baseline
  done
fi

SOURCE_REPO_HEAD="$(git -C "$REPO_ROOT" rev-parse HEAD)"
BASELINE_SHA="$(git -C "$TARGET" rev-parse artifact-test-baseline)"
{
  printf 'scenario: %s\n' "$SCENARIO"
  printf 'fixture: %s\n' "$FIXTURE"
  printf 'source_repo_head: %s\n' "$SOURCE_REPO_HEAD"
  printf 'baseline_sha: %s\n' "$BASELINE_SHA"
  printf 'prepared_at_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if ((${#EVIDENCE_REPOS[@]})); then
    for entry in "${EVIDENCE_REPOS[@]}"; do
      sel="${entry%%|*}"; rest="${entry#*|}"; rel="${rest%%|*}"; REAL="${rest#*|}"
      printf 'evidence_repository: %s=%s\n' "$sel" "$rel"
      printf 'evidence_repository_%s_baseline_sha: %s\n' "$sel" \
        "$(git -C "$REAL" rev-parse artifact-test-baseline)"
    done
  fi
} > "$RUN_ROOT/RUN_METADATA.txt"

# Operator-authored run provenance template. It lives at the run root,
# outside the generated repository, and is never agent task input. The run
# operator uncomments the keys it actually knows before capture;
# capture-agent-test.sh validates keys against a fixed allowlist and
# persists the file verbatim as tests/results/<scenario>/<run-id>/provenance.txt.
cat > "$RUN_ROOT/RUN_PROVENANCE.txt" <<'EOF'
# Run provenance — operator-authored context for this blind execution run.
# Not agent input: the execution agent is never shown this file.
#
# Uncomment only the lines the operator actually knows; never guess or
# reconstruct values afterwards. capture-agent-test.sh rejects unknown
# keys, duplicate keys, empty values, and a provided file without `model`.
# Source SHA, fixture, and baseline SHA are already recorded mechanically
# in RUN_METADATA.txt and evidence/metadata.txt — do not duplicate them here.
#
# model: luna-medium                  # exact agent model (required if any key is given)
# model_version: 2026-09-30           # model snapshot / version if known
# reasoning_effort: medium            # low / medium / high / provider-specific value
# agent_runtime: dot cloud shell      # runner identity, e.g. "devin cli 3000.11.3"
# run_started_at_utc: 2026-10-01T12:00:00Z
# run_finished_at_utc: 2026-10-01T12:25:00Z
# entry_condition: prompt-directed-index  # how the agent reached the artifact entry
# repetition: 1                       # this run's index within run_set
# run_set: luna-medium-baseline       # batch identifier grouping repeated runs
# read_evidence: self-reported        # self-reported | operator-log | tool-export | none
# known_limitations: read list is self-reported; no tool telemetry
EOF

printf 'Prepared scenario: %s\nFixture: %s\nRepository: %s\nAgent prompt: %s\n' "$SCENARIO" "$FIXTURE" "$TARGET" "$RUN_ROOT/PROMPT.md"
printf 'Run metadata: %s\n' "$RUN_ROOT/RUN_METADATA.txt"
printf 'Run provenance template (operator fills before capture): %s\n' "$RUN_ROOT/RUN_PROVENANCE.txt"
printf 'Evaluator expectations (do not give to agent): %s\n' "$EXPECTATIONS"
