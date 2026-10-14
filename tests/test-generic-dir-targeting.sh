#!/usr/bin/env bash
set -euo pipefail

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
sandbox="$(mktemp -d)"
trap 'rm -rf -- "$sandbox"' EXIT
root="$sandbox/project"
mkdir -p "$root/scripts" "$root/config" "$root/components/api" "$root/components/game" \
  "$root/.worktrees/feat/alpha/documents" "$root/.worktrees/feat/beta/documents"
printf '%s\n' feat/alpha feat/beta > "$root/config/confirmed-works"
printf '%s\n' game project > "$root/config/repositories"
printf 'component\n' > "$root/components/game/.project-component"

cat > "$root/Makefile" <<'MAKE'
SHELL := /bin/sh
DIR ?=
.PHONY: docker-up docker-status docker-down generate test worktree-plan
docker-up docker-status docker-down generate test worktree-plan:
	@sh scripts/route.sh "$@" "$(DIR)"
MAKE

cat > "$root/scripts/route.sh" <<'ROUTE'
#!/bin/sh
set -eu
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
project="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)"
operation="$1"
dir="$2"
[ -n "$dir" ] || fail 'DIR required'
case "$dir" in /*) fail 'absolute target unsupported' ;; esac
case "/$dir/" in */../*) fail 'parent traversal forbidden' ;; esac

case "$operation" in
  docker-up|docker-status|docker-down|test)
    target="$(CDPATH= cd -- "$project/$dir" && pwd -P)" || fail 'existing directory required'
    case "$target/" in "$project/"*) ;; *) fail 'outside Project Root' ;; esac
    rel="$(printf '%s' "$target" | sed "s|^$project/||")"
    ;;
esac

case "$operation" in
  docker-up|docker-status|docker-down)
    printf '%s' "$rel" | grep -Eq '^\.worktrees/(feat|fix|refactor)/[a-z0-9-]+$' || fail 'Work Root required'
    work="$(printf '%s' "$rel" | cut -d/ -f2-3)"
    [ -d "$target/documents" ] || fail 'Work Documents missing'
    grep -Fxq -- "$work" "$project/config/confirmed-works" || fail 'Work not confirmed'
    slug="$(printf '%s' "$work" | tr / -)"
    state="$project/.runtime/project-$slug.state"
    case "$operation" in
      docker-up) mkdir -p "$project/.runtime"; printf 'work=%s\n' "$work" > "$state" ;;
      docker-status) [ -f "$state" ] || fail 'runtime absent'; grep -Fxq "work=$work" "$state" || fail 'identity mismatch' ;;
      docker-down) [ -f "$state" ] || fail 'runtime absent'; rm -- "$state" ;;
    esac
    ;;
  test)
    [ -f "$target/.project-component" ] || fail 'checkout required'
    ;;
  generate)
    # Creation accepts a missing final directory, but validates the ancestor.
    trimmed="$(printf '%s' "$dir" | sed 's:/*$::')"
    printf '%s' "$trimmed" | grep -Eq '^components/[a-z0-9-]+$' || fail 'component path required'
    parent="$(CDPATH= cd -- "$project/components" && pwd -P)"
    [ "$parent" = "$project/components" ] || fail 'component parent escaped'
    name="$(printf '%s' "$trimmed" | cut -d/ -f2)"
    dest="$parent/$name"
    [ ! -L "$dest" ] || fail 'symlink destination'
    if [ -e "$dest" ] && [ ! -d "$dest" ]; then fail 'collision'; fi
    mkdir -p "$dest"; printf 'generated\n' > "$dest/generated.txt"
    ;;
  worktree-plan)
    # This models preflight only; it never materializes a Git worktree.
    trimmed="$(printf '%s' "$dir" | sed 's:/*$::')"
    printf '%s' "$trimmed" | grep -Eq '^\.worktrees/(feat|fix|refactor)/[a-z0-9-]+/[a-z0-9-]+$' || fail 'repository-specific path required'
    work="$(printf '%s' "$trimmed" | cut -d/ -f2-3)"
    repo="$(printf '%s' "$trimmed" | cut -d/ -f4)"
    grep -Fxq -- "$work" "$project/config/confirmed-works" || fail 'Work not confirmed'
    grep -Fxq -- "$repo" "$project/config/repositories" || fail 'repository not mapped'
    parent="$(CDPATH= cd -- "$project/.worktrees/$work" && pwd -P)" || fail 'Work Root missing'
    [ "$parent" = "$project/.worktrees/$work" ] || fail 'Work Root escaped'
    [ -d "$parent/documents" ] || fail 'Work Documents missing'
    [ ! -e "$parent/$repo" ] && [ ! -L "$parent/$repo" ] || fail 'checkout collision'
    printf 'WORK=%s REPO=%s\n' "$work" "$repo"
    ;;
  *) fail 'unknown command' ;;
esac
ROUTE

must_fail() {
  if "$@" >"$sandbox/failure.log" 2>&1; then fail "unexpected success: $*"; fi
}
run() { make -s -C "$root" "$@"; }

run DIR=.worktrees/feat/alpha docker-up
run DIR=.worktrees/feat/alpha/ docker-status
run DIR=.worktrees/feat/beta docker-up
run DIR=.worktrees/feat/alpha docker-down
[ ! -e "$root/.runtime/project-feat-alpha.state" ] || fail 'wrong Work remained'
[ -f "$root/.runtime/project-feat-beta.state" ] || fail 'other Work removed'
must_fail run DIR=.worktrees/feat/alpha docker-status
must_fail run DIR=.worktrees/feat/alpha/documents docker-up
must_fail run DIR=.worktrees/feat/unknown docker-up
must_fail run DIR=.worktrees/feat/alpha/../../beta docker-up
must_fail run DIR="$sandbox" docker-up
ln -s "$sandbox" "$root/.worktrees/feat/outside"
must_fail run DIR=.worktrees/feat/outside docker-up

run DIR=components/game test
must_fail run DIR=components test
run DIR=components/api generate
[ -f "$root/components/api/generated.txt" ] || fail 'existing target generation'
[ ! -e "$root/components/new" ] || fail 'new target unexpectedly exists'
run DIR=components/new generate
[ -f "$root/components/new/generated.txt" ] || fail 'creation target missing'
must_fail run DIR=components/new/../../outside generate
ln -s "$sandbox" "$root/components/outside"
must_fail run DIR=components/outside generate

[ ! -e "$root/.worktrees/feat/alpha/game" ] || fail 'planned checkout existed'
plan="$(run DIR=.worktrees/feat/alpha/game/ worktree-plan)"
[ "$plan" = 'WORK=feat/alpha REPO=game' ] || fail 'incorrect resolved identity'
[ ! -e "$root/.worktrees/feat/alpha/game" ] || fail 'preflight materialized worktree'
must_fail run DIR=.worktrees/feat/alpha worktree-plan
must_fail run DIR=.worktrees/feat/alpha/unknown worktree-plan
must_fail run DIR=.worktrees/feat/unknown/game worktree-plan
ln -s "$sandbox" "$root/.worktrees/feat/alpha/project"
must_fail run DIR=.worktrees/feat/alpha/project worktree-plan
printf 'PASS: generic DIR command routing, creation targets, and scoped identities (simulated)\n'
