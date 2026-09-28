#!/bin/sh
# Final documentation reconciliation gate. Deterministic: reads only
# repository files — no network, no timestamps.
set -eu
cd "$(dirname "$0")/.."

failed=0
pass() { printf 'verify: PASS — %s\n' "$1"; }
fail() { printf 'verify: FAIL — %s\n' "$1" >&2; failed=1; }

EXPORT=documents/project/EXPORT.md

# 1. Routing intact: INDEX.md still routes CSV export to project/EXPORT.md
if grep -q 'project/EXPORT.md' documents/INDEX.md; then
  pass "INDEX routes CSV export to project/EXPORT.md"
else
  fail "INDEX no longer routes CSV export to project/EXPORT.md"
fi

if [ ! -f "$EXPORT" ]; then
  fail "$EXPORT missing"
  exit 1
fi

# 2. Durable confirmed knowledge integrated into the owner document
if grep -qiE 'utf-?8' "$EXPORT" \
   && grep -qiE '(without|no)[[:space:]-]*bom' "$EXPORT"; then
  pass "EXPORT documents UTF-8 without BOM"
else
  fail "EXPORT lacks confirmed encoding semantics (UTF-8 without BOM)"
fi
if grep -qE 'id, *name, *email' "$EXPORT"; then
  pass "EXPORT documents header order id,name,email"
else
  fail "EXPORT lacks confirmed header order id,name,email"
fi
if grep -qi 'comma' "$EXPORT" && grep -qi 'quote' "$EXPORT" && grep -qi 'newline' "$EXPORT"; then
  pass "EXPORT documents quoting rule for comma/quote/newline fields"
else
  fail "EXPORT lacks quoting rule for comma/quote/newline fields"
fi
if grep -qiE 'doubl|""' "$EXPORT"; then
  pass "EXPORT documents embedded double-quote escaping"
else
  fail "EXPORT lacks embedded double-quote escaping (doubling)"
fi

# 3. Existing canonical content preserved
if grep -q 'Public columns' "$EXPORT" && grep -qi 'downloads directory' "$EXPORT"; then
  pass "existing canonical content preserved"
else
  fail "existing canonical content was lost during reconciliation"
fi

# 4. Temporary / rejected / run-specific material must not be promoted
if grep -rniE 'tsv|semicolon|benchmark|export\.tmp|sample-2026|dev-box|2026-09-28' documents/ 2>/dev/null | grep -q .; then
  fail "temporary/rejected/run-specific material leaked into project documentation"
else
  pass "no temporary/rejected/run-specific material in project documentation"
fi

# 5. Completed Work Documents closed out
if [ -d .worktrees/feat/csv-export/documents ] \
   && find .worktrees/feat/csv-export/documents -type f | grep -q .; then
  fail "completed Work Documents still present under .worktrees/feat/csv-export/documents"
else
  pass "completed Work Documents closed out"
fi

# 6. No duplicate archive/history authority — Git is the history mechanism
if [ -d documents/archive ] || [ -d documents/history ] \
   || find documents -name '*csv-export*' -print -quit | grep -q .; then
  fail "duplicate archive/history documentation was created"
else
  pass "no duplicate archive/history documentation"
fi

[ "$failed" -eq 0 ] || exit 1
printf 'verify: PASS — documentation reconciliation complete\n'
