#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
owner="$root/documents/project/EXPORT.md"
active="$root/.worktrees/feat/contact-export/documents"
archive="$root/documents/archive/works/feat/contact-export"
other="$root/.worktrees/fix/unrelated/documents/NOTES.md"

[[ -f "$owner" ]] || fail 'missing current Project Documentation owner'
[[ -f "$other" ]] || fail 'unrelated Work changed'
grep -Fq 'UTF-8 without BOM' "$owner" || fail 'encoding contract lost'
grep -Fq 'id,name,email' "$owner" || fail 'published header order not reconciled'
grep -Fq 'comma, quote, or newline' "$owner" || fail 'field quoting missing'
grep -Fq 'doubling the quote character' "$owner" || fail 'double-quote escaping missing'
grep -Fq 'Public fields are stable' "$owner" || fail 'prior current owner content lost'
grep -Fq 'Distribution remains internal' "$owner" || fail 'prior distribution content lost'
! grep -Fq 'semicolon-delimiter' "$owner" || fail 'rejected scratch promoted'
[[ ! -e "$active" && ! -L "$active" ]] || fail 'completed Work Documents still active'
[[ -d "$archive/records" && ! -L "$archive" && ! -L "$archive/records" ]] || fail 'archive absent or symlinked'
[[ ! -e "$archive/DESIGN.md" ]] || fail 'Work Documents were archived wholesale'
[[ -f "$archive/records/2026-10-13-investigation.md" && ! -L "$archive/records/2026-10-13-investigation.md" ]] || fail 'investigation Record missing or symlinked'
[[ -f "$archive/records/2026-10-13-verification.md" && ! -L "$archive/records/2026-10-13-verification.md" ]] || fail 'verification Record missing or symlinked'
sum1="$(sha256sum "$archive/records/2026-10-13-investigation.md")"
sum2="$(sha256sum "$archive/records/2026-10-13-verification.md")"
[[ "${sum1%% *}" == '8507c6eb029dbbcb8aa75b823718d1680387dbe04fedfbafde4d008ee574692b' ]] || fail 'investigation Record changed during archive transfer'
[[ "${sum2%% *}" == '8949b332aab234b4f04a58d977cc82c32046b2f1b2d7ff15e16fcc2ad53efdf3' ]] || fail 'verification Record changed during archive transfer'
[[ -f "$root/documents/INDEX.md" ]] || fail 'Project routing lost'
grep -Fq 'project/EXPORT.md' "$root/documents/INDEX.md" || fail 'current owner route lost'
printf 'PASS: Work Records archived selectively with intact history and current documentation\n'
