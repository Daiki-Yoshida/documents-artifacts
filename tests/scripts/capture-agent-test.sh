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
unset FIXTURE EVIDENCE_REPOSITORIES || true
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
file_has_secret_content() {
  local f="$1"
  [[ -f "$f" && ! -L "$f" ]] || return 1
  LC_ALL=C grep -I -i -E -q \
    '(BEGIN ([A-Z]+ )?PRIVATE KEY|AKIA[0-9A-Z]{16}|github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|(api[_-]?key|secret|token|password)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8,})' \
    "$f"
}
scan_untracked_secrets() {
  local repo="$1" rel base full
  local -a files=()
  mapfile -d '' files < <(
    env GIT_OPTIONAL_LOCKS=0 git -C "$repo" ls-files --others --exclude-standard -z
  )
  for rel in "${files[@]}"; do
    base="${rel##*/}"
    case "$base" in
      .env.example|.env.sample|.env.template)
        ;;
      .env|.env.*|*.pem|*.key|*.p12|*.pfx|*.jks|*.keystore|id_rsa|id_rsa.*|id_ed25519|id_ed25519.*|credentials|credentials.*|secrets|secrets.*|.netrc|.npmrc|.pypirc)
        fail "refusing to persist content from secret-like untracked path: $repo/$rel"
        ;;
    esac
    full="$repo/$rel"
    if file_has_secret_content "$full"; then
      fail "refusing to persist content from secret-like untracked file: $repo/$rel"
    fi
  done
}

