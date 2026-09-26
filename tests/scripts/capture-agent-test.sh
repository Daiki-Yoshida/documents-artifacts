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

RUN_METADATA="$RUN_ROOT/RUN_METADATA.txt"
[[ -f "$RUN_METADATA" ]] || fail "prepare-time metadata missing: $RUN_METADATA"

metadata_value() {
  local key="$1"
  sed -n "s/^${key}: //p" "$RUN_METADATA" | head -1
}

PREPARED_SCENARIO="$(metadata_value scenario)"
PREPARED_FIXTURE="$(metadata_value fixture)"
PREPARED_SOURCE_SHA="$(metadata_value source_repo_head)"
PREPARED_BASE_SHA="$(metadata_value baseline_sha)"
PREPARED_AT="$(metadata_value prepared_at_utc)"

[[ "$PREPARED_SCENARIO" == "$SCENARIO" ]] || fail "run metadata scenario mismatch"
[[ "$PREPARED_FIXTURE" == "$FIXTURE" ]] || fail "run metadata fixture mismatch"
[[ "$PREPARED_SOURCE_SHA" =~ ^[0-9a-f]{40}$ ]] || fail "invalid prepare-time source SHA"
[[ "$PREPARED_BASE_SHA" =~ ^[0-9a-f]{40}$ ]] || fail "invalid prepare-time baseline SHA"
[[ -n "$PREPARED_AT" ]] || fail "prepare-time timestamp missing"

BASE_SHA="$(git -C "$TARGET" rev-parse artifact-test-baseline)"
HEAD_SHA="$(git -C "$TARGET" rev-parse HEAD)"
CAPTURE_SOURCE_SHA="$(git -C "$REPO_ROOT" rev-parse HEAD)"
[[ "$PREPARED_BASE_SHA" == "$BASE_SHA" ]] || fail "prepared baseline SHA no longer matches generated repo tag"

# changes.patch intentionally includes non-ignored untracked file contents so
# evaluator review can inspect newly-created files. Fail closed on obvious
# secret-bearing paths/content before creating any persisted evidence.
mapfile -d '' UNTRACKED_FILES < <(
  env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" ls-files --others --exclude-standard -z
)
for rel in "${UNTRACKED_FILES[@]}"; do
  base="${rel##*/}"
  case "$base" in
    .env.example|.env.sample|.env.template)
      ;;
    .env|.env.*|*.pem|*.key|*.p12|*.pfx|*.jks|*.keystore|id_rsa|id_rsa.*|id_ed25519|id_ed25519.*|credentials|credentials.*|secrets|secrets.*|.netrc|.npmrc|.pypirc)
      fail "refusing to persist content from secret-like untracked path: $rel"
      ;;
  esac

  full="$TARGET/$rel"
  if [[ -f "$full" && ! -L "$full" ]]; then
    if LC_ALL=C grep -I -i -E -q \
      '(BEGIN ([A-Z]+ )?PRIVATE KEY|AKIA[0-9A-Z]{16}|github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|(api[_-]?key|secret|token|password)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8,})' \
      "$full"; then
      fail "refusing to persist content from secret-like untracked file: $rel"
    fi
  fi
done

OUT="$RESULTS_ROOT/$SCENARIO/$RUN_ID"
[[ "$OUT" == "$RESULTS_ROOT/"* ]] || fail "refusing unsafe output path"
EV="$OUT/evidence"
[[ ! -e "$EV" ]] || fail "evidence already captured for this run id: $EV"
mkdir -p -- "$EV"

TMP_INDEX="$(mktemp)"
trap 'rm -f -- "$TMP_INDEX"' EXIT

