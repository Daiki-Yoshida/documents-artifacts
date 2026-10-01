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

  unset FIXTURE PREPARE_HOOK EXPECTED_HEAD_COMMIT_COUNT EVIDENCE_REPOSITORIES
  # shellcheck disable=SC1090
  source "$conf"
  [[ -n "${FIXTURE:-}" ]] || fail "FIXTURE missing: $scenario"
  fixture="$REPO_ROOT/tests/repositories/$FIXTURE"
  [[ -d "$fixture" ]] || fail "fixture missing for $scenario: $FIXTURE"

  if [[ -n "${PREPARE_HOOK:-}" ]]; then
    [[ "$PREPARE_HOOK" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]] \
      || fail "PREPARE_HOOK is not a plain file name: $scenario"
    [[ -f "${scenario_dir}${PREPARE_HOOK}" && ! -L "${scenario_dir}${PREPARE_HOOK}" ]] \
      || fail "PREPARE_HOOK file missing for $scenario: $PREPARE_HOOK"
  fi

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

  if [[ -n "${PREPARE_HOOK:-}" ]]; then
    [[ ! -e "$target/$PREPARE_HOOK" ]] \
      || fail "prepare hook source leaked into target repo: $scenario"
  fi

  [[ -z "$(git -C "$target" status --porcelain)" ]] || fail "prepared repo is dirty: $scenario"
  [[ "$(git -C "$target" rev-list --count HEAD)" == "${EXPECTED_HEAD_COMMIT_COUNT:-2}" ]] \
    || fail "prepared repo HEAD commit count mismatch: $scenario"
  git -C "$target" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
    || fail "prepared baseline tag missing: $scenario"

  # issue #136: the integration scenario's agent-visible surfaces must
  # state the commit authority a blind run needs to finish on `main` —
  # checked on PROMPT.md and the project README only, never EXPECTATIONS
  if [[ "$scenario" == "integration-head-revalidation" ]]; then
    grep -Fq 'authorization covers the commits needed' "$run_root/PROMPT.md" \
      || fail "integration task does not state in-scope commit authority"
    grep -Fq 'does not authorize pushing to any remote' "$run_root/PROMPT.md" \
      || fail "integration task does not bound the authorization scope"
    grep -Fq 'passing on the final committed integrated HEAD' "$run_root/PROMPT.md" \
      || fail "integration task does not require a verified committed result"
    grep -Fq 'committed on `main` and `make verify` passes' "$target/README.md" \
      || fail "fixture README does not state the committed-HEAD workflow"
  fi

  # issue #138: the project-entry-discovery pilot's agent-visible entry
  # surfaces carry only generic links — AGENTS/README route to
  # documents/INDEX.md, the project index links the artifacts root, and
  # neither entry surfaces nor the prompt leak leaf paths or the pack root
  if [[ "$scenario" == "project-entry-discovery" ]]; then
    grep -Fq 'documents/INDEX.md' "$target/AGENTS.md" \
      || fail "pilot AGENTS.md does not route to documents/INDEX.md"
    grep -Fq 'documents/INDEX.md' "$target/README.md" \
      || fail "pilot README lacks the project documentation pointer"
    grep -Fq '`artifacts/INDEX.md`' "$target/documents/INDEX.md" \
      || fail "pilot documents/INDEX.md lacks the generic artifacts link"
    for surface in AGENTS.md README.md documents/INDEX.md; do
      if grep -Eq 'artifacts/(design|implementation|operation|documentation|project|execution|safety)/' \
          "$target/$surface"; then
        fail "entry surface leaks an artifact leaf path: $scenario/$surface"
      fi
    done
    if grep -qi 'artifact' "$run_root/PROMPT.md"; then
      fail "pilot prompt leaks an artifact path or name"
    fi
    grep -Fq 'retried at most twice' "$run_root/PROMPT.md" \
      || fail "pilot prompt lost the retry policy task"
    base_fixture="$REPO_ROOT/tests/repositories/documented-project"
    for f in AGENTS.md README.md documents/project/HTTP_CLIENT.md documents/project/OPERATIONS.md; do
      cmp -s "$base_fixture/$f" "$fixture/$f" \
        || fail "pilot fixture diverges from documented-project at $f"
    done
    grep -Fq 'HTTP client policy (timeouts, retries, headers) | `project/HTTP_CLIENT.md`' \
      "$fixture/documents/INDEX.md" \
      || fail "pilot index lost the HTTP policy owner route"
  fi

  # issue #140: the required-entry variant keeps the same surfaces and
  # prompt shape, but its project index makes the root consult mandatory —
  # and the conditional pilot must stay conditional
  if [[ "$scenario" == "project-entry-required" ]]; then
    grep -Fq 'documents/INDEX.md' "$target/AGENTS.md" \
      || fail "required-entry AGENTS.md does not route to documents/INDEX.md"
    grep -Fq 'documents/INDEX.md' "$target/README.md" \
      || fail "required-entry README lacks the project documentation pointer"
    grep -Fq '`artifacts/INDEX.md`' "$target/documents/INDEX.md" \
      || fail "required-entry documents/INDEX.md lacks the artifacts link"
    grep -Fq 'Before project engineering or documentation changes' \
      "$target/documents/INDEX.md" \
      || fail "required-entry index lacks the consult-first policy"
    if grep -Fq 'when a task needs it' "$target/documents/INDEX.md"; then
      fail "required-entry index still carries the conditional phrasing"
    fi
    for surface in AGENTS.md README.md documents/INDEX.md; do
      if grep -Eq 'artifacts/(design|implementation|operation|documentation|project|execution|safety)/' \
          "$target/$surface"; then
        fail "entry surface leaks an artifact leaf path: $scenario/$surface"
      fi
    done
    if grep -qi 'artifact' "$run_root/PROMPT.md"; then
      fail "required-entry prompt leaks an artifact path or name"
    fi
    cmp -s "$REPO_ROOT/tests/scenarios/project-entry-discovery/PROMPT.md" \
      "$run_root/PROMPT.md" \
      || fail "required-entry prompt diverges from the conditional pilot prompt"
    base_fixture="$REPO_ROOT/tests/repositories/documented-project"
    for f in AGENTS.md README.md documents/project/HTTP_CLIENT.md documents/project/OPERATIONS.md; do
      cmp -s "$base_fixture/$f" "$fixture/$f" \
        || fail "required-entry fixture diverges from documented-project at $f"
    done
    grep -Fq 'when a task needs it' \
      "$REPO_ROOT/tests/repositories/documented-project-entry/documents/INDEX.md" \
      || fail "conditional pilot fixture lost its conditional phrasing"
    grep -Fq 'HTTP client policy (timeouts, retries, headers) | `project/HTTP_CLIENT.md`' \
      "$fixture/documents/INDEX.md" \
      || fail "required-entry index lost the HTTP policy owner route"
  fi

  # --- declared Component Repository evidence contract ---
  if [[ -n "${EVIDENCE_REPOSITORIES:-}" ]]; then
    meta="$run_root/RUN_METADATA.txt"
    for pair in $EVIDENCE_REPOSITORIES; do
      sel="${pair%%=*}"; rel="${pair#*=}"
      comp="$run_root/$rel"
      [[ -d "$comp/.git" ]] || fail "declared component repo missing: $scenario/$sel"
      [[ -z "$(git -C "$comp" status --porcelain)" ]] \
        || fail "declared component repo dirty at prepare: $scenario/$sel"
      git -C "$comp" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
        || fail "component baseline tag missing: $scenario/$sel"
      grep -Fqx "evidence_repository: $sel=$rel" "$meta" \
        || fail "component selector/path missing in RUN_METADATA: $sel"
      grep -Eq "^evidence_repository_${sel}_baseline_sha: [0-9a-f]{40}$" "$meta" \
        || fail "component baseline SHA missing in RUN_METADATA: $sel"
    done

    # mutate one tracked + one untracked file per component
    for pair in $EVIDENCE_REPOSITORIES; do
      sel="${pair%%=*}"; rel="${pair#*=}"
      comp="$run_root/$rel"
      tracked="$(git -C "$comp" ls-files | head -1)"
      [[ -n "$tracked" ]] || fail "component has no tracked file to modify: $sel"
      printf '# harness-mod-%s\n' "$sel" >> "$comp/$tracked"
      printf 'component note %s\n' "$sel" > "$comp/harness-untracked-$sel.txt"
    done

    # secret-like component untracked must fail closed (nothing persisted)
    first_pair="${EVIDENCE_REPOSITORIES%% *}"
    first_rel="${first_pair#*=}"
    printf 'api_key = AKIAIOSFODNN7EXAMPLE\n' > "$run_root/$first_rel/.env"
    if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
        "$CAPTURE" --scenario "$scenario" --run-id harness-selftest >/dev/null 2>&1; then
      fail "capture accepted secret-like component untracked file: $scenario"
    fi
    [[ ! -e "$TEST_RESULTS_ROOT/$scenario/harness-selftest/evidence" ]] \
      || fail "evidence persisted despite secret refusal: $scenario"
    rm -f "$run_root/$first_rel/.env"

    # component baseline tags are prepare-time evidence anchors; capture must
    # reject a moved tag even when the repository path itself is unchanged.
    first_sel="${first_pair%%=*}"
    first_comp="$run_root/$first_rel"
    prepared_component_base="$(sed -n "s/^evidence_repository_${first_sel}_baseline_sha: //p" "$meta")"
    tamper_commit="$(git -C "$first_comp" commit-tree HEAD^{tree} -p HEAD -m 'harness baseline tamper probe')"
    git -C "$first_comp" tag -f artifact-test-baseline "$tamper_commit" >/dev/null
    if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
        "$CAPTURE" --scenario "$scenario" --run-id baseline-tamper >/dev/null 2>&1; then
      fail "capture accepted moved component baseline tag: $scenario/$first_sel"
    fi
    [[ ! -e "$TEST_RESULTS_ROOT/$scenario/baseline-tamper/evidence" ]] \
      || fail "baseline-tamper refusal left persisted evidence: $scenario"
    git -C "$first_comp" tag -f artifact-test-baseline "$prepared_component_base" >/dev/null

    # Stabilize and snapshot component index/status before successful capture.
    declare -A component_index_before=() component_status_before=()
    for pair in $EVIDENCE_REPOSITORIES; do
      sel="${pair%%=*}"; rel="${pair#*=}"; comp="$run_root/$rel"
      git -C "$comp" status --porcelain >/dev/null
      git_dir="$(git -C "$comp" rev-parse --absolute-git-dir)"
      component_index_before[$sel]="$(sha1sum "$git_dir/index" | cut -d' ' -f1)"
      component_status_before[$sel]="$(env GIT_OPTIONAL_LOCKS=0 git -C "$comp" status --porcelain)"
    done

    ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
      "$CAPTURE" --scenario "$scenario" --run-id harness-selftest >/dev/null \
      || fail "capture failed for multi-repo scenario: $scenario"

    ev="$TEST_RESULTS_ROOT/$scenario/harness-selftest/evidence"
    [[ -f "$ev/repositories/INDEX.txt" ]] || fail "component evidence index missing: $scenario"
    for pair in $EVIDENCE_REPOSITORIES; do
      sel="${pair%%=*}"; rel="${pair#*=}"
      cdir="$ev/repositories/$sel"
      for f in metadata.txt status.txt changed-files.txt diff-stat.txt changes.patch \
               filesystem.txt inspection.txt; do
        [[ -f "$cdir/$f" ]] || fail "component evidence file missing: $scenario/$sel/$f"
      done
      grep -q "harness-mod-$sel" "$cdir/changes.patch" \
        || fail "component tracked change not captured: $sel"
      grep -q "harness-untracked-$sel" "$cdir/changes.patch" \
        || fail "component untracked change not captured: $sel"
      grep -q "^$sel | $rel " "$ev/repositories/INDEX.txt" \
        || fail "component INDEX row missing: $sel"
      comp="$run_root/$rel"
      git_dir="$(git -C "$comp" rev-parse --absolute-git-dir)"
      index_after="$(sha1sum "$git_dir/index" | cut -d' ' -f1)"
      status_after="$(env GIT_OPTIONAL_LOCKS=0 git -C "$comp" status --porcelain)"
      [[ "${component_index_before[$sel]}" == "$index_after" ]] \
        || fail "capture mutated component real index: $sel"
      [[ "${component_status_before[$sel]}" == "$status_after" ]] \
        || fail "capture mutated component status: $sel"
      git -C "$comp" diff --cached --quiet \
        || fail "capture staged changes into component real index: $sel"
      for other in $EVIDENCE_REPOSITORIES; do
        osel="${other%%=*}"
        [[ "$osel" == "$sel" ]] && continue
        if grep -q "harness-mod-$osel\|harness-untracked-$osel" "$cdir/changes.patch"; then
          fail "component evidence leaked across repositories: $osel -> $sel"
        fi
      done
      if find "$cdir" -path '*\.git*' -print -quit | grep -q .; then
        fail "component .git content leaked into evidence: $sel"
      fi
    done
    for pair in $EVIDENCE_REPOSITORIES; do
      rel="${pair#*=}"
      rel_in_repo="${rel#repo/}"
      if grep -q "^[AMDR]\s*$rel_in_repo\|a/$rel_in_repo/" \
          "$ev/changed-files.txt" "$ev/changes.patch" 2>/dev/null; then
        fail "component source leaked into primary evidence: $scenario"
      fi
    done
    if grep -Eq '(^|/)\.git(/|$)' "$ev/filesystem.txt"; then
      fail "nested component .git internals leaked into primary filesystem evidence: $scenario"
    fi
  fi

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

