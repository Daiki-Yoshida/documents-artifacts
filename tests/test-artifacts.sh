#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$BASH_SOURCE")/.." && pwd -P)"
SCRIPT="$REPO_ROOT/artifacts.sh"
INSTALLER="$REPO_ROOT/install.sh"

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
sh -n "$INSTALLER" || fail "install.sh syntax check failed"

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

# --- Remote delivery bootstrap (Issues #146 / #160) ------------------------
# Run the exact README curl | sh command through a test-local curl shim.
# This verifies the public bootstrap without depending on external network.
command -v curl >/dev/null || fail "curl is required for remote-delivery tests"
command -v tar >/dev/null || fail "tar is required for remote-delivery tests"
command -v git >/dev/null || fail "git is required for remote-delivery target-state tests"

README_BOOTSTRAP="$TMP_ROOT/readme-bootstrap.sh"
awk '/<!-- remote-delivery-snippet -->/{f=1;next} /<!-- \/remote-delivery-snippet -->/{f=0} f' \
    "$REPO_ROOT/README.md" \
  | awk '/^```bash$/{c=1;next} /^```$/{if(c)exit} c' \
  > "$README_BOOTSTRAP"
[[ -s "$README_BOOTSTRAP" ]] || fail "README remote-delivery snippet not found"
sh -n "$README_BOOTSTRAP" || fail "README bootstrap snippet has a syntax error"
grep -Fqx 'curl -fsSL https://raw.githubusercontent.com/Daiki-Yoshida/documents-artifacts/main/install.sh | sh' \
  "$README_BOOTSTRAP" || fail "README bootstrap is not the canonical one-line curl installer"

BOOT_TMP="$TMP_ROOT/boot-tmp"
mkdir -p "$BOOT_TMP"

# Build a GitHub-archive-shaped local snapshot.
ARCHIVE_PARENT="$TMP_ROOT/archive-parent"
ARCHIVE_ROOT="$ARCHIVE_PARENT/documents-artifacts-main"
ARCHIVE_FILE="$TMP_ROOT/documents-artifacts-main.tar.gz"
mkdir -p "$ARCHIVE_ROOT"
cp "$SCRIPT" "$ARCHIVE_ROOT/artifacts.sh"
cp "$INSTALLER" "$ARCHIVE_ROOT/install.sh"
chmod +x "$ARCHIVE_ROOT/artifacts.sh"
cp -r "$REPO_ROOT/artifacts" "$ARCHIVE_ROOT/artifacts"

refresh_archive() {
  rm -f -- "$ARCHIVE_FILE"
  tar -czf "$ARCHIVE_FILE" -C "$ARCHIVE_PARENT" documents-artifacts-main
}
refresh_archive

# Test-local curl shim:
# - serves the raw install.sh URL to stdout;
# - serves the GitHub main archive to install.sh -o <path>;
# - can inject archive acquisition failure;
# - records requested URLs so wrong-root checks can prove no archive fetch.
REAL_CURL="$(command -v curl)"
SHIM_BIN="$TMP_ROOT/shim-bin"
mkdir -p "$SHIM_BIN"
cat > "$SHIM_BIN/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
out=""
url=""
while (($# > 0)); do
  case "$1" in
    -o|--output)
      (($# >= 2)) || exit 2
      out="$2"
      shift 2
      ;;
    -*)
      shift
      ;;
    *)
      url="$1"
      shift
      ;;
  esac
done
[[ -n "$url" ]] || exit 2
printf '%s\n' "$url" >> "${TEST_CURL_LOG:?TEST_CURL_LOG is required}"
case "$url" in
  https://raw.githubusercontent.com/Daiki-Yoshida/documents-artifacts/main/install.sh)
    src="${TEST_INSTALL_SOURCE:?TEST_INSTALL_SOURCE is required}"
    ;;
  https://github.com/Daiki-Yoshida/documents-artifacts/archive/refs/heads/main.tar.gz)
    [[ "${TEST_ARCHIVE_FAIL:-0}" != "1" ]] || exit 22
    src="${TEST_ARCHIVE_SOURCE:?TEST_ARCHIVE_SOURCE is required}"
    ;;
  *)
    printf 'unexpected curl URL: %s\n' "$url" >&2
    exit 22
    ;;
