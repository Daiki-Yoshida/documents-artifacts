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
  documents/knowledge/system/DECISION_LINEAGE_MODEL.md \
  documents/knowledge/system/SUBJECT_MODEL.md \
  documents/knowledge/system/TRACEABILITY_MODEL.md \
  documents/knowledge/system/ARTIFACT_MODEL.md \
  documents/knowledge/subjects/INDEX.md \
  documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/MANIFEST.md \
  documents/knowledge/records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md \
  documents/knowledge/records/2026-01-31-initial-code-design-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-bounded-contracts-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-dependency-boundary-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-01-31-domain-model-refinement-source/MANIFEST.md \
  documents/knowledge/records/2026-07-02-design-principles-final-source-snapshot/MANIFEST.md \
  documents/knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/MANIFEST.md \
  documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/MANIFEST.md \
  documents/knowledge/records/2026-06-13-operational-discipline-commit/RECORD.md \
  documents/knowledge/records/2026-10-03-project-root-execution-routing/RECORD.md \
  documents/knowledge/records/2026-10-03-project-root-execution-routing/USER_MESSAGES.md \
  documents/knowledge/records/2026-10-03-project-root-execution-routing/ISSUE_148_BODY.md \
  documents/knowledge/records/2026-10-03-project-root-execution-routing/ISSUE_148_COMMENT_5958273589.md \
  documents/knowledge/records/2026-10-03-project-root-execution-routing/ISSUE_148_COMMENT_5958401218.md \
  documents/knowledge/records/2026-10-03-subject-consistency-convergence/RECORD.md \
  documents/knowledge/records/2026-10-03-subject-consistency-convergence/USER_MESSAGES.md \
  documents/knowledge/records/2026-10-03-subject-consistency-convergence/ISSUE_164_BODY.md \
  documents/knowledge/records/2026-10-03-project-component-documentation-boundary/RECORD.md \
  documents/knowledge/records/2026-10-03-project-component-documentation-boundary/USER_MESSAGES.md \
  documents/knowledge/records/2026-10-03-project-component-documentation-boundary/ISSUE_167_BODY.md \
  documents/knowledge/records/2026-10-03-knowledge-effective-status-lineage/RECORD.md \
  documents/knowledge/records/2026-10-03-knowledge-effective-status-lineage/USER_MESSAGES.md \
  documents/knowledge/records/2026-10-03-knowledge-effective-status-lineage/ISSUE_171_BODY.md \
  documents/knowledge/records/2026-10-03-knowledge-effective-status-lineage/ISSUE_171_DECISION_COMMENTS.md \
  documents/knowledge/records/2026-10-03-subject-effective-status-lineage-audit/RECORD.md \
  documents/knowledge/records/2026-10-03-subject-effective-status-lineage-audit/USER_MESSAGE.md \
  documents/knowledge/records/2026-10-03-subject-effective-status-lineage-audit/ISSUE_174_BODY.md \
  documents/knowledge/records/2026-10-03-subject-effective-status-lineage-audit/ISSUE_174_AUDIT_RESULT.md \
  documents/knowledge/records/2026-10-03-subject-effective-status-lineage-audit/ISSUE_175_BODY.md \
  documents/knowledge/records/2026-10-04-negative-alternative-leakage/RECORD.md \
  documents/knowledge/records/2026-10-04-negative-alternative-leakage/ISSUE_190_BODY.md \
  documents/knowledge/records/2026-10-07-generalized-nal-proposal/RECORD.md \
  documents/knowledge/records/2026-10-07-generalized-nal-proposal/CHAT_PROPOSAL.md \
  documents/knowledge/records/2026-10-07-generalized-nal-adoption/RECORD.md \
  documents/knowledge/records/2026-10-07-generalized-nal-adoption/USER_APPROVAL.md \
  documents/knowledge/records/2026-10-07-generalized-nal-issue/RECORD.md \
  documents/knowledge/records/2026-10-07-generalized-nal-issue/ISSUE_196_BODY.md \
  documents/knowledge/records/2026-10-04-management-root-repository-terminology/RECORD.md \
  documents/knowledge/records/2026-10-04-management-root-repository-terminology/ISSUE_192_BODY.md \
  documents/knowledge/records/2026-10-04-workspace-physical-topology/RECORD.md \
  documents/knowledge/records/2026-10-04-workspace-physical-topology/ISSUE_191_BODY.md \
  documents/project/migration/LEGACY_ARTIFACT_COVERAGE_AUDIT.md \
  documents/project/migration/LEGACY_ARTIFACT_SECTION_INVENTORY.md \
  documents/project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md \
  documents/project/migration/LEGACY_DESIGN_SUBJECT_OWNERSHIP.md \
  documents/project/migration/LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md \
  documents/project/migration/LEGACY_DOCUMENTATION_GAP_AUDIT.md \
  documents/project/migration/LEGACY_DEVELOPMENT_ENVIRONMENT_GAP_AUDIT.md \
  documents/project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md \
  documents/project/ARTIFACT_ARCHITECTURE_V2.md \
  documents/project/AGENT_ARTIFACT_TEST_HARNESS.md \
  tests/INDEX.md \
  documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md \
  documents/project/migration/ARTIFACT_V2_CANDIDATE_AUDIT.md \
  documents/project/migration/ARTIFACT_V2_LEGACY_REGRESSION_AUDIT.md \
  documents/project/migration/ARTIFACT_V2_ROUTING_SIMULATION.md \
  documents/project/migration/ARTIFACT_V2_CROSS_FILE_AUTHORITY_AUDIT.md \
  documents/project/migration/ARTIFACT_V2_PROMOTION_VALIDATION.md \
  documents/project/migration/SHORT_APPROVAL_PROVENANCE_AUDIT.md \
  artifacts/INDEX.md; do
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