# --- run-level provenance / verification output / observed reads ---

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$PREPARE" --scenario "$cap_scenario" --force >/dev/null
prov_root="$TEST_RUNS_ROOT/$cap_scenario"

# the provenance template is emitted at the run root only — it must never
# leak into the generated repository where the agent works
[[ -f "$prov_root/RUN_PROVENANCE.txt" ]] \
  || fail "run provenance template missing at run root"
[[ ! -e "$prov_root/repo/RUN_PROVENANCE.txt" ]] \
  || fail "run provenance template leaked into generated repo"

# a template-only file (comments and blanks, no key pairs) is not provided
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id prov-none >/dev/null
evn="$TEST_RESULTS_ROOT/$cap_scenario/prov-none"
grep -Fqx 'provenance: not-provided' "$evn/evidence/metadata.txt" \
  || fail "template-only provenance not marked not-provided"
grep -Fqx 'verification_output: not-provided' "$evn/evidence/metadata.txt" \
  || fail "missing verification output not marked not-provided"
grep -Fqx 'observed_reads: not-provided' "$evn/evidence/metadata.txt" \
  || fail "missing observed reads not marked not-provided"
[[ ! -e "$evn/provenance.txt" ]] || fail "template-only provenance persisted"
[[ ! -e "$evn/verification" ]] || fail "phantom verification output persisted"
[[ ! -e "$evn/observed-reads.txt" ]] || fail "phantom observed reads persisted"

