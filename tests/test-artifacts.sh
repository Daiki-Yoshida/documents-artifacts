#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCRIPT="${REPO_ROOT}/artifacts.sh"

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

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TMP_ROOT"' EXIT

SOURCE="${TMP_ROOT}/source"
TARGET="${TMP_ROOT}/target"
mkdir -p \
  "${SOURCE}/artifacts/design-principles" \
  "${SOURCE}/artifacts/documentation-strategy" \
  "${SOURCE}/artifacts/development-environment-strategy" \
  "$TARGET"
cp "$SCRIPT" "${SOURCE}/artifacts.sh"
chmod +x "${SOURCE}/artifacts.sh"

printf 'design-v1\n' > "${SOURCE}/artifacts/design-principles/design.md"
printf 'docs-v1\n' > "${SOURCE}/artifacts/documentation-strategy/docs.md"
printf 'env-v1\n' > "${SOURCE}/artifacts/development-environment-strategy/env.md"

# Selective install: unselected modules must not appear.
"${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --modules design-principles,documentation-strategy \
  --non-interactive >/dev/null
assert_file "${TARGET}/documents/artifacts/design-principles/design.md"
assert_file "${TARGET}/documents/artifacts/documentation-strategy/docs.md"
assert_absent "${TARGET}/documents/artifacts/development-environment-strategy"

# Updating one module replaces that module exactly, removing stale files only there.
printf 'stale\n' > "${TARGET}/documents/artifacts/design-principles/stale.md"
printf 'design-v2\n' > "${SOURCE}/artifacts/design-principles/design.md"
"${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --modules design-principles \
  --non-interactive >/dev/null
[[ "$(cat "${TARGET}/documents/artifacts/design-principles/design.md")" == "design-v2" ]] \
  || fail "updated module content did not change"
assert_absent "${TARGET}/documents/artifacts/design-principles/stale.md"
assert_file "${TARGET}/documents/artifacts/documentation-strategy/docs.md"

# Omitting an installed module from --modules must NOT remove it.
"${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --modules design-principles \
  --non-interactive >/dev/null
assert_file "${TARGET}/documents/artifacts/documentation-strategy/docs.md"

# Removal is explicit.
"${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --remove documentation-strategy \
  --non-interactive >/dev/null
assert_absent "${TARGET}/documents/artifacts/documentation-strategy"

# Invalid module names fail.
if "${SOURCE}/artifacts.sh" --target "$TARGET" --modules unknown --non-interactive >/dev/null 2>&1; then
  fail "unknown module unexpectedly succeeded"
fi

# Non-interactive mode with no requested operation fails.
if "${SOURCE}/artifacts.sh" --target "$TARGET" --non-interactive >/dev/null 2>&1; then
  fail "empty non-interactive run unexpectedly succeeded"
fi

# Installing and removing the same module in one run fails.
if "${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --modules design-principles \
  --remove design-principles \
  --non-interactive >/dev/null 2>&1; then
  fail "conflicting install/remove unexpectedly succeeded"
fi

# Destination module symlinks are rejected instead of followed/replaced.
mkdir -p "${TMP_ROOT}/outside"
ln -s "${TMP_ROOT}/outside" "${TARGET}/documents/artifacts/development-environment-strategy"
if "${SOURCE}/artifacts.sh" \
  --target "$TARGET" \
  --modules development-environment-strategy \
  --non-interactive >/dev/null 2>&1; then
  fail "symlinked destination unexpectedly succeeded"
fi
assert_absent "${TMP_ROOT}/outside/env.md"

# --list is stable and discovers module directories rather than hard-coding them.
LIST_OUTPUT="$("${SOURCE}/artifacts.sh" --list)"
grep -qx 'design-principles' <<< "$LIST_OUTPUT" || fail "design-principles missing from --list"
grep -qx 'documentation-strategy' <<< "$LIST_OUTPUT" || fail "documentation-strategy missing from --list"
grep -qx 'development-environment-strategy' <<< "$LIST_OUTPUT" || fail "development-environment-strategy missing from --list"

printf 'PASS: artifacts.sh\n'
