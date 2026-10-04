#!/bin/sh
# Final bootstrap gate for this multi-repository workspace. Deterministic:
# reads only repository files and Git state — no network, no timestamps.
set -eu
cd "$(dirname "$0")/.."
root=$(pwd -P)

WORK="${1:-}"
failed=0
pass() { printf 'verify: PASS — %s\n' "$1"; }
fail() { printf 'verify: FAIL — %s\n' "$1" >&2; failed=1; }

case "$WORK" in
  */*) ;;
  *)
    echo "verify: FAIL — usage: scripts/verify-workspace.sh <work-type>/<work-name>" >&2
    exit 1
    ;;
esac

is_registered_worktree() {
  # $1 = owning repository path, $2 = worktree directory
  [ -d "$2" ] || return 1
  wt_abs=$(cd "$2" && pwd -P)
  found=$(
    git -C "$1" worktree list --porcelain | sed -n 's/^worktree //p' | \
    while IFS= read -r p; do
      if [ -d "$p" ] && [ "$(cd "$p" && pwd -P)" = "$wt_abs" ]; then
        echo yes
        break
      fi
    done
  )
  [ "$found" = "yes" ]
}

# 1. Component Repository primary checkouts: mapped under the Project
#    Root, independently owned, never tracked by this repository.
found=0
while IFS='=' read -r sel rel; do
  case "$sel" in ''|\#*) continue ;; esac
  sel=$(printf '%s' "$sel" | tr -d '[:space:]')
  rel=$(printf '%s' "$rel" | tr -d '[:space:]')
  [ -n "$sel" ] && [ -n "$rel" ] || continue
  found=$((found + 1))

  case "$rel" in
    /*|*..*|.*)
      fail "component '$sel' maps to a path outside the Project Root: $rel"
      continue
      ;;
  esac

  if [ ! -d "$rel" ]; then
    fail "component '$sel' primary checkout missing at $rel"
    continue
  fi
  if ! git -C "$rel" rev-parse -q --verify HEAD >/dev/null 2>&1; then
    fail "component '$sel' at $rel is not a usable Git checkout"
    continue
  fi
  pass "component '$sel' primary checkout exists at $rel"

  # independent repository — not a linked worktree of another repository
  common_dir=$(cd "$rel" && git rev-parse --git-common-dir)
  common_abs=$(cd "$rel" && cd "$common_dir" && pwd -P)
  checkout_abs=$(cd "$rel" && pwd -P)
  case "$common_abs" in
    "$checkout_abs"/.git)
      pass "component '$sel' is an independent Git repository"
      ;;
    *)
      fail "component '$sel' checkout at $rel is not an independent Git repository"
      ;;
  esac

  if [ -z "$(git -C "$rel" status --porcelain)" ]; then
    pass "component '$sel' primary checkout is clean"
  else
    fail "component '$sel' primary checkout is dirty"
  fi

  # ownership: the Management Root Repository must not track component source
  if [ -n "$(git ls-files -- "$rel" "$rel/")" ]; then
    fail "Management Root Repository tracks component source under $rel"
  else
    pass "component '$sel' source is not tracked by the Management Root Repository"
  fi
done < workspace/repositories.conf

[ "$found" -gt 0 ] || {
  echo "verify: FAIL — no components declared in workspace/repositories.conf" >&2
  exit 1
}

# 2. Work Root and registered Work worktrees for the confirmed Work Identity
work_root=".worktrees/$WORK"
[ -d "$work_root" ] || fail "Work Root missing: $work_root"
if [ -d "$work_root/documents" ] && [ -n "$(git ls-files -- "$work_root/documents/")" ]; then
  pass "Work Documents tracked under $work_root/documents/"
else
  fail "Work Documents missing or untracked under $work_root/documents/"
fi

check_worktree() {
  # $1 = owning repository path, $2 = worktree path, $3 = label
  if [ ! -d "$2" ]; then
    fail "$3 worktree missing at $2"
    return
  fi
  if ! is_registered_worktree "$1" "$2"; then
    fail "$3 worktree at $2 is not a registered Git worktree of its owning repository"
    return
  fi
  pass "$3 worktree registered at $2"
  if [ "$(git -C "$2" branch --show-current)" = "$WORK" ]; then
    pass "$3 worktree branch = $WORK"
  else
    fail "$3 worktree branch mismatch (want $WORK)"
  fi
  if [ -z "$(git -C "$2" status --porcelain)" ]; then
    pass "$3 worktree clean"
  else
    fail "$3 worktree is dirty"
  fi
}

# Management Root Repository worktree (stable selector: main)
check_worktree "$root" "$work_root/main" "management"
mgmt_wt="$work_root/main"
if [ -d "$mgmt_wt" ]; then
  if [ -e "$mgmt_wt/.worktrees" ]; then
    fail "management worktree materialized nested .worktrees/"
  else
    pass "management worktree has no nested .worktrees/"
  fi
  if git -C "$mgmt_wt" sparse-checkout list 2>/dev/null | grep -Fqx '!/.worktrees/'; then
    pass "management worktree sparse exclusion active"
  else
    fail "management worktree lacks the worktree-local sparse exclusion"
  fi
fi

# Component Repository worktrees (selectors from the workspace mapping)
while IFS='=' read -r sel rel; do
  case "$sel" in ''|\#*) continue ;; esac
  sel=$(printf '%s' "$sel" | tr -d '[:space:]')
  rel=$(printf '%s' "$rel" | tr -d '[:space:]')
  [ -n "$sel" ] && [ -n "$rel" ] || continue
  [ -d "$rel" ] || continue
  check_worktree "$root/$rel" "$work_root/$sel" "component '$sel'"
done < workspace/repositories.conf

[ "$failed" -eq 0 ] || exit 1
printf 'verify: PASS — workspace topology conforms for %s\n' "$WORK"
