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
  documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/MANIFEST.md \
  documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md \
  documents/knowledge/records/2026-01-31-initial-code-design-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-bounded-contracts-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-dependency-boundary-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-domain-model-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/MANIFEST.md \
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md \
  documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md \
  documents/project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md \
  documents/project/migration/LEGACY_DESIGN_SUBJECT_OWNERSHIP.md \
  documents/project/migration/LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md \
  documents/project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md \
  documents/project/migration/SHORT_APPROVAL_PROVENANCE_AUDIT.md; do
  require_file "$file"
done

# Recovered external reference snapshots must remain byte-identical to their pinned Git blobs.
programming_paradigm=documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md
ai_doc_strategy=documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/AI_DOC_STRATEGY.md
[[ "$(git hash-object "$programming_paradigm")" == "c417009102059cc1d42d2f8578cf22fc889d8547" ]] \
  || fail "PROGRAMMING_PARADIGM snapshot blob mismatch"
[[ "$(git hash-object "$ai_doc_strategy")" == "ed2059d8252ca524d45c45106771f6417fa755c4" ]] \
  || fail "AI_DOC_STRATEGY snapshot blob mismatch"

# Recovered code-design source snapshots must remain byte-identical to pinned Git blobs.
declare -A code_design_snapshot_blobs=(
  ["documents/knowledge/records/2026-01-31-initial-code-design-source/files/CODING_STANDARDS.md"]="3bae7e4212fcea8b5807edc00906fad6308f1140"
  ["documents/knowledge/records/2026-01-31-initial-code-design-source/files/DESIGN_PHILOSOPHY.md"]="488998aa85d245c949f9be4e21570a2a64b4dbf4"
  ["documents/knowledge/records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md"]="7043b6d20d01ba4a3e171171400dddd423b3da39"
  ["documents/knowledge/records/2026-01-31-bounded-contracts-refinement-source/files/CODING_STANDARDS.md"]="cbe3b01a3b8885402c3efc82b4e20c3cde48486a"
  ["documents/knowledge/records/2026-01-31-bounded-contracts-refinement-source/files/DESIGN_PHILOSOPHY.md"]="e99fdc169f3774cede6fcb7fa64b871e90fa8424"
  ["documents/knowledge/records/2026-01-31-bounded-contracts-refinement-source/files/AI_WORKFLOW.md"]="42e995f5039fee6b78b7f1d7a93d242567f20fdc"
  ["documents/knowledge/records/2026-01-31-dependency-boundary-refinement-source/files/CODING_STANDARDS.md"]="c42fdac981bdf9acea01d1644b4d294434833672"
  ["documents/knowledge/records/2026-01-31-dependency-boundary-refinement-source/files/DESIGN_PHILOSOPHY.md"]="1864b4d0e0b7f23f86b994fd419d597fb84e7912"
  ["documents/knowledge/records/2026-01-31-dependency-boundary-refinement-source/files/AI_WORKFLOW.md"]="ee8ad718331482e63c3a68ddc997b7966f326501"
  ["documents/knowledge/records/2026-01-31-domain-model-refinement-source/files/CODING_STANDARDS.md"]="5a5e21b02f175065fbbfa6434ceca8e2dbbc5474"
  ["documents/knowledge/records/2026-01-31-domain-model-refinement-source/files/DESIGN_PHILOSOPHY.md"]="faa120958f7e727cda476b87407e8ef4eaf32c92"
  ["documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/files/DESIGN_PHILOSOPHY.md"]="4a356c81c675e2fb390cee8ff15c34f397570ce6"
  ["documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md"]="02668d168fbf57ec2f1df38f3a2e94c2c877c192"
  ["documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/files/PROJECT_STRUCTURE.md"]="69abc27cca5735a745ae6f19d50c5e276c686f60"
  ["documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md"]="e3ab73e4957bcbe09a83dfd870811ef81fbafc71"
  ["documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/files/INDEX.md"]="63cb47489e585ee119abe1623c61a42599280910"
)
for file in "${!code_design_snapshot_blobs[@]}"; do
  require_file "$file"
  [[ "$(git hash-object "$file")" == "${code_design_snapshot_blobs[$file]}" ]] \
    || fail "code-design source snapshot blob mismatch: $file"
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
  documents/knowledge/subjects/*/S*.md
  documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
  documents/project/REPOSITORY_STRUCTURE.md
  documents/project/migration/KNOWLEDGE_MIGRATION_STATUS.md
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md
  documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md
  documents/project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md
  documents/project/migration/LEGACY_DESIGN_SUBJECT_OWNERSHIP.md
  documents/project/migration/LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md
  documents/project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md
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
  done < <(awk '/^[[:space:]]*(```|~~~~)/ { fenced = !fenced; next } !fenced { print }' "$document" | grep -Eo '\]\([^)]+\)' || true)
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
# Verify 14 legacy artifact files and 129 H2 entries in the fixed inventory.
inventory=documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md
inventory_files="$(grep -Ec '^## .*artifacts/' "$inventory" || true)"
inventory_sections="$(grep -Ec '^\| [0-9]+ \| ' "$inventory" || true)"
[[ "$inventory_files" == 14 ]] || fail "expected 14 inventory files, got $inventory_files"
[[ "$inventory_sections" == 129 ]] || fail "expected 129 H2 inventory rows, got $inventory_sections"

# Guard two later, explicitly adopted design-principles corrections against regression.
altitude=documents/knowledge/subjects/encapsulation-horizon/S004_CONCEPT_ALTITUDE.md
contract=documents/knowledge/subjects/encapsulation-horizon/S008_OPERATIONAL_GUARDS.md
grep -Fq 'semantic_identity:' "$altitude" \
  || fail "Concept Altitude lost semantic identity verification"
grep -Fq 'CONTRACT_L2_compatible_public_evolution:' "$contract" \
  || fail "Contract L2 is not compatibility-based"
if grep -Fq 'CONTRACT_L2_public_additive:' "$contract"; then
  fail "obsolete Contract L2 additive-only rule reintroduced"
fi

# Historical candidates must not claim current canonical authority.
for file in documents/project/migration/semantic-preservation-candidate/*.md; do
  if grep -Eq '^(document_type: "canonical_knowledge"|authority: "canonical_source")' "$file"; then
    fail "historical candidate still claims current authority: $file"
  fi
done

printf 'PASS: knowledge structure, source snapshots, links, and legacy inventory\n'
