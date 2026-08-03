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

echo "PASS: copy-all-artifacts managed sync"
