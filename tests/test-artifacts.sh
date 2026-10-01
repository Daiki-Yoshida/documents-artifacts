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
```text
Fenced example containing `NOT_A_ROUTE.md` — never a route.
```
EOF
printf 'a -> `b.md`\n' > "$MINI/a.md"
printf 'b -> `a.md`\n' > "$MINI/b.md"
"$ROUTE_CHECK" "$MINI" >"$TMP_ROOT/mini.log" 2>&1 \
    || { cat "$TMP_ROOT/mini.log"; fail "valid mini pack rejected"; }
grep -Fq '3 reachable' "$TMP_ROOT/mini.log" \
    || fail "mini pack cycle/indirect reachability miscounted"

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
printf 'PASS: artifacts.sh Artifact v2 whole-pack sync/remove\n'
