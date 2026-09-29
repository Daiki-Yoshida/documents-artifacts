#!/usr/bin/env bash
# Documentation structural-migration check — deterministic, no network.
# Asserts the final document tree state, link repair, canonical-content
# preservation, and absence of scope-expanding rebuilds.
set -euo pipefail

cd "$(dirname "$0")/.."

failed=0
pass() { echo "docs-check: PASS — $1"; }
fail() { echo "docs-check: FAIL — $1"; failed=1; }

# $1 = path, $2 = label; stdin = expected byte-exact content.
expect_eq() {
  local path="$1" label="$2"
  if [ ! -f "$path" ]; then
    fail "$label missing: $path"
    return
  fi
  if cmp -s "$path" -; then
    pass "$label"
  else
    fail "$label content changed: $path"
  fi
}

OLD="documents/project/RELEASE.md"
NEW="documents/runbooks/release-process.md"

# Assert that a referring document changed only by replacing one known
# link target. This keeps the migration structural instead of allowing
# opportunistic prose/routing rewrites.
expect_link_only_change() {
  local path="$1" new_target="$2" old_target="$3" label="$4"
  local normalized
  normalized="$(mktemp)"
  sed "s|$new_target|$old_target|g" "$path" > "$normalized"
  if cmp -s "$normalized" -; then
    pass "$label"
  else
    fail "$label changed beyond the required link target"
  fi
  rm -f "$normalized"
}


# --- Canonical move ---------------------------------------------------
if [ ! -e "$OLD" ]; then
  pass "old release owner path absent ($OLD)"
else
  fail "old release owner still present: $OLD"
fi

if [ -f "$NEW" ]; then
  pass "new release owner present ($NEW)"
else
  fail "new release owner missing: $NEW"
fi

expect_eq "$NEW" "release procedure body preserved byte-for-byte" <<'EOF'
# Release Procedure

Canonical owner of the release procedure.

1. Tag the release commit.
2. Build artifacts in the managed runtime.
3. Publish the tag and notify maintainers.
EOF

# --- Incoming reference repair ---------------------------------------
if [ -f README.md ] \
  && grep -qF 'documents/runbooks/release-process.md' README.md \
  && ! grep -qF 'RELEASE.md' README.md; then
  pass "README link repaired"
else
  fail "README still lacks the new runbook link or still references RELEASE.md"
fi

if [ -f documents/INDEX.md ] \
  && grep -qF 'runbooks/release-process.md' documents/INDEX.md \
  && ! grep -qF 'RELEASE.md' documents/INDEX.md; then
  pass "INDEX routing repaired"
else
  fail "INDEX still lacks the new runbook link or still references RELEASE.md"
fi

if [ -f documents/project/ONCALL.md ] \
  && grep -qF '../runbooks/release-process.md' documents/project/ONCALL.md \
  && ! grep -qF 'RELEASE.md' documents/project/ONCALL.md \
  && grep -qF 'incident-response.md' documents/project/ONCALL.md; then
  pass "ONCALL link repaired (rest of the document intact)"
else
  fail "ONCALL not correctly repaired"
fi

# The three referring documents may change only at the migrated link target.
expect_link_only_change README.md \
  'documents/runbooks/release-process.md' 'documents/project/RELEASE.md' \
  'README changed only at release link target' <<'EOF'
# Documentation Structural Migration Project

Small docs-only project.

- Canonical routing hub: `documents/INDEX.md`
- Durable project facts: `documents/project/`
- Operational procedures: `documents/runbooks/` (the established runbook
  convention, e.g. `incident-response.md`)

Release work follows the
[Release procedure](documents/project/RELEASE.md).

## Verification

```bash
make verify    # documentation structure gate
```
EOF

expect_link_only_change documents/INDEX.md \
  'runbooks/release-process.md' 'project/RELEASE.md' \
  'INDEX changed only at release route target' <<'EOF'
# Documentation Index

Canonical routing hub for project documentation.

