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

printf 'PASS: artifacts.sh Artifact v2 whole-pack sync/remove\n'