# Recovered documentation / development-environment final source snapshots must remain byte-identical.
declare -A legacy_strategy_snapshot_blobs=(
  ["documents/knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/files/DOCUMENTATION_PHILOSOPHY.md"]="b5415fcf4adb770b17623179a482aa77f322bef3"
  ["documents/knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/files/DOCUMENT_WORKFLOW.md"]="90c17259079ec97b09c1586fa4a1e6b4a6ed6b13"
  ["documents/knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/files/FILE_AND_STRUCTURE.md"]="72f5b2c47dae045a17b1a94589cb1ca7c490346c"
  ["documents/knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/files/INDEX.md"]="2b0509ad3a34f60a7c51a13493ad60d6300b9cc9"
  ["documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/files/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md"]="d13406518405231a353590cab37ea409cf72a798"
  ["documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/files/ENVIRONMENT_STANDARDS.md"]="d26988857aa351f23d6f4256f5209e5e6c34e574"
  ["documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/files/ENVIRONMENT_WORKFLOW.md"]="fd05ec0738e2b5e68b4e6d7e9635902c8e0dd09e"
  ["documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/files/INDEX.md"]="8fa048420e278ed381441bd66e7126cd794343ff"
  ["documents/knowledge/records/2026-08-03-development-environment-final-source-snapshot/files/WORKSPACE_STRUCTURE.md"]="28508999e55716fe794f2273a1ad55569bd8734a"
)
for file in "${!legacy_strategy_snapshot_blobs[@]}"; do
  require_file "$file"
  [[ "$(git hash-object "$file")" == "${legacy_strategy_snapshot_blobs[$file]}" ]] \
    || fail "legacy strategy source snapshot blob mismatch: $file"
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

# Every subject directory must be routed from the canonical subject inventory.
subjects_index=documents/knowledge/subjects/INDEX.md
for subject in "${subject_dirs[@]}"; do
  subject_name="${subject%/}"
  subject_name="${subject_name##*/}"
  grep -Fq "[$subject_name]($subject_name/INDEX.md)" "$subjects_index" \
    || fail "subject missing from subjects/INDEX.md: $subject_name"
done

# Every canonical code-design section must expose traceability.
for file in documents/knowledge/subjects/code-design/S*.md; do
  grep -Fqx '## Sources' "$file"     || fail "code-design section without Sources: $file"
done

# Every canonical engineering-operation section must expose traceability.
for file in documents/knowledge/subjects/engineering-operation/S*.md; do
  grep -Fqx '## Sources' "$file" \
    || fail "engineering-operation section without Sources: $file"
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
  documents/knowledge/system/ARTIFACT_MODEL.md
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
  documents/project/migration/LEGACY_DOCUMENTATION_GAP_AUDIT.md
  documents/project/migration/LEGACY_DEVELOPMENT_ENVIRONMENT_GAP_AUDIT.md
  documents/project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md
  documents/project/migration/SHORT_APPROVAL_PROVENANCE_AUDIT.md
  documents/project/ARTIFACT_ARCHITECTURE_V2.md
  documents/project/AGENT_ARTIFACT_TEST_HARNESS.md
  tests/INDEX.md
  documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md
  documents/project/migration/ARTIFACT_V2_CANDIDATE_AUDIT.md
  documents/project/migration/ARTIFACT_V2_LEGACY_REGRESSION_AUDIT.md
  documents/project/migration/ARTIFACT_V2_ROUTING_SIMULATION.md
  documents/project/migration/ARTIFACT_V2_CROSS_FILE_AUTHORITY_AUDIT.md
  documents/project/migration/ARTIFACT_V2_PROMOTION_VALIDATION.md
  artifacts/INDEX.md
  artifacts/*/INDEX.md
  artifacts/*/*.md
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