# Resolve declared Component Repositories (scenario.conf
# EVIDENCE_REPOSITORIES: selector=run-root-relative-path). Same safety
# contract as prepare: no absolute paths, no traversal, no symlink
# escapes, must be an independent Git repo inside the run root.
EVIDENCE_REPOS=()
if [[ -n "${EVIDENCE_REPOSITORIES:-}" ]]; then
  RUN_ROOT_REAL="$(cd "$RUN_ROOT" && pwd -P)"
  TARGET_REAL="$(cd "$TARGET" && pwd -P)"
  declare -A SEEN_SEL=() SEEN_REAL=()
  for pair in $EVIDENCE_REPOSITORIES; do
    [[ "$pair" == *=* ]] || fail "invalid EVIDENCE_REPOSITORIES entry: $pair"
    sel="${pair%%=*}"; rel="${pair#*=}"
    [[ "$sel" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid evidence repository selector: $sel"
    [[ -n "$rel" && "$rel" != /* && "$rel" != *..* ]] \
      || fail "evidence repository path must be non-empty, relative, traversal-free: $rel"
    [[ "$rel" =~ ^[a-zA-Z0-9_./-]+$ ]] \
      || fail "unsafe characters in evidence repository path: $rel"
    [[ ! -L "$RUN_ROOT/$rel" ]] || fail "evidence repository path is a symlink: $rel"
    [[ -d "$RUN_ROOT/$rel" ]] || fail "declared evidence repository missing at capture: $rel"
    REAL="$(cd "$RUN_ROOT/$rel" && pwd -P)"
    [[ "$REAL" == "$RUN_ROOT_REAL/"* ]] \
      || fail "evidence repository resolves outside run root: $rel"
    [[ "$REAL" != "$TARGET_REAL" ]] \
      || fail "evidence repository must be independent of the primary repository: $rel"
    [[ -d "$REAL/.git" && ! -L "$REAL/.git" ]] || fail "not a safe independent Git repository: $rel"
    [[ -z "${SEEN_SEL[$sel]:-}" ]] || fail "duplicate evidence repository selector at capture: $sel"
    [[ -z "${SEEN_REAL[$REAL]:-}" ]] || fail "duplicate evidence repository path at capture: $rel"
    SEEN_SEL[$sel]=1; SEEN_REAL[$REAL]=1

    git -C "$REAL" rev-parse -q --verify refs/tags/artifact-test-baseline >/dev/null \
      || fail "component baseline tag missing for $sel: $REAL"

    prepared_rel="$(sed -n "s/^evidence_repository: ${sel}=//p" "$RUN_METADATA" | head -1)"
    [[ "$prepared_rel" == "$rel" ]] \
      || fail "component repository declaration changed since prepare for $sel: prepared='$prepared_rel' capture='$rel'"

    prepared_cbase="$(metadata_value "evidence_repository_${sel}_baseline_sha")"
    [[ "$prepared_cbase" =~ ^[0-9a-f]{40}$ ]] \
      || fail "invalid prepare-time component baseline SHA for $sel"
    actual_cbase="$(git -C "$REAL" rev-parse artifact-test-baseline)"
    [[ "$prepared_cbase" == "$actual_cbase" ]] \
      || fail "component baseline tag changed since prepare for $sel"

    EVIDENCE_REPOS+=("$sel|$rel|$REAL")
  done

  prepared_repo_count="$(grep -c '^evidence_repository: ' "$RUN_METADATA" || true)"
  [[ "$prepared_repo_count" == "${#EVIDENCE_REPOS[@]}" ]] \
    || fail "component repository declaration count changed since prepare"
else
  prepared_repo_count="$(grep -c '^evidence_repository: ' "$RUN_METADATA" || true)"
  [[ "$prepared_repo_count" == "0" ]] \
    || fail "prepared run declares component repositories but current scenario configuration does not"
fi

scan_untracked_secrets "$TARGET"
if ((${#EVIDENCE_REPOS[@]})); then
  for entry in "${EVIDENCE_REPOS[@]}"; do
    REAL="${entry##*|}"
    scan_untracked_secrets "$REAL"
  done
fi

# Optional run-level records supplied at the run root, outside the generated
# repository. They are operator/run context, never agent task input. All of
# them are validated here — before any persisted output is created — and then
# copied verbatim next to evidence/ (never inside it) so authorship stays
# distinguishable: evidence/ = machine-generated capture,
# provenance.txt = operator-authored run context,
# verification/ = raw command output produced during the run,
# observed-reads.txt = operator/tool-recorded artifact reads.
# Inputs absent at capture are recorded as not-provided and are never
# reconstructed afterwards; older runs simply lack these records.
PROV_SRC="$RUN_ROOT/RUN_PROVENANCE.txt"
PROV_KEY_PATTERN='model|model_version|reasoning_effort|agent_runtime|run_started_at_utc|run_finished_at_utc|entry_condition|repetition|run_set|read_evidence|known_limitations'
PROVIDED_PROVENANCE=0
if [[ -e "$PROV_SRC" || -L "$PROV_SRC" ]]; then
  [[ -f "$PROV_SRC" && ! -L "$PROV_SRC" ]] \
    || fail "run provenance must be a regular file: $PROV_SRC"
  # The same content filter as untracked evidence applies to the complete
  # provenance input, including comment lines, before anything is persisted.
  if file_has_secret_content "$PROV_SRC"; then
    fail "refusing to persist secret-like run provenance file: $PROV_SRC"
  fi
  prov_pairs=0
  prov_lineno=0
  declare -A prov_seen=()
  prov_line=""
  prov_key=""
  prov_value=""
  while IFS= read -r prov_line || [[ -n "$prov_line" ]]; do
    ((prov_lineno += 1))
    [[ "$prov_line" =~ ^[[:space:]]*$ || "$prov_line" == \#* ]] && continue
    # Report position only — never echo the offending line, which may carry
    # operator data that must not reach logs.
    if ! [[ "$prov_line" =~ ^([a-z][a-z0-9_]*):[[:space:]]*(.*[^[:space:]])[[:space:]]*$ ]]; then
      fail "malformed run provenance at $PROV_SRC line $prov_lineno"
    fi
    prov_key="${BASH_REMATCH[1]}"
    prov_value="${BASH_REMATCH[2]}"
    [[ "$prov_key" =~ ^($PROV_KEY_PATTERN)$ ]] \
      || fail "unknown run provenance key: $prov_key"
    [[ -z "${prov_seen[$prov_key]:-}" ]] \
      || fail "duplicate run provenance key: $prov_key"
    prov_seen[$prov_key]=1
    ((${#prov_value} <= 500)) \
      || fail "run provenance value too long: $prov_key"
    ((prov_pairs += 1))
  done < "$PROV_SRC"
  if ((prov_pairs > 0)); then
    [[ -n "${prov_seen[model]:-}" ]] \
      || fail "run provenance provided without 'model'"
    PROVIDED_PROVENANCE=1
  fi
fi

VER_SRC="$RUN_ROOT/verification"
PROVIDED_VERIFICATION=0
ver_file_count=0
if [[ -e "$VER_SRC" || -L "$VER_SRC" ]]; then
  [[ -d "$VER_SRC" && ! -L "$VER_SRC" ]] \
    || fail "verification output must be a real directory: $VER_SRC"
  while IFS= read -r -d '' ver_file; do
    [[ -f "$ver_file" && ! -L "$ver_file" ]] \
      || fail "verification output accepts flat regular files only: $ver_file"
    if file_has_secret_content "$ver_file"; then
      fail "refusing to persist secret-like verification output: $ver_file"
    fi
    ((ver_file_count += 1))
  done < <(find "$VER_SRC" -mindepth 1 -maxdepth 1 -print0)
  if ((ver_file_count > 0)); then
    PROVIDED_VERIFICATION=1
  fi
fi

READS_SRC="$RUN_ROOT/OBSERVED_READS.txt"
PROVIDED_READS=0
if [[ -e "$READS_SRC" || -L "$READS_SRC" ]]; then
  [[ -f "$READS_SRC" && ! -L "$READS_SRC" ]] \
    || fail "observed reads record must be a regular file: $READS_SRC"
  if [[ -s "$READS_SRC" ]]; then
    if file_has_secret_content "$READS_SRC"; then
      fail "refusing to persist secret-like observed reads file: $READS_SRC"
    fi
    PROVIDED_READS=1
  fi
fi

if ((PROVIDED_PROVENANCE)); then PROV_STATE="present"; else PROV_STATE="not-provided"; fi
if ((PROVIDED_VERIFICATION)); then VER_STATE="present"; else VER_STATE="not-provided"; fi
if ((PROVIDED_READS)); then READS_STATE="present"; else READS_STATE="not-provided"; fi

OUT="$RESULTS_ROOT/$SCENARIO/$RUN_ID"
[[ "$OUT" == "$RESULTS_ROOT/"* ]] || fail "refusing unsafe output path"
EV="$OUT/evidence"
# Preflight every destination this capture may publish — including dangling
# symlinks, which -e alone would miss — before creating anything. A refused
# capture must leave no partial bundle behind and must never clobber an
# existing record such as REPORT.md.
[[ ! -e "$EV" && ! -L "$EV" ]] \
  || fail "evidence already captured for this run id: $EV"
for dest in "$OUT/provenance.txt" "$OUT/verification" "$OUT/observed-reads.txt"; do
  [[ ! -e "$dest" && ! -L "$dest" ]] \
    || fail "run-level record destination already exists: $dest"
done
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
  printf 'provenance: %s\n' "$PROV_STATE"
  printf 'verification_output: %s\n' "$VER_STATE"
  printf 'observed_reads: %s\n' "$READS_STATE"
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
(cd "$TARGET" && find . -type d -name .git -prune -o -printf '%y %10s %p\n' | sort) > "$EV/filesystem.txt"

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

# Declared Component Repository evidence: each independent repo gets its
# own evidence set under evidence/repositories/<selector>/ plus an
# INDEX.txt overview. Same alternate-index technique as the primary repo
# — component real indexes/worktrees are never mutated; .git internals
# are never persisted.
if ((${#EVIDENCE_REPOS[@]})); then
  REV_DIR="$EV/repositories"
  mkdir -p -- "$REV_DIR"
  {
    printf 'declared component repositories\n'
    printf 'format: selector | run_root_relative_path | baseline_sha | head_sha | branch | status\n'
  } > "$REV_DIR/INDEX.txt"

  for entry in "${EVIDENCE_REPOS[@]}"; do
    sel="${entry%%|*}"; rest="${entry#*|}"; rel="${rest%%|*}"; CREAL="${rest#*|}"
    CDIR="$REV_DIR/$sel"
    mkdir -p -- "$CDIR"

    CBASE="$(git -C "$CREAL" rev-parse artifact-test-baseline)"
    CHEAD="$(git -C "$CREAL" rev-parse HEAD)"
    CBRANCH="$(env GIT_OPTIONAL_LOCKS=0 git -C "$CREAL" branch --show-current || true)"
    [[ -n "$CBRANCH" ]] || CBRANCH="detached"
    CSTATUS="$(env GIT_OPTIONAL_LOCKS=0 git -C "$CREAL" status --porcelain)"

    {
      printf 'selector: %s\n' "$sel"
      printf 'run_root_relative_path: %s\n' "$rel"
      printf 'resolved_path: %s\n' "$CREAL"
      printf 'baseline_tag: artifact-test-baseline\n'
      printf 'baseline_sha: %s\n' "$CBASE"
      printf 'head_sha_at_capture: %s\n' "$CHEAD"
      printf 'branch_at_capture: %s\n' "$CBRANCH"
      printf 'captured_at_utc: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    } > "$CDIR/metadata.txt"

    {
      printf '=== git status --short ===\n'
      printf '%s\n' "$CSTATUS"
      printf '\n=== ignored paths present (names only) ===\n'
      cign="$(env GIT_OPTIONAL_LOCKS=0 git -C "$CREAL" status --porcelain --ignored | grep '^!!' || true)"
      if [[ -n "$cign" ]]; then printf '%s\n' "$cign"; else printf 'none\n'; fi
    } > "$CDIR/status.txt"

    env GIT_INDEX_FILE="$TMP_INDEX" git -C "$CREAL" read-tree artifact-test-baseline
    env GIT_INDEX_FILE="$TMP_INDEX" git -C "$CREAL" add -A
    env GIT_INDEX_FILE="$TMP_INDEX" git -C "$CREAL" --no-pager diff --cached --binary artifact-test-baseline \
      > "$CDIR/changes.patch"
    env GIT_INDEX_FILE="$TMP_INDEX" git -C "$CREAL" --no-pager diff --cached --name-status artifact-test-baseline \
      > "$CDIR/changed-files.txt"
    env GIT_INDEX_FILE="$TMP_INDEX" git -C "$CREAL" --no-pager diff --cached --stat artifact-test-baseline \
      > "$CDIR/diff-stat.txt"

    (cd "$CREAL" && find . -type d -name .git -prune -o -printf '%y %10s %p\n' | sort) > "$CDIR/filesystem.txt"

    {
      printf '=== recent commits ===\n'
      git -C "$CREAL" --no-pager log --oneline -10
      printf '\n=== tags ===\n'
      git -C "$CREAL" tag -l
      printf '\n=== ignored/untracked paths (gitignore-excluded, names only) ===\n'
      cign_files="$(env GIT_OPTIONAL_LOCKS=0 git -C "$CREAL" ls-files --others --ignored --exclude-standard)"
      if [[ -n "$cign_files" ]]; then printf '%s\n' "$cign_files"; else printf 'none\n'; fi
    } > "$CDIR/inspection.txt"

    if [[ -z "$CSTATUS" ]]; then CSTATE="clean"; else CSTATE="dirty"; fi
    printf '%s | %s | %s | %s | %s | %s\n' "$sel" "$rel" "$CBASE" "$CHEAD" "$CBRANCH" "$CSTATE" \
      >> "$REV_DIR/INDEX.txt"
  done
fi

# Persist validated run-level records verbatim, as siblings of evidence/ —
# authorship stays separable from the machine-generated bundle. Every
# destination was preflighted above, so no existing record is overwritten.
if ((PROVIDED_PROVENANCE)); then
  cp -- "$PROV_SRC" "$OUT/provenance.txt"
fi
if ((PROVIDED_VERIFICATION)); then
  mkdir -p -- "$OUT/verification"
  cp -a -- "$VER_SRC/." "$OUT/verification/"
fi
if ((PROVIDED_READS)); then
  cp -- "$READS_SRC" "$OUT/observed-reads.txt"
fi

printf 'Captured evidence: %s\n' "$EV"
if ((PROVIDED_PROVENANCE)); then
  printf 'Run provenance: %s\n' "$OUT/provenance.txt"
fi
if ((PROVIDED_VERIFICATION)); then
  printf 'Verification output: %s\n' "$OUT/verification"
fi
if ((PROVIDED_READS)); then
  printf 'Observed reads: %s\n' "$OUT/observed-reads.txt"
fi
printf 'Agent-authored report goes to: %s\n' "$OUT/REPORT.md"