# template ergonomics: uncommenting the example `model` line must yield the
# exact value — explanations live on their own comment lines
sed -i 's/^# model: gpt-6-luna$/model: gpt-6-luna/' "$prov_root/RUN_PROVENANCE.txt"
grep -Fqx 'model: gpt-6-luna' "$prov_root/RUN_PROVENANCE.txt" \
  || fail "template model example is not a clean key: value line"
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id prov-template >/dev/null
evt="$TEST_RESULTS_ROOT/$cap_scenario/prov-template"
grep -Fqx 'provenance: present' "$evt/evidence/metadata.txt" \
  || fail "uncommented template provenance not marked present"
grep -Fqx 'model: gpt-6-luna' "$evt/provenance.txt" \
  || fail "persisted provenance lost the exact model value"

# filled provenance + verification output + observed reads persist verbatim
# at the run-id level, outside evidence/
cat > "$prov_root/RUN_PROVENANCE.txt" <<'EOF'
# operator comment
model: gpt-6-luna
model_version: test-snapshot
reasoning_effort: medium
agent_runtime: harness selftest
run_started_at_utc: 2026-10-01T12:00:00Z
run_finished_at_utc: 2026-10-01T12:20:00Z
entry_condition: prompt-directed-index
repetition: 1
run_set: harness-selftest
read_evidence: self-reported
known_limitations: no tool telemetry
EOF
mkdir -p "$prov_root/verification"
printf 'running 3 tests\n3/3 passed\n' > "$prov_root/verification/node-test.txt"
printf 'documents/artifacts/INDEX.md\ndocuments/artifacts/implementation/INDEX.md\n' \
  > "$prov_root/OBSERVED_READS.txt"

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id prov-full >/dev/null
evf="$TEST_RESULTS_ROOT/$cap_scenario/prov-full"
cmp -s "$prov_root/RUN_PROVENANCE.txt" "$evf/provenance.txt" \
  || fail "provenance.txt differs from run-root source"
