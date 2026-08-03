#!/bin/bash

set -euo pipefail

SCRIPT_UNDER_TEST="${1:-$(cd "$(dirname "$0")/.." && pwd)/copy-all-artifacts.sh}"
TEST_ROOT="$(mktemp -d)"
cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

fail() {
  echo "TEST FAILED: $*" >&2
  exit 1
}

assert_file_content() {
  local expected="$1"
  local path="$2"

  [ -f "$path" ] || fail "missing file: $path"
  [ "$(cat "$path")" = "$expected" ] || fail "unexpected content: $path"
}

WORKSPACE="$TEST_ROOT/workspace"
DESTINATION="$TEST_ROOT/destination"
mkdir -p "$WORKSPACE" "$DESTINATION/design-principles"
cp "$SCRIPT_UNDER_TEST" "$WORKSPACE/copy-all-artifacts.sh"

projects=(
  "design-principles"
  "documentation-strategy"
  "development-environment-strategy"
)

for project in "${projects[@]}"; do
  mkdir -p "$WORKSPACE/$project/artifacts"
  printf '%s-v1\n' "$project" > "$WORKSPACE/$project/artifacts/INDEX.md"
done

# Bootstrap must preserve files that were not distributed by the script.
printf 'legacy\n' > "$DESTINATION/design-principles/LEGACY.md"
bash "$WORKSPACE/copy-all-artifacts.sh" "$DESTINATION" >/dev/null

assert_file_content "design-principles-v1" "$DESTINATION/design-principles/INDEX.md"
assert_file_content "legacy" "$DESTINATION/design-principles/LEGACY.md"
grep -qx 'design-principles/INDEX.md' "$DESTINATION/.documents-artifacts-manifest" \
  || fail "manifest missing design-principles entry"

# A later sync updates changed files, adds new files, removes obsolete managed
# files, and leaves destination-owned files untouched.
printf 'design-principles-v2\n' > "$WORKSPACE/design-principles/artifacts/INDEX.md"
printf 'new-file\n' > "$WORKSPACE/development-environment-strategy/artifacts/NEW.md"
rm "$WORKSPACE/documentation-strategy/artifacts/INDEX.md"
printf 'documentation-v2\n' > "$WORKSPACE/documentation-strategy/artifacts/GUIDE.md"
printf 'custom\n' > "$DESTINATION/design-principles/CUSTOM.md"

bash "$WORKSPACE/copy-all-artifacts.sh" "$DESTINATION" >/dev/null

assert_file_content "design-principles-v2" "$DESTINATION/design-principles/INDEX.md"
assert_file_content "new-file" "$DESTINATION/development-environment-strategy/NEW.md"
assert_file_content "documentation-v2" "$DESTINATION/documentation-strategy/GUIDE.md"
assert_file_content "custom" "$DESTINATION/design-principles/CUSTOM.md"
[ ! -e "$DESTINATION/documentation-strategy/INDEX.md" ] \
  || fail "obsolete managed file was not removed"

# Missing source input must fail during preflight, before any destination file
# is changed.
before="$(cat "$DESTINATION/design-principles/INDEX.md")"
rm -rf "$WORKSPACE/documentation-strategy/artifacts"
printf 'should-not-copy\n' > "$WORKSPACE/design-principles/artifacts/INDEX.md"

if bash "$WORKSPACE/copy-all-artifacts.sh" "$DESTINATION" >/dev/null 2>&1; then
  fail "preflight should fail when a source artifacts directory is missing"
fi

assert_file_content "$before" "$DESTINATION/design-principles/INDEX.md"

# Re-running the same sources must be idempotent: no added/updated/removed,
# all files unchanged, and the manifest stable. Restore the workspace to match
# the last successful sync state (the preflight test mutated sources).
mkdir -p "$WORKSPACE/documentation-strategy/artifacts"
printf 'documentation-v2\n' > "$WORKSPACE/documentation-strategy/artifacts/GUIDE.md"
printf 'design-principles-v2\n' > "$WORKSPACE/design-principles/artifacts/INDEX.md"

output="$(bash "$WORKSPACE/copy-all-artifacts.sh" "$DESTINATION" 2>/dev/null)"
case "$output" in
  *added=0*updated=0*unchanged=*removed=0*) ;;
  *) fail "idempotent re-run should report no added/updated/removed: $output" ;;
esac

# Unsafe manifest entries must be rejected before any destination mutation.
# The public contract (manifest path, CLI, semantics) is unchanged; this only
# exercises the existing preflight rejection for path-traversal entries.
DEST_UNSAFE="$TEST_ROOT/unsafe-dest"
mkdir -p "$DEST_UNSAFE/design-principles"
printf '# documents-artifacts manifest v1\n../../../etc/passwd\n' \
  > "$DEST_UNSAFE/.documents-artifacts-manifest"
if bash "$WORKSPACE/copy-all-artifacts.sh" "$DEST_UNSAFE" >/dev/null 2>&1; then
  fail "unsafe manifest entry (path traversal) must be rejected"
fi

# A manifest path that is a symbolic link must be rejected.
DEST_MLINK="$TEST_ROOT/mlink-dest"
mkdir -p "$DEST_MLINK/design-principles"
ln -s /tmp/da-test-should-not-exist "$DEST_MLINK/.documents-artifacts-manifest"
if bash "$WORKSPACE/copy-all-artifacts.sh" "$DEST_MLINK" >/dev/null 2>&1; then
  fail "manifest path that is a symbolic link must be rejected"
fi

# A managed target that is a symbolic link must be rejected.
DEST_TLINK="$TEST_ROOT/tlink-dest"
mkdir -p "$DEST_TLINK/design-principles"
ln -s /tmp/da-test-should-not-exist "$DEST_TLINK/design-principles/INDEX.md"
if bash "$WORKSPACE/copy-all-artifacts.sh" "$DEST_TLINK" >/dev/null 2>&1; then
  fail "managed target that is a symbolic link must be rejected"
fi

echo "PASS: copy-all-artifacts managed sync"
