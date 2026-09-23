#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "missing: $1"
}

# The knowledge system owns the current structure. Avoid deriving layout
# from historical migration candidates or the old selectable artifact modules.
for file in \
  documents/knowledge/INDEX.md \
  documents/knowledge/system/INDEX.md \
  documents/knowledge/system/KNOWLEDGE_MODEL.md \
  documents/knowledge/system/RECORD_MODEL.md \
  documents/knowledge/system/SUBJECT_MODEL.md \
  documents/knowledge/system/TRACEABILITY_MODEL.md \
  documents/knowledge/subjects/INDEX.md \
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md; do
  require_file "$file"
done

# Subject reading order must be consecutive and HISTORY (if present) last.
subject_dirs=(documents/knowledge/subjects/*/)
(("${#subject_dirs[@]}" > 0)) || fail "no subjects found"
for subject in "${subject_dirs[@]}"; do
  require_file "${subject}INDEX.md"
  docs=("${subject}"S[0-9][0-9][0-9]_*.md)
  (("${#docs[@]}" > 0)) || fail "no SNNN files: $subject"
  for (( i = 0; i < ${#docs[@]}; i++ )); do
    expected="$(printf 'S%03d_' "$((i + 1))")"
    name="${docs[i]##*/}"
    [[ "$name" == "$expected"* ]] || fail "non-consecutive subject file: ${docs[i]}"
    if [[ "$name" == *_HISTORY.md ]]; then
      ((i == ${#docs[@]} - 1)) || fail "HISTORY must be last: ${docs[i]}"
    fi
  done
done

# Every record directory must identify its raw source event or snapshot.
for record_dir in documents/knowledge/records/*/; do
  [[ -f "${record_dir}RECORD.md" || -f "${record_dir}MANIFEST.md" ]] \
    || fail "record without RECORD.md or MANIFEST.md: $record_dir"
done

# Validate navigational Markdown links in the active repository-local entrypoints.
entrypoints=(
  docs-jp/README.md
  documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
  documents/project/REPOSITORY_STRUCTURE.md
  documents/project/migration/KNOWLEDGE_MIGRATION_STATUS.md
)
for document in "${entrypoints[@]}"; do
  require_file "$document"
  while IFS= read -r match; do
    target="${match:2:${#match}-3}"
    case "$target" in
      https://*|http://*|mailto:*|\#*) continue ;;
    esac
    target="${target%%\#*}"
    [[ -e "$(dirname "$document")/$target" ]] \
      || fail "broken Markdown link in $document: $target"
  done < <(grep -Eo '\]\([^)]+\)' "$document" || true)
done

# The fixed Git tree audit records all 14 legacy artifact Markdown blobs.
audit=documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md
count="$(grep -Ec '^\| (design-principles|development-environment-strategy|documentation-strategy) \|' "$audit" || true)"
[[ "$count" == 14 ]] || fail "expected 14 legacy artifact entries, got $count"

# Direct readers of historical migration candidates must not see them tagged
# as current canonical knowledge.
for file in documents/project/migration/semantic-preservation-candidate/*.md; do
  if grep -Eq '^(document_type: "canonical_knowledge"|authority: "canonical_source")' "$file"; then
    fail "historical candidate still claims current authority: $file"
  fi
done

printf 'PASS: knowledge structure, record envelopes, active links, and legacy audit\n'