grep -Fqx 'provenance: present' "$evf/evidence/metadata.txt" \
  || fail "provided provenance not marked present"
grep -Fqx 'verification_output: present' "$evf/evidence/metadata.txt" \
  || fail "provided verification output not marked present"
grep -Fqx 'observed_reads: present' "$evf/evidence/metadata.txt" \
  || fail "provided observed reads not marked present"
cmp -s "$prov_root/verification/node-test.txt" "$evf/verification/node-test.txt" \
  || fail "verification output not persisted verbatim"
cmp -s "$prov_root/OBSERVED_READS.txt" "$evf/observed-reads.txt" \
  || fail "observed reads not persisted verbatim"
# run-level records stay outside the machine-generated evidence bundle
for leaked in provenance.txt verification observed-reads.txt; do
  [[ ! -e "$evf/evidence/$leaked" ]] \
    || fail "run-level record leaked into evidence bundle: $leaked"
done

# malformed / unauthorized provenance fails closed before persisting anything
printf 'unknown_key: x\n' > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-bad-key >/dev/null 2>&1; then
  fail "capture accepted unknown provenance key"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-bad-key" ]] \
  || fail "rejected provenance left persisted output"

printf 'model: a\nmodel: b\n' > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-dup >/dev/null 2>&1; then
  fail "capture accepted duplicate provenance key"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-dup" ]] \
  || fail "rejected duplicate provenance left persisted output"

