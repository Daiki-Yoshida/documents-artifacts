#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/.." && pwd -P)"
PREPARE="$REPO_ROOT/tests/scripts/prepare-agent-test.sh"
RESET="$REPO_ROOT/tests/scripts/reset-agent-test.sh"
INSPECT="$REPO_ROOT/tests/scripts/inspect-agent-test.sh"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

for script in "$PREPARE" "$RESET" "$INSPECT"; do
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

  "$PREPARE" --scenario "$scenario" --force >/dev/null
  run_root="$REPO_ROOT/tests/.runs/$scenario"
  target="$run_root/repo"

  [[ -d "$target/.git" ]] || fail "prepared repo missing .git: $scenario"
  [[ -f "$run_root/PROMPT.md" ]] || fail "run prompt missing: $scenario"
  cmp -s "$prompt" "$run_root/PROMPT.md" || fail "run prompt differs from scenario prompt: $scenario"
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

  "$INSPECT" --scenario "$scenario" >/dev/null
  "$RESET" --scenario "$scenario" >/dev/null
  [[ ! -e "$run_root" ]] || fail "reset did not remove run: $scenario"
done

printf 'PASS: execution-agent harness fixtures and scenarios\n'