{
  printf 'scenario: %s\n' "$SCENARIO"
  printf 'run_id: %s\n' "$RUN_ID"
  printf 'fixture: %s\n' "$FIXTURE"
  printf 'prepared_at_utc: %s\n' "$PREPARED_AT"
  printf 'captured_at_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'source_repo_head_at_prepare: %s\n' "$PREPARED_SOURCE_SHA"
  printf 'source_repo_head_at_capture: %s\n' "$CAPTURE_SOURCE_SHA"
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
# worktree, then diff. This represents non-ignored untracked new files in the
# patch without touching the generated repository's real index/worktree.
# Secret-like untracked content is rejected above; ignored files stay out of
# the patch and only their path/type/size evidence is recorded.
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

# Worktree evidence: registration comes from `git worktree list --porcelain`
# (Git is the source of truth; a `.git` pointer file alone does not prove
# registration). Detailed inspection (status / sparse state) is allowed only
# for the primary generated repository and linked worktrees whose resolved
# real path stays inside the prepared run directory. Registered worktrees
# outside that boundary are recorded as registered but not inspected.
# Everything here is read-only and runs with GIT_OPTIONAL_LOCKS=0 so capture
# never mutates any worktree's index, status, or sparse configuration.
TARGET_REAL="$(cd "$TARGET" && pwd -P)"
RUN_ROOT_REAL="$(cd "$RUN_ROOT" && pwd -P)"
{
  printf '=== git worktree list --porcelain (registration) ===\n'
  env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" worktree list --porcelain
  printf '\n=== per-worktree inspection ===\n'
  printf 'safe_inspection_boundary: %s\n' "$RUN_ROOT_REAL"
  printf '(only the primary generated repository and linked worktrees whose\n'
  printf 'resolved real path is inside this run directory are inspected)\n'

  wt_record=""
  print_worktree_block() {
    local record="$1"
    local path="" reg_head="" reg_ref="none"
    local attrs=()
    local l
    while IFS= read -r l || [[ -n "$l" ]]; do
      case "$l" in
        "worktree "*) path="${l#worktree }" ;;
        "HEAD "*) reg_head="${l#HEAD }" ;;
        "branch "*) reg_ref="${l#branch }" ;;
        detached) reg_ref="detached" ;;
        bare) reg_ref="bare" ;;
        "locked"*|"prunable"*) attrs+=("$l") ;;
      esac
    done <<< "$record"
    [[ -n "$path" ]] || return 0

    printf 'worktree: %s\n' "$path"
    printf '  registration_head: %s\n' "${reg_head:-unavailable}"
    printf '  registration_ref: %s\n' "$reg_ref"
    if ((${#attrs[@]})); then
      printf '  registration_attrs: %s\n' "${attrs[*]}"
    else
      printf '  registration_attrs: none\n'
    fi

    local real="" skip_reason=""
    if [[ "$path" != /* ]]; then
      skip_reason="non-absolute worktree path in registration"
    elif [[ "$path" == *..* ]]; then
      skip_reason="path contains .."
    elif [[ ! -d "$path" ]]; then
      skip_reason="registered path does not exist on filesystem"
    elif ! real="$(cd "$path" 2>/dev/null && pwd -P)"; then
      skip_reason="registered path did not resolve"
    elif [[ "$real" != "$TARGET_REAL" && "$real" != "$RUN_ROOT_REAL/"* ]]; then
      skip_reason="resolved path outside safe inspection boundary"
    fi

    if [[ -n "$real" ]]; then
      printf '  resolved_path: %s\n' "$real"
      if [[ "$real" == "$TARGET_REAL" ]]; then
        printf '  boundary_scope: primary-generated-repo\n'
      else
        printf '  boundary_scope: linked-under-run\n'
      fi
    fi

    if [[ -n "$skip_reason" ]]; then
      printf '  inspected: no\n'
      printf '  skip_reason: %s\n' "$skip_reason"
      return 0
    fi

    printf '  inspected: yes\n'
    printf '  head: %s\n' \
      "$(env GIT_OPTIONAL_LOCKS=0 git -C "$real" rev-parse HEAD 2>/dev/null || printf 'unavailable')"
    local cur_branch
    cur_branch="$(env GIT_OPTIONAL_LOCKS=0 git -C "$real" branch --show-current 2>/dev/null || true)"
    if [[ -n "$cur_branch" ]]; then
      printf '  branch: %s\n' "$cur_branch"
    else
      printf '  branch: detached\n'
    fi
    local wt_status
    if wt_status="$(env GIT_OPTIONAL_LOCKS=0 git -C "$real" status --porcelain 2>/dev/null)"; then
      if [[ -z "$wt_status" ]]; then
        printf '  status: clean\n'
      else
        printf '  status: dirty\n'
        printf '  status_detail:\n'
        printf '%s\n' "$wt_status" | sed 's/^/    /'
      fi
    else
      printf '  status: unavailable\n'
    fi
    local sparse_cfg
    sparse_cfg="$(env GIT_OPTIONAL_LOCKS=0 git -C "$real" config --get core.sparseCheckout 2>/dev/null || true)"
    if [[ "$sparse_cfg" == "true" ]]; then
      printf '  sparse_checkout: enabled\n'
      local sparse_patterns
      if sparse_patterns="$(env GIT_OPTIONAL_LOCKS=0 git -C "$real" sparse-checkout list 2>/dev/null)"; then
        if [[ -n "$sparse_patterns" ]]; then
          printf '  sparse_patterns:\n'
          printf '%s\n' "$sparse_patterns" | sed 's/^/    /'
        else
          printf '  sparse_patterns: none\n'
        fi
      else
        # `git sparse-checkout list` requires Git >= 2.26; older versions
        # lack the subcommand. Internal sparse-checkout config files are
        # deliberately not read as a fallback.
        printf '  sparse_patterns: unavailable (sparse-checkout list unsupported or failed)\n'
      fi
    else
      printf '  sparse_checkout: disabled\n'
    fi
  }

  while IFS= read -r l; do
    if [[ -z "$l" ]]; then
      print_worktree_block "$wt_record"
      wt_record=""
    else
      wt_record+="$l"$'\n'
    fi
  done < <(env GIT_OPTIONAL_LOCKS=0 git -C "$TARGET" worktree list --porcelain)
  print_worktree_block "$wt_record"
} > "$EV/worktrees.txt"

printf 'Captured evidence: %s\n' "$EV"
printf 'Agent-authored report goes to: %s\n' "$OUT/REPORT.md"