esac
if [[ -n "$out" ]]; then
  cp -- "$src" "$out"
else
  cat -- "$src"
fi
EOF
chmod +x "$SHIM_BIN/curl"

assert_tmp_clean() {
  [[ -z "$(ls -A "$BOOT_TMP")" ]] || fail "bootstrap temp not cleaned: $*"
}

CURL_LOG="$TMP_ROOT/curl.log"

run_bootstrap() {
  # $1 = target dir; optional env TEST_ARCHIVE_SOURCE/TEST_ARCHIVE_FAIL may specialize.
  local tdir="$1"
  : > "$CURL_LOG"
  (
    cd -- "$tdir"
    TMPDIR="$BOOT_TMP" \
    TEST_CURL_LOG="$CURL_LOG" \
    TEST_INSTALL_SOURCE="$INSTALLER" \
    TEST_ARCHIVE_SOURCE="${TEST_ARCHIVE_SOURCE:-$ARCHIVE_FILE}" \
    TEST_ARCHIVE_FAIL="${TEST_ARCHIVE_FAIL:-0}" \
    PATH="$SHIM_BIN:$PATH" \
      sh "$README_BOOTSTRAP"
  )
}

# Wrong root: documents/ is required and must not be created or followed.
NO_DOCS="$TMP_ROOT/no-documents-target"
mkdir -p "$NO_DOCS"
if run_bootstrap "$NO_DOCS" >"$TMP_ROOT/no-docs.log" 2>&1; then
  fail "bootstrap unexpectedly created/accepted missing documents directory"
fi
assert_absent "$NO_DOCS/documents"
grep -Fq './documents/ フォルダがありません。Project Rootで実行してください。' "$TMP_ROOT/no-docs.log" \
  || fail "missing-documents error lacks Japanese message"
grep -Fq './documents/ directory was not found. Run this command from the Project Root.' "$TMP_ROOT/no-docs.log" \
  || fail "missing-documents error lacks English message"
[[ "$(wc -l < "$CURL_LOG" | tr -d ' ')" == "1" ]] \
  || fail "missing-documents run fetched the source archive before failing"
assert_tmp_clean "after missing-documents refusal"

SYMLINK_TARGET="$TMP_ROOT/symlink-documents-target"
SYMLINK_OUTSIDE="$TMP_ROOT/symlink-documents-outside"
mkdir -p "$SYMLINK_TARGET" "$SYMLINK_OUTSIDE"
ln -s "$SYMLINK_OUTSIDE" "$SYMLINK_TARGET/documents"
if run_bootstrap "$SYMLINK_TARGET" >"$TMP_ROOT/symlink-docs.log" 2>&1; then
  fail "bootstrap unexpectedly accepted symlinked documents directory"
fi
grep -Fq './documents/ がsymlinkです。' "$TMP_ROOT/symlink-docs.log" \
  || fail "symlink refusal lacks Japanese message"
grep -Fq './documents/ is a symlink.' "$TMP_ROOT/symlink-docs.log" \
  || fail "symlink refusal lacks English message"
assert_absent "$SYMLINK_OUTSIDE/artifacts"
assert_tmp_clean "after symlink refusal"

# First install into a target whose path contains spaces. documents/ already
# exists and contains project-owned state; bootstrap must preserve it.
RTARGET="$TMP_ROOT/remote target with spaces"
mkdir -p "$RTARGET/documents/project"
printf 'project agents\n' > "$RTARGET/AGENTS.md"
printf 'project readme\n' > "$RTARGET/README.md"
printf 'project index\n' > "$RTARGET/documents/INDEX.md"
printf 'owner doc\n' > "$RTARGET/documents/project/OWNERS.md"
git -C "$RTARGET" -c init.defaultBranch=main init -q
git -C "$RTARGET" add -A
git -C "$RTARGET" \
    -c user.email=test@example.com -c user.name=test \
    commit -qm 'owner baseline'
OWNER_HEAD="$(git -C "$RTARGET" rev-parse HEAD)"

assert_owner_head() {
  [[ "$(git -C "$RTARGET" rev-parse HEAD)" == "$OWNER_HEAD" ]] \
    || fail "target commit history changed: $*"
}

