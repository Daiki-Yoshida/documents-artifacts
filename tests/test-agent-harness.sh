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
printf '.test-runtime/\nharness-wt/\n' > "$cap_target/.gitignore"
mkdir -p "$cap_target/.test-runtime"
printf 'x' > "$cap_target/.test-runtime/state.bin"

# worktree evidence probes: an in-run linked worktree with sparse checkout
# enabled, plus a registered worktree outside the run boundary that must be
# recorded as registered but never recursively inspected
link_wt="$cap_target/harness-wt/linked"
git -C "$cap_target" worktree add --no-checkout -b harness-wt-branch \
  "$link_wt" artifact-test-baseline >/dev/null
git -C "$link_wt" sparse-checkout set --no-cone '/*' '!/documents/' >/dev/null
git -C "$link_wt" reset --hard HEAD >/dev/null
ext_wt="$TEST_RUNS_ROOT/outside-worktree"
git -C "$cap_target" worktree add --no-checkout -b harness-ext-branch \
  "$ext_wt" artifact-test-baseline >/dev/null
printf 'outside marker\n' > "$ext_wt/zz-external-marker.txt"
cap_target_real="$(cd "$cap_target" && pwd -P)"
link_wt_real="$(cd "$link_wt" && pwd -P)"

# stabilize the real indexes (status may refresh stat caches once), then
# record pre-capture state so capture side effects are observable
git -C "$cap_target" status --porcelain >/dev/null
git -C "$link_wt" status --porcelain >/dev/null
index_before="$(sha1sum "$cap_target/.git/index" | cut -d' ' -f1)"
status_before="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" status --porcelain)"
link_index="$(git -C "$link_wt" rev-parse --git-dir)/index"
link_index_before="$(sha1sum "$link_index" | cut -d' ' -f1)"
link_status_before="$(env GIT_OPTIONAL_LOCKS=0 git -C "$link_wt" status --porcelain)"
link_sparse_before="$(git -C "$link_wt" sparse-checkout list)"
link_sparse_cfg_before="$(git -C "$link_wt" config --get core.sparseCheckout)"
wt_list_before="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" worktree list --porcelain)"

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id run-1 >/dev/null

evidence="$TEST_RESULTS_ROOT/$cap_scenario/run-1/evidence"
for f in metadata.txt status.txt changed-files.txt diff-stat.txt changes.patch \
         managed-artifacts.patch filesystem.txt inspection.txt worktrees.txt; do
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

# worktree evidence: registration + safe in-boundary inspection
wt_block() {
  awk -v t="worktree: $1" '
    $0==t {on=1; print; next}
    on && /^worktree: / {exit}
    on {print}
  ' "$evidence/worktrees.txt"
}
grep -q '^=== git worktree list --porcelain' "$evidence/worktrees.txt" \
  || fail "worktrees.txt missing raw registration"
grep -Fxq "worktree $cap_target" "$evidence/worktrees.txt" \
  || fail "worktrees.txt missing primary registration"
grep -Fxq "worktree $link_wt" "$evidence/worktrees.txt" \
  || fail "worktrees.txt missing linked worktree registration"
grep -Fxq "worktree $ext_wt" "$evidence/worktrees.txt" \
  || fail "worktrees.txt missing external worktree registration"

primary_block="$(wt_block "$cap_target")"
link_block="$(wt_block "$link_wt")"
ext_block="$(wt_block "$ext_wt")"
[[ -n "$primary_block" && -n "$link_block" && -n "$ext_block" ]] \
  || fail "worktrees.txt missing per-worktree inspection blocks"

grep -Fx '  boundary_scope: primary-generated-repo' <<<"$primary_block" >/dev/null \
  || fail "primary worktree not scoped as primary-generated-repo"
grep -Fx "  resolved_path: $cap_target_real" <<<"$primary_block" >/dev/null \
  || fail "primary worktree resolved path missing"
grep -Fx '  inspected: yes' <<<"$primary_block" >/dev/null \
  || fail "primary worktree not inspected"
grep -Fx "  head: $(git -C "$cap_target" rev-parse HEAD)" <<<"$primary_block" >/dev/null \
  || fail "primary worktree HEAD missing"