printf 'repetition: 1\n' > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-nomodel >/dev/null 2>&1; then
  fail "capture accepted provenance without model"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-nomodel" ]] \
  || fail "model-less provenance left persisted output"

# secret-like verification output fails closed like any other content
printf 'model: gpt-6-luna\n' > "$prov_root/RUN_PROVENANCE.txt"
printf 'api_key = AKIAIOSFODNN7EXAMPLE\n' > "$prov_root/verification/leak.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-secret >/dev/null 2>&1; then
  fail "capture persisted secret-like verification output"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-secret" ]] \
  || fail "failed secret capture left persisted output"
rm -f "$prov_root/verification/leak.txt"

# --- provenance capture regressions ---

# the content filter applies to the complete provenance input: secret-like
# text in a value and in a comment line are both refused before persistence
printf 'model: gpt-6-luna\nknown_limitations: token=FAKE_REVIEW_ONLY_12345678\n' \
  > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-filter-value >/dev/null 2>&1; then
  fail "capture accepted secret-like provenance value"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-filter-value" ]] \
  || fail "rejected provenance value left persisted output"

printf '# note: token=FAKE_REVIEW_ONLY_12345678\nmodel: gpt-6-luna\n' \
  > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-filter-comment >/dev/null 2>&1; then
  fail "capture accepted secret-like provenance comment"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-filter-comment" ]] \
  || fail "rejected provenance comment left persisted output"

# value length boundary: 500 characters is accepted, 501 is refused —
# the allowlist match must not clobber the saved parsed value
val500="$(head -c 500 /dev/zero | tr '\0' 'x')"
printf 'model: %s\n' "$val500" > "$prov_root/RUN_PROVENANCE.txt"
ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id prov-len-500 >/dev/null
evl="$TEST_RESULTS_ROOT/$cap_scenario/prov-len-500"
grep -Fqx 'provenance: present' "$evl/evidence/metadata.txt" \
  || fail "500-character provenance value not marked present"
cmp -s "$prov_root/RUN_PROVENANCE.txt" "$evl/provenance.txt" \
  || fail "500-character provenance value not persisted verbatim"

val501="$(head -c 501 /dev/zero | tr '\0' 'x')"
printf 'model: %s\n' "$val501" > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-len-501 >/dev/null 2>&1; then
  fail "capture accepted 501-character provenance value"
fi
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-len-501" ]] \
  || fail "over-limit provenance left persisted output"

# malformed input reports file and line number, never the line content
printf 'model: gpt-6-luna\nMALFORMED_MARKER_LINE\n' > "$prov_root/RUN_PROVENANCE.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-diag \
    >"$prov_root/diag.out" 2>&1; then
  fail "capture accepted malformed provenance line"
fi
diag_out="$(cat "$prov_root/diag.out")"
rm -f "$prov_root/diag.out"
[[ "$diag_out" == *"line 2"* ]] \
  || fail "malformed provenance diagnostic missing line number: $diag_out"
[[ "$diag_out" != *MALFORMED_MARKER_LINE* ]] \
  || fail "malformed provenance diagnostic echoed line content"
[[ ! -e "$TEST_RESULTS_ROOT/$cap_scenario/prov-diag" ]] \
  || fail "rejected malformed provenance left persisted output"

