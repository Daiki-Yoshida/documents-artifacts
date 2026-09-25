#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/.." && pwd -P)"
PREPARE="$REPO_ROOT/tests/scripts/prepare-agent-test.sh"
RESET="$REPO_ROOT/tests/scripts/reset-agent-test.sh"
INSPECT="$REPO_ROOT/tests/scripts/inspect-agent-test.sh"
CAPTURE="$REPO_ROOT/tests/scripts/capture-agent-test.sh"
TEST_RUNS_ROOT="$(mktemp -d)"
TEST_RESULTS_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TEST_RUNS_ROOT" "$TEST_RESULTS_ROOT"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

for script in "$PREPARE" "$RESET" "$INSPECT" "$CAPTURE"; do
  [[ -x "$script" ]] || fail "script is not executable: $script"
  bash -n "$script" || fail "syntax error: $script"
done

scenario_dirs=("$REPO_ROOT"/tests/scenarios/*/)
(("${#scenario_dirs[@]}" > 0)) || fail "no scenarios found"

source_artifact_count="$(find "$REPO_ROOT/artifacts" -type f | wc -l | tr -d ' ')"
((source_artifact_count > 1)) || fail "artifact source pack is unexpectedly empty"

for scenario_dir in "${scenario_dirs[@]}"; do
  scenario="${scenario_dir%/}"
  scenario="${scenario##*/}"
  [[ "$scenario" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid scenario directory: $scenario"

  conf="${scenario_dir}scenario.conf"
  prompt="${scenario_dir}PROMPT.md"
  expectations="${scenario_dir}EXPECTATIONS.md"
  [[ -f "$conf" ]] || fail "missing scenario.conf: $scenario"
  [[ -f "$prompt" ]] || fail "missing PROMPT.md: $scenario"
  [[ -f "$expectations" ]] || fail "missing EXPECTATIONS.md: $scenario"

  unset FIXTURE
  # shellcheck disable=SC1090
  source "$conf"
  [[ -n "${FIXTURE:-}" ]] || fail "FIXTURE missing: $scenario"
  fixture="$REPO_ROOT/tests/repositories/$FIXTURE"
  [[ -d "$fixture" ]] || fail "fixture missing for $scenario: $FIXTURE"

  if find "$fixture" -name .git -print -quit | grep -q .; then
    fail "fixture contains .git: $FIXTURE"
  fi
  if find "$fixture" -type l -print -quit | grep -q .; then
    fail "fixture contains symlink: $FIXTURE"
  fi

  ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$PREPARE" --scenario "$scenario" --force >/dev/null
  run_root="$TEST_RUNS_ROOT/$scenario"
  target="$run_root/repo"

  [[ -d "$target/.git" ]] || fail "prepared repo missing .git: $scenario"
  [[ -f "$run_root/PROMPT.md" ]] || fail "run prompt missing: $scenario"
  [[ -f "$run_root/RUN_METADATA.txt" ]] || fail "run metadata missing: $scenario"
  cmp -s "$prompt" "$run_root/PROMPT.md" || fail "run prompt differs from scenario prompt: $scenario"
  grep -Fqx "scenario: $scenario" "$run_root/RUN_METADATA.txt" || fail "run metadata scenario mismatch: $scenario"
  grep -Fqx "source_repo_head: $(git -C "$REPO_ROOT" rev-parse HEAD)" "$run_root/RUN_METADATA.txt" \
    || fail "run metadata missing prepare-time source SHA: $scenario"
  [[ ! -e "$target/EXPECTATIONS.md" ]] || fail "expectations leaked into target repo: $scenario"
  if find "$target" -name EXPECTATIONS.md -print -quit | grep -q .; then
    fail "expectations leaked somewhere into target repo: $scenario"
  fi

  [[ -f "$target/documents/artifacts/INDEX.md" ]] || fail "Artifact v2 not installed: $scenario"
  installed_count="$(find "$target/documents/artifacts" -type f | wc -l | tr -d ' ')"
  [[ "$installed_count" == "$source_artifact_count" ]]     || fail "artifact count mismatch for $scenario: $installed_count"
  cmp -s "$REPO_ROOT/artifacts/INDEX.md" "$target/documents/artifacts/INDEX.md"     || fail "installed artifact root differs: $scenario"

  [[ -z "$(git -C "$target" status --porcelain)" ]] || fail "prepared repo is dirty: $scenario"
  [[ "$(git -C "$target" rev-list --count HEAD)" == "2" ]]     || fail "prepared repo should contain fixture + artifact commits: $scenario"
  git -C "$target" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
    || fail "prepared baseline tag missing: $scenario"

  ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$INSPECT" --scenario "$scenario" >/dev/null
  ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$RESET" --scenario "$scenario" >/dev/null
  [[ ! -e "$run_root" ]] || fail "reset did not remove run: $scenario"
done


# --- evidence capture contract (focused single-scenario check) ---

cap_scenario="$(basename -- "${scenario_dirs[0]%/}")"

# capture must reject malformed input and un-started runs
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" >/dev/null 2>&1; then
  fail "capture accepted missing arguments"
fi
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" >/dev/null 2>&1; then
  fail "capture accepted missing --run-id"
fi
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id '../escape' >/dev/null 2>&1; then
  fail "capture accepted traversal run id"
fi
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario '../escape' --run-id run-1 >/dev/null 2>&1; then
  fail "capture accepted traversal scenario"
fi
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id run-1 >/dev/null 2>&1; then
  fail "capture succeeded without a prepared run"
fi

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$PREPARE" --scenario "$cap_scenario" --force >/dev/null
cap_target="$TEST_RUNS_ROOT/$cap_scenario/repo"

# deliberate test mutations: modify a tracked file, add an untracked file,
# and add gitignored runtime state
tracked_file="$(git -C "$cap_target" ls-files | grep -v '^documents/artifacts/' | head -1)"
[[ -n "$tracked_file" ]] || fail "no tracked fixture file to mutate: $cap_scenario"
printf 'harness mutation\n' >> "$cap_target/$tracked_file"
printf 'untracked evidence probe\n' > "$cap_target/zz-untracked-probe.txt"
printf '.test-runtime/\n' > "$cap_target/.gitignore"
mkdir -p "$cap_target/.test-runtime"
printf 'x' > "$cap_target/.test-runtime/state.bin"

# stabilize the real index (status may refresh stat cache once), then record
# pre-capture index + status so capture side effects are observable
git -C "$cap_target" status --porcelain >/dev/null
index_before="$(sha1sum "$cap_target/.git/index" | cut -d' ' -f1)"
status_before="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" status --porcelain)"

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id run-1 >/dev/null

evidence="$TEST_RESULTS_ROOT/$cap_scenario/run-1/evidence"
for f in metadata.txt status.txt changed-files.txt diff-stat.txt changes.patch \
         managed-artifacts.patch filesystem.txt inspection.txt; do
  [[ -f "$evidence/$f" ]] || fail "evidence file missing: $f"
done

grep -Fqx "scenario: $cap_scenario" "$evidence/metadata.txt" || fail "metadata missing scenario"
grep -q '^baseline_sha: ' "$evidence/metadata.txt" || fail "metadata missing baseline sha"
grep -Fqx "source_repo_head_at_prepare: $(git -C "$REPO_ROOT" rev-parse HEAD)" "$evidence/metadata.txt" \
  || fail "metadata missing prepare-time source repo head"
capture_source_sha="$(sed -n 's/^source_repo_head_at_capture: //p' "$evidence/metadata.txt")"
[[ "$capture_source_sha" =~ ^[0-9a-f]{40}$ ]] || fail "metadata missing capture-time source repo head"
grep -q '^prepared_at_utc: ' "$evidence/metadata.txt" || fail "metadata missing prepare timestamp"
grep -q '^fixture: ' "$evidence/metadata.txt" || fail "metadata missing fixture"

grep -Fqx " M $tracked_file" "$evidence/status.txt" || fail "status.txt missing tracked modification"
grep -Fqx "?? zz-untracked-probe.txt" "$evidence/status.txt" || fail "status.txt missing untracked file"

grep -q "zz-untracked-probe.txt" "$evidence/changed-files.txt" || fail "changed-files.txt lost untracked file"
grep -q "zz-untracked-probe.txt" "$evidence/changes.patch" || fail "changes.patch lost untracked file name"
grep -q "untracked evidence probe" "$evidence/changes.patch" || fail "changes.patch lost untracked file content"
grep -q "$tracked_file" "$evidence/changed-files.txt" || fail "changed-files.txt missing tracked change"

[[ ! -s "$evidence/managed-artifacts.patch" ]] \
  || fail "managed-artifacts.patch should be empty for untouched artifacts"

grep -q '\.test-runtime/state\.bin' "$evidence/filesystem.txt" \
  || fail "filesystem.txt missing ignored runtime path evidence"
grep -q '\.test-runtime/' "$evidence/inspection.txt" \
  || fail "inspection.txt missing ignored path listing"
if grep -q 'state\.bin' "$evidence/changes.patch"; then
  fail "changes.patch included gitignored runtime file"
fi

# capture must not mutate the generated repo's real index/status
index_after="$(sha1sum "$cap_target/.git/index" | cut -d' ' -f1)"
status_after="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" status --porcelain)"
[[ "$index_before" == "$index_after" ]] \
  || fail "capture mutated the generated repo's real index"
[[ "$status_before" == "$status_after" ]] \
  || fail "capture mutated the generated repo's real status"

# duplicate run id must refuse to overwrite captured evidence
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id run-1 >/dev/null 2>&1; then
  fail "capture overwrote an existing run id"
fi

# reset removes the temporary run but never persisted result evidence
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$RESET" --scenario "$cap_scenario" >/dev/null
[[ ! -e "$TEST_RUNS_ROOT/$cap_scenario" ]] || fail "reset did not remove prepared run"
[[ -f "$evidence/changes.patch" ]] || fail "reset removed persisted evidence"

# secret-like non-ignored untracked content must fail closed before evidence is persisted
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$PREPARE" --scenario "$cap_scenario" --force >/dev/null
secret_target="$TEST_RUNS_ROOT/$cap_scenario/repo"
printf 'api_key=0123456789abcdef0123456789abcdef\n' > "$secret_target/zz-untracked-secret.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id secret-probe >/dev/null 2>&1; then
  fail "capture persisted secret-like untracked content"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/secret-probe/evidence" ]] \
  || fail "failed secret capture left persisted evidence"
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$RESET" --scenario "$cap_scenario" >/dev/null

printf 'PASS: execution-agent harness fixtures and scenarios\n'
