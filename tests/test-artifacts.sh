#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/.." && pwd -P)"
SCRIPT="$REPO_ROOT/artifacts.sh"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "expected file: $1"
}

assert_absent() {
  [[ ! -e "$1" && ! -L "$1" ]] || fail "expected path to be absent: $1"
}

bash -n "$SCRIPT" || fail "artifacts.sh syntax check failed"

ROUTE_CHECK="$REPO_ROOT/tests/scripts/check-artifact-routes.sh"
bash -n "$ROUTE_CHECK" || fail "check-artifact-routes.sh syntax check failed"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TMP_ROOT"' EXIT

SOURCE="$TMP_ROOT/source"
TARGET="$TMP_ROOT/target"
mkdir -p "$SOURCE/artifacts/design" "$SOURCE/artifacts/implementation" "$TARGET"
cp "$SCRIPT" "$SOURCE/artifacts.sh"
chmod +x "$SOURCE/artifacts.sh"

printf '# router-v1\n' > "$SOURCE/artifacts/INDEX.md"
printf 'design-v1\n' > "$SOURCE/artifacts/design/CONTRACTS.md"
printf 'implementation-v1\n' > "$SOURCE/artifacts/implementation/DEPENDENCIES.md"

# Whole-pack sync installs every artifact file.
"$SOURCE/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null
assert_file "$TARGET/documents/artifacts/INDEX.md"
assert_file "$TARGET/documents/artifacts/design/CONTRACTS.md"
assert_file "$TARGET/documents/artifacts/implementation/DEPENDENCIES.md"

# Exact replacement removes stale and legacy-module content under the managed root.
mkdir -p "$TARGET/documents/artifacts/design-principles"
printf 'stale\n' > "$TARGET/documents/artifacts/stale.md"
printf 'legacy\n' > "$TARGET/documents/artifacts/design-principles/legacy.md"
printf 'project-owned\n' > "$TARGET/documents/project-owned.md"
printf 'design-v2\n' > "$SOURCE/artifacts/design/CONTRACTS.md"

"$SOURCE/artifacts.sh" --target "$TARGET" --sync --non-interactive >/dev/null
[[ "$(cat "$TARGET/documents/artifacts/design/CONTRACTS.md")" == "design-v2" ]]   || fail "synced artifact content did not update"
assert_absent "$TARGET/documents/artifacts/stale.md"
assert_absent "$TARGET/documents/artifacts/design-principles"
assert_file "$TARGET/documents/project-owned.md"

# --list reports the complete source pack by relative file path.
LIST_OUTPUT="$("$SOURCE/artifacts.sh" --list)"
grep -qx 'INDEX.md' <<< "$LIST_OUTPUT" || fail "root INDEX missing from --list"
grep -qx 'design/CONTRACTS.md' <<< "$LIST_OUTPUT" || fail "design artifact missing from --list"
grep -qx 'implementation/DEPENDENCIES.md' <<< "$LIST_OUTPUT" || fail "implementation artifact missing from --list"

# Legacy partial-install interface is intentionally rejected.
if "$SOURCE/artifacts.sh" --target "$TARGET" --modules design-principles --non-interactive >/dev/null 2>&1; then
  fail "legacy --modules unexpectedly succeeded"
fi

# Conflicting actions fail.
if "$SOURCE/artifacts.sh" --target "$TARGET" --sync --remove --non-interactive >/dev/null 2>&1; then
  fail "conflicting sync/remove unexpectedly succeeded"
fi

# Destination symlinks are rejected and never followed.
rm -rf "$TARGET/documents/artifacts"
mkdir -p "$TMP_ROOT/outside"
ln -s "$TMP_ROOT/outside" "$TARGET/documents/artifacts"
if "$SOURCE/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null 2>&1; then
  fail "symlinked destination unexpectedly succeeded"
fi
assert_absent "$TMP_ROOT/outside/INDEX.md"
rm "$TARGET/documents/artifacts"

# Sync again, then explicit whole-pack removal removes only the managed root.
"$SOURCE/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null
"$SOURCE/artifacts.sh" --target "$TARGET" --remove --non-interactive >/dev/null
assert_absent "$TARGET/documents/artifacts"
assert_file "$TARGET/documents/project-owned.md"

# Source pack symlinks are rejected.
ln -s "$SOURCE/artifacts/design/CONTRACTS.md" "$SOURCE/artifacts/design/link.md"
if "$SOURCE/artifacts.sh" --list >/dev/null 2>&1; then
  fail "symlinked source pack unexpectedly succeeded"