run_bootstrap "$RTARGET" >"$TMP_ROOT/install.log" 2>&1 \
  || { cat "$TMP_ROOT/install.log"; fail "curl bootstrap first install failed"; }
assert_file "$RTARGET/documents/artifacts/INDEX.md"
assert_file "$RTARGET/documents/artifacts/implementation/TESTING.md"
assert_tmp_clean "after first install"
grep -Fq '[INFO] Project Rootを確認しました:' "$TMP_ROOT/install.log" \
  || fail "success log lacks Japanese Project Root status"
grep -Fq 'Project Root detected:' "$TMP_ROOT/install.log" \
  || fail "success log lacks English Project Root status"
grep -Fq '[OK] Artifact v2を同期しました:' "$TMP_ROOT/install.log" \
  || fail "success log lacks Japanese completion status"
grep -Fq 'Artifact v2 synced successfully:' "$TMP_ROOT/install.log" \
  || fail "success log lacks English completion status"

# Only artifacts/ contents may reach the target.
assert_absent "$RTARGET/install.sh"
assert_absent "$RTARGET/artifacts.sh"
assert_absent "$RTARGET/artifacts"
assert_absent "$RTARGET/documents/knowledge"
if find "$RTARGET/documents" -name '.git' -print -quit | grep -q .; then
  fail "source .git reached target documents"
fi
[[ -z "$(find "$RTARGET/documents" -name '.artifacts.*' -print -quit)" ]] \
  || fail "stage residue left in target documents"
assert_owner_head "after first install"

# Update: change the served archive pack, leave a stale managed file in target,
# then re-run the exact same public command.
printf 'stale\n' > "$RTARGET/documents/artifacts/STALE.md"
printf 'testing-v2\n' > "$ARCHIVE_ROOT/artifacts/implementation/TESTING.md"
refresh_archive
run_bootstrap "$RTARGET" >"$TMP_ROOT/update.log" 2>&1 \
  || { cat "$TMP_ROOT/update.log"; fail "curl bootstrap update failed"; }
[[ "$(cat "$RTARGET/documents/artifacts/implementation/TESTING.md")" == "testing-v2" ]] \
  || fail "remote update did not apply new pack content"
assert_absent "$RTARGET/documents/artifacts/STALE.md"
assert_tmp_clean "after update"
assert_owner_head "after update"

[[ "$(cat "$RTARGET/AGENTS.md")" == "project agents" ]] || fail "AGENTS.md changed"
[[ "$(cat "$RTARGET/README.md")" == "project readme" ]] || fail "target README.md changed"
[[ "$(cat "$RTARGET/documents/INDEX.md")" == "project index" ]] || fail "documents/INDEX.md changed"
[[ "$(cat "$RTARGET/documents/project/OWNERS.md")" == "owner doc" ]] || fail "owner doc changed"

tree_hashes() {
  ( cd -- "$1" && find . -type f -print0 | LC_ALL=C sort -z \
      | xargs -0 sha256sum )
}
BEFORE_PACK="$(tree_hashes "$RTARGET/documents/artifacts")"
BEFORE_OWNER="$(sha256sum "$RTARGET/AGENTS.md" "$RTARGET/README.md" \
    "$RTARGET/documents/INDEX.md" "$RTARGET/documents/project/OWNERS.md")"
BEFORE_STATUS="$(git -C "$RTARGET" status --porcelain -uall)"

# Failed archive fetch leaves the current installation untouched.
if TEST_ARCHIVE_FAIL=1 run_bootstrap "$RTARGET" >"$TMP_ROOT/fetch-fail.log" 2>&1; then
  fail "archive acquisition failure unexpectedly succeeded"
fi
[[ "$BEFORE_PACK" == "$(tree_hashes "$RTARGET/documents/artifacts")" ]] \
  || fail "failed archive fetch changed installed pack contents"
[[ "$BEFORE_OWNER" == "$(sha256sum "$RTARGET/AGENTS.md" "$RTARGET/README.md" \
    "$RTARGET/documents/INDEX.md" "$RTARGET/documents/project/OWNERS.md")" ]] \
  || fail "failed archive fetch changed owner files"
