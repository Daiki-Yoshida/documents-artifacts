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
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md \
  documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md \
  documents/project/migration/SHORT_APPROVAL_PROVENANCE_AUDIT.md; do
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
  name="${record_dir%/}"
  name="${name##*/}"
  [[ "$name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$ ]] \
    || fail "invalid record directory name: $record_dir"
  [[ -f "${record_dir}RECORD.md" || -f "${record_dir}MANIFEST.md" ]] \
    || fail "record without RECORD.md or MANIFEST.md: $record_dir"
done

# Validate navigational Markdown links in the active repository-local entrypoints.
entrypoints=(
  README.md
  docs-jp/README.md
  documents/INDEX.md
  documents/knowledge/INDEX.md
  documents/knowledge/system/INDEX.md
  documents/knowledge/subjects/INDEX.md
  documents/knowledge/subjects/*/INDEX.md
  documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
  documents/project/REPOSITORY_STRUCTURE.md
  documents/project/migration/KNOWLEDGE_MIGRATION_STATUS.md
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md
  documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md
  documents/project/migration/SHORT_APPROVAL_PROVENANCE_AUDIT.md
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
  done < <(awk '/^[[:space:]]*```/ { fenced = !fenced; next } !fenced { print }' "$document" | grep -Eo '\]\([^)]+\)' || true)
done

# Verify all 14 unique legacy file entries and their pinned SHA-1 hashes.
snapshot_commit="e760eb38841650d60739750953c8342b639ce6f0"
audit=documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md
grep -Fqx "legacy_snapshot_commit: \"$snapshot_commit\"" "$audit" \
  || fail "audit snapshot commit differs from the verified baseline"
declare -A seen_artifacts=()
count=0
if git cat-file -e "${snapshot_commit}^{commit}" 2>/dev/null; then
  verify_git=1
else
  verify_git=0
  printf 'WARN: snapshot commit unavailable in this checkout; Git blob comparison skipped\n' >&2
fi
while IFS='|' read -r _ module file hash _; do
  module="${module// /}"
  case "$module" in
    design-principles|development-environment-strategy|documentation-strategy) ;;
    *) continue ;;
  esac
  file="${file// /}"
  file="${file//\`/}"
  hash="${hash// /}"
  hash="${hash//\`/}"
  [[ "$file" =~ ^[a-zA-Z0-9_.-]+\.md$ ]] || fail "invalid artifact filename: $file"
  [[ "$hash" =~ ^[0-9a-f]{40}$ ]] || fail "invalid blob SHA: $module/$file"
  entry="artifacts/$module/$file"
  [[ -z "${seen_artifacts[$entry]+x}" ]] || fail "duplicate legacy entry: $entry"
  seen_artifacts[$entry]=1
  ((count += 1))
  if ((verify_git)); then
    actual="$(git rev-parse "${snapshot_commit}:${entry}" 2>/dev/null)" \
      || fail "missing historical artifact: $entry"
    [[ "$actual" == "$hash" ]] || fail "Git blob mismatch: $entry"
  fi
done < "$audit"
[[ "$count" == 14 ]] || fail "expected 14 unique artifact entries, got $count"
# Verify that the H2 inventory enumerates all 14 artifact files and 129 H2 headings.
inventory=documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md
inventory_files="$(grep -Ec '^## \`artifacts/(design-principles|development-environment-strategy|documentation-strategy)/[^\`]+\\.md\`
# as current canonical knowledge.
for file in documents/project/migration/semantic-preservation-candidate/*.md; do
  if grep -Eq '^(document_type: "canonical_knowledge"|authority: "canonical_source")' "$file"; then
    fail "historical candidate still claims current authority: $file"
  fi
done

printf 'PASS: knowledge structure, record envelopes, active links, and legacy audit\n'
 "$inventory" || true)"
inventory_sections="$(grep -Ec '^\\| [0-9]+ \\| ' "$inventory" || true)"
[[ "$inventory_files" == 14 ]] || fail "expected 14 inventory files, got $inventory_files"
[[ "$inventory_sections" == 129 ]] || fail "expected 129 H2 inventory rows, got $inventory_sections"

# Direct readers of historical migration candidates must not see them tagged
# as current canonical knowledge.
for file in documents/project/migration/semantic-preservation-candidate/*.md; do
  if grep -Eq '^(document_type: "canonical_knowledge"|authority: "canonical_source")' "$file"; then
    fail "historical candidate still claims current authority: $file"
  fi
done

printf 'PASS: knowledge structure, record envelopes, active links, and legacy audit\n'
