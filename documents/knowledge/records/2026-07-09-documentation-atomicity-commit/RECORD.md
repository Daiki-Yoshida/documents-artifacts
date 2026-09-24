# Source record: 2026-07-09-documentation-atomicity-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/documentation-strategy"
source_commit: "33dabee05ac404ac7b32cb2542997fa4ff5ae635"
source_url: "https://github.com/Daiki-Yoshida/documentation-strategy/commit/33dabee05ac404ac7b32cb2542997fa4ff5ae635"
source_author_date: "2026-07-09T12:59:50Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
Replace git workflow rule with documentation atomicity policy

Remove the generic "standard git workflow (PR/merge)" rule that conflicted
with design-principles' branch-creation policy. Documentation has different
version-control needs than code: atomicity matters more than branch isolation.

- Add atomicity rule: all related docs updated together in one commit
- Add no_branch_for_docs rule: do not branch for documentation-only changes
- Reference design-principles AI_WORKFLOW.md for code-branching concerns

Generated with [Devin](https://devin.ai)

Co-Authored-By: Devin <158243242+devin-ai-integration[bot]@users.noreply.github.com>
~~~~

## GitHub API patch snapshot

### `artifacts/DOCUMENT_WORKFLOW.md`

~~~~diff
@@ -290,7 +290,8 @@ rule: "When in doubt, ask the user. Structural changes to documentation affect e
 
 ```yaml
 version_control: "Documents are managed in git alongside source code."
-multi_developer: "Standard git workflow (PR/merge) applies to documentation."
+atomicity: "Documentation must stay atomic — all related documents are updated together in one commit. Do NOT split documentation updates across branches; a branch with different documentation state from the main branch is a defect, not a feature."
+no_branch_for_docs: "Do NOT create branches for documentation-only changes. Commit directly to the working branch. Branching is a code-development concern (see design-principles AI_WORKFLOW.md), not a documentation concern."
 update_frequency: "Change-triggered — update documents when the code or architecture changes."
 maintenance: "Review documentation during code review. If a PR changes architecture, it should also update PROJECT.md."
 document_sync: "The AI agent's constraint 'update_related_documents_when_changing_project' enforces this."
~~~~