[[ "$BEFORE_STATUS" == "$(git -C "$RTARGET" status --porcelain -uall)" ]] \
  || fail "failed archive fetch changed target Git state"
assert_owner_head "after failed archive fetch"
assert_tmp_clean "after failed archive fetch"
grep -Fq '配布元の取得に失敗しました。' "$TMP_ROOT/fetch-fail.log" \
  || fail "fetch failure lacks Japanese log"
grep -Fq 'Failed to fetch the distribution source.' "$TMP_ROOT/fetch-fail.log" \
  || fail "fetch failure lacks English log"

# A fetchable but invalid pack also leaves target state untouched.
BAD_PARENT="$TMP_ROOT/bad-archive-parent"
BAD_ROOT="$BAD_PARENT/documents-artifacts-main"
BAD_ARCHIVE="$TMP_ROOT/bad-documents-artifacts-main.tar.gz"
mkdir -p "$BAD_ROOT/artifacts"
cp "$SCRIPT" "$BAD_ROOT/artifacts.sh"
printf '# bad\n' > "$BAD_ROOT/artifacts/INDEX.md"
ln -s INDEX.md "$BAD_ROOT/artifacts/link.md"
tar -czf "$BAD_ARCHIVE" -C "$BAD_PARENT" documents-artifacts-main
if TEST_ARCHIVE_SOURCE="$BAD_ARCHIVE" run_bootstrap "$RTARGET" >"$TMP_ROOT/invalid.log" 2>&1; then
  fail "invalid source pack unexpectedly succeeded"
fi
[[ "$BEFORE_PACK" == "$(tree_hashes "$RTARGET/documents/artifacts")" ]] \
  || fail "invalid source changed installed pack contents"
[[ "$BEFORE_OWNER" == "$(sha256sum "$RTARGET/AGENTS.md" "$RTARGET/README.md" \
    "$RTARGET/documents/INDEX.md" "$RTARGET/documents/project/OWNERS.md")" ]] \
  || fail "invalid source changed owner files"
[[ "$BEFORE_STATUS" == "$(git -C "$RTARGET" status --porcelain -uall)" ]] \
  || fail "invalid source changed target Git state"
assert_owner_head "after invalid source"
assert_tmp_clean "after invalid source"
grep -Fq 'Artifact v2の同期に失敗しました。' "$TMP_ROOT/invalid.log" \
  || fail "invalid-pack failure lacks Japanese log"
grep -Fq 'Failed to sync Artifact v2.' "$TMP_ROOT/invalid.log" \
  || fail "invalid-pack failure lacks English log"

# Live probe: execute the exact documented curl | sh command against GitHub.
# If either raw/install or archive acquisition is blocked, report SKIP rather
# than claiming live coverage.
LIVE_TARGET="$TMP_ROOT/live-target"
mkdir -p "$LIVE_TARGET/documents"
RAW_URL="https://raw.githubusercontent.com/Daiki-Yoshida/documents-artifacts/main/install.sh"
ARCHIVE_URL="https://github.com/Daiki-Yoshida/documents-artifacts/archive/refs/heads/main.tar.gz"
if timeout 180 bash -c 'cd -- "$1" && TMPDIR="$2" sh "$3"' \
    _ "$LIVE_TARGET" "$BOOT_TMP" "$README_BOOTSTRAP" >/dev/null 2>&1; then
  assert_file "$LIVE_TARGET/documents/artifacts/INDEX.md"
  assert_tmp_clean "after live acquisition"
  printf 'NOTE: live GitHub curl bootstrap verified\n'
elif timeout 30 "$REAL_CURL" -fsSL "$RAW_URL" -o /dev/null >/dev/null 2>&1 \
    && timeout 60 "$REAL_CURL" -fsSL "$ARCHIVE_URL" -o /dev/null >/dev/null 2>&1; then
  fail "live curl bootstrap failed while both GitHub endpoints are reachable"
else
  printf 'SKIP: live GitHub curl bootstrap blocked (egress unavailable); fixture coverage passed\n'
fi

printf 'PASS: artifacts.sh Artifact v2 whole-pack sync/remove\n'