fi

# Advertised runtime routes: every inline-backtick .md path that is not
# a declared project-owned example must resolve inside the pack, and
# every pack file must be transitively reachable from INDEX.md.
# Mechanical validity only — not evidence of meaningful routing or reads.
"$ROUTE_CHECK" "$REPO_ROOT/artifacts" >/dev/null \
    || fail "shipped pack route check failed"

PACK_BROKEN="$TMP_ROOT/pack-broken"
cp -r "$REPO_ROOT/artifacts" "$PACK_BROKEN"
sed -i 's|implementation/TESTING\.md|implmentation/TESTING.md|' \
    "$PACK_BROKEN/INDEX.md"
"$ROUTE_CHECK" "$PACK_BROKEN" >"$TMP_ROOT/broken.log" 2>&1 \
    && fail "route check accepted a broken inline route"
grep -Fq 'BROKEN: INDEX.md -> implmentation/TESTING.md' "$TMP_ROOT/broken.log" \
    || fail "broken route not reported with source and target"

# An inner-router entry removal must orphan its leaf even though the
# root INDEX and router file still exist and link fine.
PACK_ORPHAN="$TMP_ROOT/pack-orphan"
cp -r "$REPO_ROOT/artifacts" "$PACK_ORPHAN"
sed -i '/SCOPE_AND_AUTHORITY\.md/d' "$PACK_ORPHAN/operation/INDEX.md"
"$ROUTE_CHECK" "$PACK_ORPHAN" >"$TMP_ROOT/orphan.log" 2>&1 \
    && fail "route check accepted an orphaned leaf"
grep -Fq 'UNREACHABLE: operation/SCOPE_AND_AUTHORITY.md' "$TMP_ROOT/orphan.log" \
    || fail "orphaned leaf not reported as unreachable"

# Issue #143 review regressions — classification boundaries on a
# minimal synthetic pack (fences, prose, bare-vs-prefixed examples,
# cycles):
MINI="$TMP_ROOT/pack-mini"
mkdir -p "$MINI"
cat > "$MINI/INDEX.md" <<'EOF'
# mini pack root
Route: `a.md` — see also prose token `input/output` (not a route).
Project example with fragment: `AGENTS.md#review` is not a route.
Placeholder and glob examples: `<dir>/LEAF.md`, `files/*.md`.
```text
Fenced example containing `NOT_A_ROUTE.md` — never a route.
```
~~~text
Tilde fence containing `TILDE_HIDDEN.md` — never a route.
~~~
````
Longer fence containing ``` shorter markers ``` and
`LONGER_HIDDEN.md` — never a route.
````
EOF
printf 'a -> `b.md`\n' > "$MINI/a.md"
printf 'b -> `a.md`\n' > "$MINI/b.md"
"$ROUTE_CHECK" "$MINI" >"$TMP_ROOT/mini.log" 2>&1 \
    || { cat "$TMP_ROOT/mini.log"; fail "valid mini pack rejected"; }
grep -Fq '3 reachable' "$TMP_ROOT/mini.log" \
    || fail "mini pack cycle/indirect reachability miscounted"