# Artifact v2 is the current runtime projection: 42 files, 7 routed domains, no legacy modules.
artifact_files=(artifacts/INDEX.md artifacts/*/*.md)
[[ "${#artifact_files[@]}" == 42 ]] || fail "expected 42 Artifact v2 Markdown files, got ${#artifact_files[@]}"
for dir in design implementation operation documentation project execution safety; do
  require_file "artifacts/$dir/INDEX.md"
done
for legacy_dir in design-principles documentation-strategy development-environment-strategy; do
  [[ ! -e "artifacts/$legacy_dir" ]] || fail "legacy artifact module reintroduced: $legacy_dir"
done
grep -Fq 'Do **not** read every file by default.' artifacts/INDEX.md \
  || fail "Artifact v2 root lost selective-reading guard"
grep -Fq 'managed derived snapshot' artifacts/INDEX.md \
  || fail "Artifact v2 root lost managed-copy guard"


# Project Root / execution-target routing must remain present from canonical knowledge through Artifact v2.
workspace_model=documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
workspace_ownership=documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
execution_commands=documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md
work_root_model=documents/knowledge/subjects/work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md
worktree_commands=documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md
destructive_ops=documents/knowledge/subjects/development-safety/S002_DESTRUCTIVE_OPERATIONS.md

grep -Fq 'AI development sessionは **Project Rootから開始する**' "$workspace_model" \
  || fail "Project Root lost canonical AI development entry requirement"
grep -Fq 'repository-specific source ownershipを理由にComponent Repository checkoutをProject全体のAI session rootへ昇格させない' "$workspace_ownership" \
  || fail "Component Repository ownership/context boundary regressed"
grep -Fq 'generic `DIR` は、**path-valued execution target selector**' "$execution_commands" \
  || fail "generic DIR lost path-valued execution-target semantics"
grep -Fq 'Project-owned public operationがrequested operationを提供している場合' "$execution_commands" \
  || fail "public-command bypass guard missing from canonical knowledge"
grep -Fq 'relative `DIR` はProject Rootを基準にresolveする' "$execution_commands" \
  || fail "DIR lost Project Root-relative resolution rule"
grep -Fq 'Work Rootは、Work Identityに属するWork Documentsとparticipating repository worktreeを束ねる**物理的な作業領域**である' "$work_root_model" \
  || fail "Work Root physical-role boundary regressed"
grep -Fq 'worktree lifecycleのcanonical inputを `DIR` に置き換えない' "$worktree_commands" \
  || fail "DIR incorrectly replaced WORK+REPO worktree identity contract"
grep -Fq 'directory pathを指定できること自体は、そのdirectoryに対する破壊操作のauthorizationを意味しない' "$destructive_ops" \
  || fail "DIR selection became destructive authorization"

artifact_workspace=artifacts/project/WORKSPACE.md
artifact_work_identity=artifacts/project/WORK_IDENTITY.md
artifact_commands=artifacts/execution/COMMANDS_AND_CI.md
artifact_destructive=artifacts/safety/DESTRUCTIVE_OPERATIONS.md

grep -Fq 'initialize the AI development session from the **Project Root**' "$artifact_workspace" \
  || fail "Artifact projection lost Project Root session-entry requirement"
grep -Fq 'Work Root is the physical area' "$artifact_work_identity" \
  || fail "Artifact Work Root/session-root distinction missing"
grep -Fq '`DIR` is a path-valued execution selector only' "$artifact_commands" \
  || fail "Artifact DIR semantics missing"
grep -Fq 'Generic `DIR` semantics must not infer repository roles or silently append project-specific suffixes' "$artifact_commands" \
  || fail "Artifact DIR gained implicit Work/repository derivation"
grep -Fq 'Do not replace Worktree identity/materialization inputs with `DIR`' "$artifact_commands" \
  || fail "Artifact DIR/worktree identity boundary missing"
grep -Fq 'does not authorize destructive effects' "$artifact_destructive" \
  || fail "Artifact DIR destructive-authority guard missing"
grep -Fq '| Project-root session / command target routing | `project/WORKSPACE.md` + `execution/COMMANDS_AND_CI.md` |' artifacts/INDEX.md \
  || fail "Artifact root lost Project Root execution-target route"

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
grep -Fq 'current_semantic_classification: "129/129 H2 owner/history/replacement classified"' "$inventory" \
  || fail "inventory current semantic classification is stale"
if grep -Fq '現行subjectへの意味保存判定: **未完了**' "$inventory"; then
  fail "inventory still presents initial incomplete status as current"
fi

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

# Documentation root is stable, but project/reference internal directories are optional examples.
doc_routing=documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md
doc_workflow=documents/knowledge/subjects/documentation/S003_WORKFLOW.md
grep -Fq 'documents/project/ は標準的な配置例だが必須directoryではない' "$doc_routing"   || fail "documentation project/ layout became mandatory again"
grep -Fq 'documents/reference/ は標準的な配置例だが必須directoryではない' "$doc_routing"   || fail "documentation reference/ layout became mandatory again"
grep -Fq 'project/referenceを必須shapeにせず' "$doc_workflow"   || fail "documentation setup lost flexible internal layout rule"

# Subject-consistency convergence guards (Issue #164).
doc_principles=documents/knowledge/subjects/documentation/S001_PRINCIPLES.md
doc_routing=documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md
doc_workflow=documents/knowledge/subjects/documentation/S003_WORKFLOW.md
work_docs=documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md
work_lifecycle=documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md
worktrees=documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md
change_lifecycle=documents/knowledge/subjects/engineering-operation/S001_CHANGE_LIFECYCLE.md
vcs_reporting=documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md

grep -Fq 'managed derived subtree' "$doc_principles" \
  || fail "documentation authority does not distinguish managed derived subtrees"
grep -Fq 'managed derived subtreeはentrypoint単位でroute' "$doc_routing" \
  || fail "documents/INDEX inventory scope still requires managed internal leaves"
if grep -Fq 'documents/artifacts/<module>/' "$doc_workflow"; then
  fail "legacy Artifact module path remains in current documentation workflow"
fi
grep -Fq 'documents/artifacts/INDEX.md' "$doc_workflow" \
  || fail "Artifact v2 managed entrypoint missing from canonical documentation workflow"
grep -Fq 'Project baseline branch' "$work_docs" \
  || fail "Work Documents remain hard-coded to literal main"
grep -Fq 'baseline publicationがpending' "$work_docs" \
  || fail "Work Documents lifecycle lost VCS publication boundary"
grep -Fq 'baseline visibility / publication reconciled as authorized' "$work_lifecycle" \
  || fail "Work lifecycle assumes unauthorized baseline publication"
grep -Fq 'Git branch名ではない' "$worktrees" \
  || fail "REPO selector/branch distinction missing"
grep -Fq 'stable repository roleとしてProject-level tracked' "$worktrees" \
  || fail "worktree materialization applicability still depends only on current branch tree"
grep -Fq 'Work Identity worktree lifecycle capabilityを採用する場合' "$worktrees" \
  || fail "worktree create/status/remove lacks capability adoption precondition"
grep -Fq 'explicit user confirmation' "$change_lifecycle" \
  || fail "engineering lifecycle does not route through Work Identity confirmation"
grep -Fq 'Work Documents baseline publicationとの境界' "$vcs_reporting" \
  || fail "VCS authority/Work Documents publication boundary missing"

grep -Fq 'managed derived subtree' artifacts/documentation/PRINCIPLES_AND_ROUTING.md \
  || fail "Artifact documentation projection lost managed-authority distinction"
grep -Fq 'one managed pack under `documents/artifacts/`' artifacts/documentation/WORKFLOW_AND_MAINTENANCE.md \
  || fail "Artifact documentation workflow lost whole-pack model"
grep -Fq 'stable repository selector, not a Git branch name' artifacts/project/WORKTREES.md \
  || fail "Artifact worktree selector/branch distinction missing"
grep -Fq 'stable role owns (or can later receive)' artifacts/project/WORKTREES.md \
  || fail "Artifact worktree materialization applicability regressed"
grep -Fq 'Work Identity model and a concrete implementation effort' artifacts/operation/CHANGE_LIFECYCLE.md \
  || fail "Artifact operation flow lost Work Identity gate"
grep -Fq "Prefer the project's existing convention" artifacts/documentation/FORMAT_AND_GIT.md \
  || fail "Artifact documentation lost project-convention-first commit rule"
grep -Eq 'If none exists.*Japanese description' artifacts/documentation/FORMAT_AND_GIT.md \
  || fail "Artifact documentation lost conditional Japanese-description default"

# Management Root Repository / Component Repository documentation boundary guards (Issue #167).
doc_principles=documents/knowledge/subjects/documentation/S001_PRINCIPLES.md
doc_routing=documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md
doc_workflow=documents/knowledge/subjects/documentation/S003_WORKFLOW.md
doc_history=documents/knowledge/subjects/documentation/S006_HISTORY.md
workspace_index=documents/knowledge/subjects/workspace-structure/INDEX.md
workspace_model=documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
workspace_ownership=documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
workspace_history=documents/knowledge/subjects/workspace-structure/S003_HISTORY.md

if grep -Fq 'hierarchical_project:' "$doc_principles"; then
  fail "current documentation principles reintroduced hierarchical project model"
fi
if grep -Fq '## 8. 階層プロジェクト' "$doc_routing"; then
  fail "current documentation routing reintroduced parent/child hierarchy"
fi
if grep -Fq 'documents/project/children.md' "$doc_routing"; then
  fail "current documentation routing requires legacy children.md role"
fi
grep -Fq '特別file roleは要求しない' "$doc_routing" \
  || fail "documentation routing lost explicit non-required fixed topology filename rule"
grep -Fq 'Component Repositoryであること自体は独立Project Documentation treeを要求しない' "$doc_routing" \
  || fail "Component Repository/documentation authority boundary missing"
grep -Fq 'Management Root Repository / Project Root' "$workspace_index" \
  || fail "workspace current-role summary missing Management Root Repository"
grep -Fq 'Component Repository' "$workspace_index" \
  || fail "workspace current-role summary missing Component Repository"
if grep -Fq 'Workspace_Repository:' "$workspace_model"; then
  fail "Workspace Repository reintroduced as current peer role"
fi
grep -Fq '旧用語: Project Repository / Workspace Repository' "$workspace_model" \
  || fail "retired repository role terminology history note missing"
grep -Fq 'Management Root Repository / Component Repositoryをrepository roleとして用いる' "$workspace_ownership" \
  || fail "workspace ownership does not declare current Management Root/Component roles"
grep -Fq 'filesystem上の包含だけからGit ownership / authority / dependencyの親子関係を導かない' "$workspace_ownership" \
  || fail "parent/child repository terminology guard missing"
grep -Fq 'Parent / Child hierarchical project model' "$doc_history" \
  || fail "legacy documentation hierarchy is not preserved/labeled in history"
grep -Fq 'Workspace Repository terminology convergence' "$workspace_history" \
  || fail "legacy Workspace Repository terminology is not preserved/labeled in history"

grep -Fq 'Multi-repository Project routing' artifacts/documentation/PRINCIPLES_AND_ROUTING.md \
  || fail "Artifact documentation lost multi-repository routing model"
if grep -Fq '## Hierarchical projects' artifacts/documentation/PRINCIPLES_AND_ROUTING.md; then
  fail "Artifact documentation reintroduced hierarchical project model"
fi
grep -Fq 'does not automatically make it an independent Project' artifacts/documentation/PRINCIPLES_AND_ROUTING.md \
  || fail "Artifact Component Repository documentation boundary missing"
grep -Fq 'Component Repository primary checkouts live **under the Project Root by default**' artifacts/project/WORKSPACE.md \
  || fail "Artifact workspace lost the positive component containment rule"
grep -Fq 'A task that sets up repository placement and materializes Work checkouts needs both this file and `WORKTREES.md`' artifacts/project/WORKSPACE.md \
  || fail "Artifact workspace lost the WORKTREES handoff"
if grep -Fq 'Workspace Repository' artifacts/project/WORKSPACE.md; then
  fail "Artifact workspace carries retired Workspace Repository terminology (NAL)"
fi
if grep -Fq 'parent/child' artifacts/project/WORKSPACE.md; then
  fail "Artifact workspace carries old parent/child model explanation (NAL)"
fi

# Retired Workspace Repository / parent-child role wording must not survive in
# current normative text or its Artifact projection (explicit old-term and
# negative-guard mentions are exempted by the file locations checked here).
safety_integration=documents/knowledge/subjects/development-safety/S004_INTEGRATION.md
safety_diagnostics=documents/knowledge/subjects/development-safety/S003_DIAGNOSTICS_AND_RECOVERY.md
worktree_materialization=documents/knowledge/subjects/work-identity/S005_WORKTREE_MATERIALIZATION.md
artifact_integration=artifacts/safety/INTEGRATION_AND_CONFIRMATION.md
artifact_diagnostics=artifacts/safety/DIAGNOSTICS_AND_RECOVERY.md
artifact_execution_model=artifacts/execution/EXECUTION_MODEL.md
artifact_commands=artifacts/execution/COMMANDS_AND_CI.md

if grep -Fq 'Workspace Repository' "$safety_integration"; then
  fail "current integration guidance still uses Workspace Repository as a peer role"
fi
if grep -Fq '別Workspace Repository' "$execution_commands"; then
  fail "current CI guidance still treats Workspace Repository as a current repository kind"
fi
if grep -Fq 'Workspace tool' "$workspace_ownership" || grep -Fq 'Workspace ref' "$safety_diagnostics"; then
  fail "retired Workspace tool/ref terminology remains in current normative text"
fi
if grep -Fn '親repository' "$worktree_materialization"; then
  fail "worktree materialization still uses parent-repository wording for the Management Root Repository"
fi
if grep -Fq 'Workspace/Component topology' "$artifact_integration"; then
  fail "Artifact safety reread trigger still uses retired Workspace/Component topology wording"
fi
if grep -Fq 'workspace ref' "$artifact_diagnostics"; then
  fail "Artifact diagnostics still uses retired workspace ref wording"
fi
if grep -Fq 'workspace/tool repository' "$artifact_execution_model"; then
  fail "Artifact execution model still uses retired workspace/tool repository wording"
fi
if grep -Fq 'External workspace/tool dependencies' "$artifact_commands"; then
  fail "Artifact CI guidance still uses retired workspace/tool dependency wording"
fi

# Historical source must still preserve the original hierarchical model.
legacy_doc_source=documents/knowledge/records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md
grep -Fq '## 8. 階層プロジェクト' "$legacy_doc_source" \
  || fail "historical hierarchical-project source was lost"
grep -Fq 'children.md' "$legacy_doc_source" \
  || fail "historical children.md evidence was lost"

# Knowledge effective-status / Decision Lineage guards (Issue #171).
knowledge_model=documents/knowledge/system/KNOWLEDGE_MODEL.md
record_model=documents/knowledge/system/RECORD_MODEL.md
lineage_model=documents/knowledge/system/DECISION_LINEAGE_MODEL.md
subject_model=documents/knowledge/system/SUBJECT_MODEL.md
traceability_model=documents/knowledge/system/TRACEABILITY_MODEL.md
artifact_model=documents/knowledge/system/ARTIFACT_MODEL.md
knowledge_workflow=documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
documentation_index=documents/knowledge/subjects/documentation/INDEX.md
workspace_index=documents/knowledge/subjects/workspace-structure/INDEX.md

grep -Fq 'records   = source completeness' "$knowledge_model" \
  || fail "knowledge model lost source completeness contract"
grep -Fq 'subjects  = semantic completeness + effective-status resolution' "$knowledge_model" \
  || fail "knowledge model lost subject semantic completeness contract"
grep -Fq 'artifacts = runtime relevance / current-effective projection' "$knowledge_model" \
  || fail "knowledge model lost Artifact runtime projection contract"

grep -Fq '後から変化し得る現在評価をimmutable recordへ固定しない' "$record_model" \
  || fail "record model allows mutable current status to be frozen into records"
grep -Fq 'decision_lineage:' "$record_model" \
  || fail "record model lost optional decision lineage metadata"

for relation in adopts supersedes refines corrects rejects validates; do
  grep -Fq "### $relation" "$lineage_model" \
    || fail "decision lineage relation missing: $relation"
done
grep -Fq 'Date is not authority' "$lineage_model" \
  || fail "decision lineage lost date-not-authority rule"
grep -Fq 'Fail closed' "$lineage_model" \
  || fail "decision lineage lost fail-closed conflict handling"
grep -Fq 'Subject disposition accounting' "$lineage_model" \
  || fail "decision lineage lost disposition accounting"

for status in current superseded rejected unresolved; do
  grep -Fq "$status:" "$subject_model" \
    || fail "subject model missing effective status: $status"
done
grep -Fq 'superseded / rejected / obsoleteだからという理由だけでreusable semantic knowledgeを削除しない' "$subject_model" \
  || fail "subject model permits silent deletion of non-current semantic knowledge"
grep -Fq '*_HISTORY.md' "$subject_model" \
  || fail "subject model lost HISTORY semantic-completeness contract"
grep -Fq 'evidence_only' "$subject_model" \
  || fail "subject model lost evidence-only disposition"
grep -Fq 'unresolved' "$subject_model" \
  || fail "subject model lost unresolved conflict state"

grep -Fq 'Decision Lineage traceability' "$traceability_model" \
  || fail "traceability model lost decision-lineage presentation"
grep -Fq 'Current-effective projection gate' "$artifact_model" \
  || fail "Artifact model lost current-effective projection gate"
grep -Fq 'current effectiveと解決されたknowledgeを主入力' "$knowledge_workflow" \
  || fail "knowledge workflow does not gate Artifact projection on current-effective knowledge"
grep -Fq 'Subject disposition accounting' "$knowledge_workflow" \
  || fail "knowledge workflow lost promotion/disposition accounting"

# Context shaping / Negative Alternative Leakage guards (Issues #190 / #196).
context_shaping_index=documents/knowledge/subjects/context-shaping/INDEX.md
context_positive=documents/knowledge/subjects/context-shaping/S001_POSITIVE_FIRST_CONTEXT.md
context_nal=documents/knowledge/subjects/context-shaping/S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md
context_guards=documents/knowledge/subjects/context-shaping/S003_APPLICABILITY_AND_GUARDS.md
artifact_context=artifacts/operation/CONTEXT_SHAPING.md

for file in "$context_shaping_index" "$context_positive" "$context_nal" "$context_guards" "$artifact_context"; do
  require_file "$file"
done

grep -Fq '特定の目的に向けて受け手へcontextを構成・提示する際' "$context_nal" \
  || fail "generalized NAL definition missing from context-shaping"
grep -Fq 'current modelよりalternativeが目立つ' "$context_nal" \
  || fail "generalized NAL lost the prominence-as-symptom distinction"
grep -Fq '文書種別ではなく' "$context_guards" \
  || fail "NAL applicability is no longer purpose-scoped"
grep -Fq 'NALはnegative sentence禁止ではない' "$context_guards" \
  || fail "generalized NAL incorrectly bans negative statements"
grep -Fq 'Positive-firstは文章順序の固定ruleではない' "$context_positive" \
  || fail "Positive-first regressed into a presentation-order rule"

grep -Fq '一般化したcontext shaping / NALのsemantic meaning' "$artifact_model" \
  || fail "Artifact model does not defer generalized NAL semantics to context-shaping"
grep -Fq 'Artifact projectionは、その一般原則のspecialization' "$artifact_model" \
  || fail "Artifact-specific NAL is not modeled as a specialization"
grep -Fq 'Artifact向けの削減規則をrecords / subjectsへ逆適用してsemantic knowledgeを削除してはならない' "$artifact_model" \
  || fail "Artifact model allows compression rules to back-propagate into knowledge preservation"
grep -Fq '一般化した **Negative Alternative Leakage (NAL)** はcontext shapingのアンチパターン' "$subject_model" \
  || fail "Subject model lost generalized NAL preservation boundary"
grep -Fq 'current positive modelを直接表現する' "$knowledge_workflow" \
  || fail "Knowledge workflow lost positive-first Artifact projection"
grep -Fq 'Positive-first context shaping / Negative Alternative Leakage (NAL)' documents/project/ARTIFACT_ARCHITECTURE_V2.md \
  || fail "Artifact architecture lost generalized NAL specialization"
grep -Fq 'Negative Alternative Leakage (NAL)' "$artifact_context" \
  || fail "Artifact runtime guidance lost NAL"
grep -Fq 'Judge the role of the information, not the document type.' "$artifact_context" \
  || fail "Artifact runtime guidance lost purpose-based applicability"
grep -Fq 'context-shaping S001 / S002 / S003' documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md \
  || fail "Artifact projection map does not trace CONTEXT_SHAPING.md"
grep -Fq 'generalized context shaping / Negative Alternative Leakageのsemantic meaning' "$lineage_model" \
  || fail "Decision Lineage model lost generalized NAL semantic ownership"
if grep -Fq 'old modelを禁止するnegative guardがcurrent ruleなら、old model本体がsupersededでもnegative guardはprojectionできる' "$artifact_model"; then
  fail "Artifact model restored automatic negative-guard projection"
fi
if grep -Fq 'old modelへのnegative guard自体がcurrent ruleならprojectionできる' "$lineage_model"; then
  fail "Decision Lineage model restored automatic negative-guard projection"
fi

# Reference fixture: old source is preserved, subjects expose current + superseded,
# Artifact v2 projects current guidance and only a needed negative guard.
grep -Fq '## 8. 階層プロジェクト' "$legacy_doc_source" \
  || fail "Decision Lineage fixture lost the old hierarchical source"
grep -Fq '## Decision lineage — hierarchical project model' "$documentation_index" \
  || fail "documentation fixture lacks explicit decision lineage"
grep -Fq 'Current:' "$documentation_index" \
  || fail "documentation fixture lacks current classification"
grep -Fq 'Superseded:' "$documentation_index" \
  || fail "documentation fixture lacks superseded classification"
grep -Fq 'S006_HISTORY.md' "$documentation_index" \
  || fail "documentation fixture does not preserve old model in subject history"
grep -Fq '## Decision lineage — repository role model' "$workspace_index" \
  || fail "workspace fixture lacks explicit decision lineage"
grep -Fq 'S003_HISTORY.md' "$workspace_index" \
  || fail "workspace fixture does not preserve old repository model in subject history"
grep -Fq 'Management Root Repository' artifacts/project/WORKSPACE.md \
  || fail "Artifact fixture lost current Management Root Repository guidance"
grep -Fq 'Component Repository' artifacts/project/WORKSPACE.md \
  || fail "Artifact fixture lost current Component Repository guidance"
grep -Fq 'Filesystem containment is placement only' artifacts/project/WORKSPACE.md \
  || fail "Artifact fixture lost the containment/ownership axis separation"

# Management Root Repository terminology guards (Issue #192).
grep -Fq '管理ルートリポジトリ' "$workspace_index" \
  || fail "workspace index lost the Japanese canonical role name"
grep -Fq '管理ルートリポジトリ' "$workspace_model" \
  || fail "workspace model lost the Japanese canonical role name"
grep -Fq 'Project Repository` はこのroleの旧current名称' "$workspace_ownership" \
  || fail "workspace ownership lost Project Repository superseded-terminology note"
grep -Fq 'Management Root Repository terminology adoption' "$workspace_history" \
  || fail "workspace history does not preserve the terminology adoption record"
if grep -rlq 'Project Repository' artifacts/; then
  fail "Artifact runtime still carries retired Project Repository terminology (NAL)"
fi

# Workspace physical topology guards (Issue #191).
grep -Fq 'defaultではProject Root配下に配置する' "$workspace_model" \
  || fail "workspace model lost the positive primary-checkout containment rule"
grep -Fq 'primary_checkout_placement:' "$workspace_model" \
  || fail "workspace model lost the structured placement contract"
grep -Fq 'Project Rootのsiblingへのad-hoc checkout/worktree配置は現行guidanceが正当化しない' "$workspace_model" \
  || fail "workspace model lost the sibling-placement guard"
grep -Fq 'Component Repository primary checkoutのdefault物理配置' "$workspace_index" \
  || fail "workspace index does not own the physical placement contract"
grep -Fq '2026-10-04-workspace-physical-topology' "$workspace_index" \
  || fail "workspace index lost the physical-topology decision lineage"
grep -Fq '## Physical containment clarification' "$workspace_history" \
  || fail "workspace history lost the #167 containment scope clarification"
grep -Fq '167が廃止したのはrole / authority / documentation上のparent/child hierarchy' "$workspace_history" \
  || fail "workspace history conflated role-hierarchy removal with containment removal"
grep -Fq '先に `../workspace-structure/` の静的配置契約' documents/knowledge/subjects/work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md \
  || fail "work-identity lost the static-placement connection"
require_file tests/scenarios/multi-repo-workspace-bootstrap/scenario.conf
require_file tests/scenarios/multi-repo-workspace-bootstrap/prepare.sh
require_file tests/scenarios/multi-repo-workspace-bootstrap/PROMPT.md
require_file tests/scenarios/multi-repo-workspace-bootstrap/EXPECTATIONS.md
require_file tests/repositories/multi-repo-bootstrap/scripts/verify-workspace.sh
require_file tests/repositories/multi-repo-bootstrap/workspace/repositories.conf
require_file tests/repositories/multi-repo-bootstrap/.worktrees/PROJECT_COORDINATION.md

# Targeted multi-generation subject lineage guards (Issues #174 / #175).
encap_altitude=documents/knowledge/subjects/encapsulation-horizon/S004_CONCEPT_ALTITUDE.md
encap_guards=documents/knowledge/subjects/encapsulation-horizon/S008_OPERATIONAL_GUARDS.md
code_testing=documents/knowledge/subjects/code-design/S009_TESTING_AND_RUNTIME.md
code_performance=documents/knowledge/subjects/code-design/S011_PERFORMANCE_SHAPED_INTERACTION.md
code_priority=documents/knowledge/subjects/code-design/S012_DESIGN_PRIORITY.md
engineering_index=documents/knowledge/subjects/engineering-operation/INDEX.md
safety_index=documents/knowledge/subjects/development-safety/INDEX.md
work_materialization=documents/knowledge/subjects/work-identity/S005_WORKTREE_MATERIALIZATION.md
work_validation=documents/knowledge/subjects/work-identity/S007_VALIDATION.md

grep -Fq '## Decision lineage — Concept Generality / Semantic Identity' "$encap_altitude" \
  || fail "Concept Altitude correction lost explicit Decision Lineage"
grep -Fq 'Superseded interpretation:' "$encap_altitude" \
  || fail "Concept Altitude predecessor is not classified as non-current"

grep -Fq '## Decision lineage — compatible public evolution' "$encap_guards" \
  || fail "Contract L2 correction lost explicit Decision Lineage"
grep -Fq 'additive shape alone is not compatibility evidence' "$encap_guards" \
  || fail "Contract L2 current rule no longer rejects additive-as-proof"

grep -Fq '## Decision lineage — contract conformance and requested outcome' "$code_testing" \
  || fail "Testing correction lost explicit Decision Lineage"
grep -Fq 'passing Contract Test does not by itself establish task correctness' "$code_testing" \
  || fail "Testing current rule lost requested-outcome distinction"

grep -Fq '## Decision lineage — performance-shaped contract evolution' "$code_performance" \
  || fail "Performance evolution lost explicit Decision Lineage"
grep -Fq 'Previous non-current state:' "$code_performance" \
  || fail "Performance proposal/hold lineage is no longer classified as non-current"
grep -Fq 'that hold is resolved; it is not an unresolved current decision' "$code_performance" \
  || fail "Historical performance hold regressed into an unresolved current state"

grep -Fq '## Decision lineage — Mistake Prevention Priority' "$code_priority" \
  || fail "Design priority refinement lost explicit Decision Lineage"
grep -Fq 'Refined predecessor:' "$code_priority" \
  || fail "Design priority predecessor refinement is not explicit"

grep -Fq '## Decision lineage — verification completion and reporting' "$engineering_index" \
  || fail "Engineering Operation correction lost INDEX Decision Lineage"
grep -Fq 'Superseded completion interpretation:' "$engineering_index" \
  || fail "Contract-Test-only completion is not marked superseded"

grep -Fq '## Decision lineage — safety responsibility split' "$safety_index" \
  || fail "Development Safety predecessor/current responsibility lineage missing"
grep -Fq '../development-execution/S005_HISTORY.md' "$safety_index" \
  || fail "Development Safety does not route predecessor umbrella semantics to preserved history"

grep -Fq '## Decision lineage — Worktree Materialization Contract' "$work_materialization" \
  || fail "Worktree materialization adoption lineage missing"
grep -Fq 'Candidate / evidence path:' "$work_materialization" \
  || fail "Worktree materialization candidates/evidence are not distinguished from adopted contract"

grep -Fq '## Decision lineage — reference implementation validation' "$work_validation" \
  || fail "Worktree validation fix lineage missing"
grep -Fq 'Corrected predecessor evidence:' "$work_validation" \
  || fail "Worktree validation predecessor evidence is not scope-corrected"
grep -Fq 'validation is evidence for the Worktree Command Contract' "$work_validation" \
  || fail "Worktree validation is being conflated with effective status"

# Historical candidates must not claim current canonical authority.
for file in documents/project/migration/semantic-preservation-candidate/*.md; do
  if grep -Eq '^(document_type: "canonical_knowledge"|authority: "canonical_source")' "$file"; then
    fail "historical candidate still claims current authority: $file"
  fi
done

printf 'PASS: knowledge structure, source snapshots, links, and legacy inventory\n'