# destination collisions — including dangling symlinks — are refused before
# any output is written; existing records such as REPORT.md stay untouched
printf 'model: gpt-6-luna\n' > "$prov_root/RUN_PROVENANCE.txt"
dest_dir="$TEST_RESULTS_ROOT/$cap_scenario/prov-dest"
mkdir -p "$dest_dir"
printf 'stale provenance\n' > "$dest_dir/provenance.txt"
printf 'agent report\n' > "$dest_dir/REPORT.md"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-dest >/dev/null 2>&1; then
  fail "capture overwrote an existing provenance destination"
fi
[[ ! -e "$dest_dir/evidence" ]] \
  || fail "refused capture still created an evidence bundle"
[[ "$(cat "$dest_dir/REPORT.md")" == "agent report" ]] \
  || fail "existing REPORT.md was clobbered"
[[ "$(cat "$dest_dir/provenance.txt")" == "stale provenance" ]] \
  || fail "existing provenance record was clobbered"

sym_dir="$TEST_RESULTS_ROOT/$cap_scenario/prov-sym"
mkdir -p "$sym_dir"
ln -s "$sym_dir/nonexistent-target" "$sym_dir/observed-reads.txt"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-sym >/dev/null 2>&1; then
  fail "capture accepted dangling symlink destination"
fi
[[ ! -e "$sym_dir/evidence" ]] \
  || fail "refused symlink capture still created an evidence bundle"
[[ -L "$sym_dir/observed-reads.txt" ]] \
  || fail "dangling symlink destination was removed or replaced"

vdir="$TEST_RESULTS_ROOT/$cap_scenario/prov-vdir"
mkdir -p "$vdir/verification"
if ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-vdir >/dev/null 2>&1; then
  fail "capture overwrote an existing verification destination"
fi
[[ ! -e "$vdir/evidence" ]] \
  || fail "refused capture still created an evidence bundle"

# a failed optional-record copy rolls back only the paths this attempt
# created: no partial bundle is published, pre-existing records survive,
# and a normal retry then succeeds
fakebin="$prov_root/fakebin"
mkdir -p "$fakebin"
printf '#!/usr/bin/env bash\nexit 71\n' > "$fakebin/cp"
chmod +x "$fakebin/cp"
cpf_dir="$TEST_RESULTS_ROOT/$cap_scenario/prov-cpfail"
mkdir -p "$cpf_dir"
printf 'agent report\n' > "$cpf_dir/REPORT.md"
printf 'model: gpt-6-luna\nreasoning_effort: medium\n' > "$prov_root/RUN_PROVENANCE.txt"
if PATH="$fakebin:$PATH" ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
    "$CAPTURE" --scenario "$cap_scenario" --run-id prov-cpfail >/dev/null 2>&1; then
  fail "capture succeeded with injected cp failure"
fi
[[ ! -e "$cpf_dir/evidence" ]] \
  || fail "failed copy left a partial evidence bundle"
[[ ! -e "$cpf_dir/provenance.txt" ]] \
  || fail "failed copy left a partial provenance record"
[[ ! -e "$cpf_dir/verification" ]] \
  || fail "failed copy left a partial verification record"
[[ ! -e "$cpf_dir/observed-reads.txt" ]] \
  || fail "failed copy left a partial observed-reads record"
[[ "$(cat "$cpf_dir/REPORT.md")" == "agent report" ]] \
  || fail "rollback clobbered pre-existing REPORT.md"

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" ARTIFACT_TEST_RESULTS_ROOT="$TEST_RESULTS_ROOT" \
  "$CAPTURE" --scenario "$cap_scenario" --run-id prov-cpfail >/dev/null
[[ -f "$cpf_dir/evidence/metadata.txt" ]] \
  || fail "retry after rolled-back capture did not produce evidence"
cmp -s "$prov_root/RUN_PROVENANCE.txt" "$cpf_dir/provenance.txt" \
  || fail "retry after rolled-back capture did not persist provenance"
[[ -f "$cpf_dir/verification/node-test.txt" ]] \
  || fail "retry after rolled-back capture did not persist verification output"
[[ -f "$cpf_dir/observed-reads.txt" ]] \
  || fail "retry after rolled-back capture did not persist observed reads"
grep -Fqx 'provenance: present' "$cpf_dir/evidence/metadata.txt" \
  || fail "retry metadata does not mark provenance present"

ARTIFACT_TEST_RUNS_ROOT="$TEST_RUNS_ROOT" "$RESET" --scenario "$cap_scenario" >/dev/null

printf 'PASS: execution-agent harness fixtures and scenarios\n'