# an inline (unanchored) fence-marker mention must NOT suppress the
# broken route that follows it
MINI_NEG="$TMP_ROOT/pack-mini-neg"
mkdir -p "$MINI_NEG"
cat > "$MINI_NEG/INDEX.md" <<'EOF'
# neg pack
Prose mentions the ``` marker inline — that is not a fence.
Route: `MISSING.md` must be reported.
EOF
"$ROUTE_CHECK" "$MINI_NEG" >"$TMP_ROOT/mini-neg.log" 2>&1 \
    && fail "inline fence mention hid a broken advertised route"
grep -Fq 'BROKEN: INDEX.md -> MISSING.md' "$TMP_ROOT/mini-neg.log" \
    || fail "broken route after inline fence prose not reported"

# directory-prefixed entry names are advertised routes, not examples:
# nonexistent `implementation/README.md` fails BROKEN ...
MINI_BROKEN="$TMP_ROOT/pack-mini-broken"
cp -r "$MINI" "$MINI_BROKEN"
mkdir -p "$MINI_BROKEN/implementation"
printf 'ref: `implementation/README.md`\n' >> "$MINI_BROKEN/INDEX.md"
"$ROUTE_CHECK" "$MINI_BROKEN" >"$TMP_ROOT/mini-broken.log" 2>&1 \
    && fail "route check hid a missing directory-prefixed README"
grep -Fq 'BROKEN: INDEX.md -> implementation/README.md' \
    "$TMP_ROOT/mini-broken.log" \
    || fail "dir-prefixed README not reported as advertised route"

# ... and a real one becomes a reachable edge (never UNREACHABLE)
printf '# impl readme\n' > "$MINI_BROKEN/implementation/README.md"
"$ROUTE_CHECK" "$MINI_BROKEN" >"$TMP_ROOT/mini-real.log" 2>&1 \
    || { cat "$TMP_ROOT/mini-real.log"; fail "real dir-prefixed README rejected"; }
grep -Fq '4 reachable' "$TMP_ROOT/mini-real.log" \
    || fail "real dir-prefixed README not counted reachable"

# Legitimate project-owned example tokens and valid indirect routing
# stay accepted: the shipped pack exercises both.

# --- Remote delivery (Issue #146) -----------------------------------------
# Run the exact README bootstrap command against local Git fixtures, so
# no regression depends solely on GitHub availability.
command -v git >/dev/null || fail "git is required for remote-delivery tests"

README_BOOTSTRAP="$TMP_ROOT/readme-bootstrap.sh"
awk '/<!-- remote-delivery-snippet -->/{f=1;next} /<!-- \/remote-delivery-snippet -->/{f=0} f' \
    "$REPO_ROOT/README.md" \
  | awk '/^```bash$/{c=1;next} /^```$/{if(c)exit} c' \
  > "$README_BOOTSTRAP"
[[ -s "$README_BOOTSTRAP" ]] || fail "README remote-delivery snippet not found"
bash -n "$README_BOOTSTRAP" || fail "README bootstrap snippet has a syntax error"

BOOT_TMP="$TMP_ROOT/boot-tmp"
mkdir -p "$BOOT_TMP"

assert_tmp_clean() {
  [[ -z "$(ls -A "$BOOT_TMP")" ]] || fail "bootstrap temp not cleaned: $*"
}

run_bootstrap() {
  # $1 = target dir; $2 = source repo override (empty = documented default)
  local tdir="$1" url="${2:-}"
  if [[ -n "$url" ]]; then
    ( cd -- "$tdir" && TMPDIR="$BOOT_TMP" ARTIFACT_SOURCE_REPO="$url" bash "$README_BOOTSTRAP" )
  else
    ( cd -- "$tdir" && TMPDIR="$BOOT_TMP" GIT_TERMINAL_PROMPT=0 \
        env -u ARTIFACT_SOURCE_REPO bash "$README_BOOTSTRAP" )
  fi
}

# Fixture "remote": a standalone Git repo holding artifacts.sh + the real pack.
GIT_REMOTE="$TMP_ROOT/git-remote"
mkdir -p "$GIT_REMOTE"
cp "$SCRIPT" "$GIT_REMOTE/artifacts.sh"
chmod +x "$GIT_REMOTE/artifacts.sh"
cp -r "$REPO_ROOT/artifacts" "$GIT_REMOTE/artifacts"
git -C "$GIT_REMOTE" -c init.defaultBranch=main init -q
git -C "$GIT_REMOTE" add -A
git -C "$GIT_REMOTE" \
    -c user.email=test@example.com -c user.name=test \
    commit -qm 'pack v1'

# First install into a fresh target whose path contains spaces; the
# target defaults to the current directory. Project-owned files exist.
RTARGET="$TMP_ROOT/remote target with spaces"
mkdir -p "$RTARGET/documents/project"
printf 'project agents\n' > "$RTARGET/AGENTS.md"
printf 'project readme\n' > "$RTARGET/README.md"
printf 'project index\n' > "$RTARGET/documents/INDEX.md"
printf 'owner doc\n'      > "$RTARGET/documents/project/OWNERS.md"

run_bootstrap "$RTARGET" "file://$GIT_REMOTE" >/dev/null \
    || fail "remote-delivery first install failed"
assert_file "$RTARGET/documents/artifacts/INDEX.md"
assert_file "$RTARGET/documents/artifacts/implementation/TESTING.md"
assert_tmp_clean "after first install"

# Only artifacts/ contents may reach the target: no source .git, no
# artifacts.sh copy, no source-only docs.
assert_absent "$RTARGET/artifacts.sh"
assert_absent "$RTARGET/artifacts"
assert_absent "$RTARGET/documents/knowledge"
if find "$RTARGET" -name '.git' -print -quit | grep -q .; then
  fail "source .git reached target"
fi
[[ -z "$(find "$RTARGET/documents" -name '.artifacts.*' -print -quit)" ]] \
    || fail "stage residue left in target documents"

# Update: the remote moves forward; a stale managed file is removed and
# project-owned files stay untouched.
printf 'stale\n' > "$RTARGET/documents/artifacts/STALE.md"
printf 'testing-v2\n' > "$GIT_REMOTE/artifacts/implementation/TESTING.md"
git -C "$GIT_REMOTE" \
    -c user.email=test@example.com -c user.name=test \
    commit -qam 'pack v2'

run_bootstrap "$RTARGET" "file://$GIT_REMOTE" >/dev/null \
    || fail "remote-delivery update failed"
[[ "$(cat "$RTARGET/documents/artifacts/implementation/TESTING.md")" == "testing-v2" ]] \
    || fail "remote update did not apply new pack content"
assert_absent "$RTARGET/documents/artifacts/STALE.md"
assert_tmp_clean "after update"

[[ "$(cat "$RTARGET/AGENTS.md")" == "project agents" ]] || fail "AGENTS.md changed"
[[ "$(cat "$RTARGET/README.md")" == "project readme" ]] || fail "target README.md changed"
[[ "$(cat "$RTARGET/documents/INDEX.md")" == "project index" ]] || fail "documents/INDEX.md changed"
[[ "$(cat "$RTARGET/documents/project/OWNERS.md")" == "owner doc" ]] || fail "owner doc changed"

# Failed fetch leaves the installed pack unchanged and cleans the temp dir.
pack_state() { find "$1/documents/artifacts" -type f -printf '%P %s\n' | LC_ALL=C sort; }
BEFORE="$(pack_state "$RTARGET")"
if run_bootstrap "$RTARGET" "file://$TMP_ROOT/missing-remote" >/dev/null 2>&1; then
  fail "unreachable remote unexpectedly succeeded"
fi
[[ "$BEFORE" == "$(pack_state "$RTARGET")" ]] \
    || fail "failed fetch changed the installed pack"
assert_tmp_clean "after failed fetch"

# A fetchable source whose pack fails validation also leaves the target
# unchanged (validation finishes before managed replacement).
BAD_REMOTE="$TMP_ROOT/git-bad-remote"
mkdir -p "$BAD_REMOTE/artifacts"
cp "$SCRIPT" "$BAD_REMOTE/artifacts.sh"
printf '# bad\n' > "$BAD_REMOTE/artifacts/INDEX.md"
ln -s INDEX.md "$BAD_REMOTE/artifacts/link.md"
git -C "$BAD_REMOTE" -c init.defaultBranch=main init -q
git -C "$BAD_REMOTE" add -A
git -C "$BAD_REMOTE" \
    -c user.email=test@example.com -c user.name=test \
    commit -qm 'invalid pack'
if run_bootstrap "$RTARGET" "file://$BAD_REMOTE" >/dev/null 2>&1; then
  fail "invalid source pack unexpectedly succeeded"
fi
[[ "$BEFORE" == "$(pack_state "$RTARGET")" ]] \
    || fail "invalid source changed the installed pack"
assert_tmp_clean "after invalid source"

# Live probe: the documented default command performs an actual
# GitHub-main acquisition into a disposable target. Distinguish blocked
# egress from a passing run — never silently pass.
LIVE_TARGET="$TMP_ROOT/live-target"
mkdir -p "$LIVE_TARGET"
if timeout 180 bash -c 'cd -- "$1" && TMPDIR="$2" GIT_TERMINAL_PROMPT=0 \
    env -u ARTIFACT_SOURCE_REPO bash "$3"' \
    _ "$LIVE_TARGET" "$BOOT_TMP" "$README_BOOTSTRAP" >/dev/null 2>&1; then
  assert_file "$LIVE_TARGET/documents/artifacts/INDEX.md"
  assert_tmp_clean "after live acquisition"
  printf 'NOTE: live GitHub main acquisition verified\n'
elif timeout 30 git ls-remote \
    https://github.com/Daiki-Yoshida/documents-artifacts.git HEAD \
    >/dev/null 2>&1; then
  fail "live acquisition failed while the GitHub repo is reachable"
else
  printf 'SKIP: live GitHub probe blocked (egress unavailable); fixture coverage passed\n'
fi

printf 'PASS: artifacts.sh Artifact v2 whole-pack sync/remove\n'