- [project/RELEASE.md](project/RELEASE.md) — release procedure owner
- [project/ONCALL.md](project/ONCALL.md) — on-call facts
- [project/ARCHITECTURE.md](project/ARCHITECTURE.md) — architecture notes
- [runbooks/incident-response.md](runbooks/incident-response.md) — incident runbook
EOF

expect_link_only_change documents/project/ONCALL.md \
  '../runbooks/release-process.md' 'RELEASE.md' \
  'ONCALL changed only at release link target' <<'EOF'
# On-call

During a release incident, follow the
[release procedure](RELEASE.md) and the
[incident runbook](../runbooks/incident-response.md).
EOF

# INDEX keeps routing to the other canonical docs (no rebuild).
if grep -qF 'project/ONCALL.md' documents/INDEX.md 2>/dev/null \
  && grep -qF 'project/ARCHITECTURE.md' documents/INDEX.md \
  && grep -qF 'runbooks/incident-response.md' documents/INDEX.md; then
  pass "INDEX still routes to the other canonical docs"
else
  fail "INDEX lost unrelated canonical routes (docs-model rebuild?)"
fi

# --- No old-path references anywhere in project docs ------------------
# documents/artifacts/ is a managed derived snapshot — out of scope.
old_refs="$(grep -rlF --exclude-dir=artifacts 'RELEASE.md' \
  README.md documents/ 2>/dev/null || true)"
if [ -z "$old_refs" ]; then
  pass "zero references to the old release path"
else
  fail "old-path references remain: $old_refs"
fi

# --- Single owner, no duplicate ---------------------------------------
owner_hits="$(grep -rlF --exclude-dir=artifacts 'Tag the release commit.' \
  README.md documents/ 2>/dev/null || true)"
if [ "$(printf '%s' "$owner_hits" | grep -c .)" -eq 1 ] \
  && [ "$owner_hits" = "$NEW" ]; then
  pass "exactly one release-procedure owner: $NEW"
else
  fail "release owner duplicated or misplaced: ${owner_hits:-<none>}"
fi

# --- Unrelated docs unchanged -----------------------------------------
expect_eq documents/project/ARCHITECTURE.md "ARCHITECTURE unchanged" <<'EOF'
# Architecture

Service boundaries and module notes.

Unrelated to release/runbook placement.
EOF

expect_eq documents/runbooks/incident-response.md "incident-response unchanged" <<'EOF'
# Incident Response

1. Acknowledge the page.
2. Stabilize the service.
3. Write the postmortem.
EOF

# --- Tree shape: exactly the expected document set --------------------
expected_set="$(printf '%s\n' \
  'documents/INDEX.md' \
  'documents/project/ARCHITECTURE.md' \
  'documents/project/ONCALL.md' \
  'documents/runbooks/incident-response.md' \
  'documents/runbooks/release-process.md' | sort)"
actual_set="$(cd documents 2>/dev/null && find . -path ./artifacts -prune \
  -o -type f -name '*.md' -print | sed 's|^\./|documents/|' | sort || true)"
if [ "$actual_set" = "$expected_set" ]; then
  pass "documents tree is exactly the expected file set (one move, no extras)"
else
  fail "documents tree differs from the expected set:
$(printf '%s\n' "$actual_set" | sed 's/^/  actual: /')"
fi

# --- No archive/history copy or second docs root ----------------------
bad_roots=""
for bad in docs documentation archive history documents.bak \
           documents-archive documents-old; do
  [ -e "$bad" ] && bad_roots="$bad_roots $bad"
done
stray="$(find . -name .git -prune -o \( -name '*.bak' -o -name '*.orig' \) -print 2>/dev/null | head -5 || true)"
if [ -z "$bad_roots" ] && [ -z "$stray" ]; then
  pass "no archive/history copy or second documentation root"
else
  fail "archive/second-root/stray backup detected:$bad_roots$stray"
fi

if [ "$failed" -ne 0 ]; then
  echo "docs-check: FAILED"
  exit 1
fi
echo "docs-check: all checks passed"