grep -Fx "  branch: $(git -C "$cap_target" branch --show-current)" <<<"$primary_block" >/dev/null \
  || fail "primary worktree branch missing"
grep -Fx '  status: dirty' <<<"$primary_block" >/dev/null \
  || fail "primary worktree dirty state not captured"
grep -Fx '  sparse_checkout: disabled' <<<"$primary_block" >/dev/null \
  || fail "primary worktree sparse state missing"

grep -Fx "  resolved_path: $link_wt_real" <<<"$link_block" >/dev/null \
  || fail "linked worktree resolved path missing"
grep -Fx '  boundary_scope: linked-under-run' <<<"$link_block" >/dev/null \
  || fail "linked worktree not scoped as linked-under-run"
grep -Fx '  inspected: yes' <<<"$link_block" >/dev/null \
  || fail "linked worktree not inspected"
grep -Fx "  head: $(git -C "$link_wt" rev-parse HEAD)" <<<"$link_block" >/dev/null \
  || fail "linked worktree HEAD missing"
grep -Fx '  registration_ref: refs/heads/harness-wt-branch' <<<"$link_block" >/dev/null \
  || fail "linked worktree registration ref missing"
grep -Fx '  branch: harness-wt-branch' <<<"$link_block" >/dev/null \
  || fail "linked worktree branch missing"
grep -Fx '  status: clean' <<<"$link_block" >/dev/null \
  || fail "linked worktree clean state missing"
grep -Fx '  sparse_checkout: enabled' <<<"$link_block" >/dev/null \
  || fail "linked worktree sparse enablement missing"
grep -Fx '    /*' <<<"$link_block" >/dev/null \
  || fail "linked worktree sparse pattern /* missing"
grep -Fx '    !/documents/' <<<"$link_block" >/dev/null \
  || fail "linked worktree sparse pattern !/documents/ missing"

# out-of-boundary worktree: recorded but never recursively inspected
grep -Fx '  inspected: no' <<<"$ext_block" >/dev/null \
  || fail "external worktree was inspected"
grep -Fx '  skip_reason: resolved path outside safe inspection boundary' <<<"$ext_block" >/dev/null \
  || fail "external worktree skip reason missing"
if grep -q 'zz-external-marker' "$evidence/worktrees.txt"; then
  fail "external worktree contents leaked into worktree evidence"
fi

# capture must not mutate the generated repo's real index/status
index_after="$(sha1sum "$cap_target/.git/index" | cut -d' ' -f1)"
status_after="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" status --porcelain)"
[[ "$index_before" == "$index_after" ]] \
  || fail "capture mutated the generated repo's real index"
[[ "$status_before" == "$status_after" ]] \
  || fail "capture mutated the generated repo's real status"

# capture must not mutate linked worktree index/status, sparse state,
# or the worktree registration list
link_index_after="$(sha1sum "$link_index" | cut -d' ' -f1)"
link_status_after="$(env GIT_OPTIONAL_LOCKS=0 git -C "$link_wt" status --porcelain)"
link_sparse_after="$(git -C "$link_wt" sparse-checkout list)"
link_sparse_cfg_after="$(git -C "$link_wt" config --get core.sparseCheckout)"
wt_list_after="$(env GIT_OPTIONAL_LOCKS=0 git -C "$cap_target" worktree list --porcelain)"
[[ "$link_index_before" == "$link_index_after" ]] \
  || fail "capture mutated the linked worktree's index"
[[ "$link_status_before" == "$link_status_after" ]] \
  || fail "capture mutated the linked worktree's status"
[[ "$link_sparse_before" == "$link_sparse_after" ]] \
  || fail "capture mutated the linked worktree's sparse patterns"
[[ "$link_sparse_cfg_before" == "$link_sparse_cfg_after" ]] \
  || fail "capture mutated the linked worktree's sparse config"
[[ "$wt_list_before" == "$wt_list_after" ]] \
  || fail "capture mutated worktree registration"

# external worktree probe is done; release its registration before reset
git -C "$cap_target" worktree remove --force "$ext_wt" >/dev/null

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
