# RuleClass implementation — review and rollout plan

```yaml
document_type: "repository_local_implementation_plan"
authority: "derived_from_documents/knowledge/"
work_identity: "feat/rule-class-contract"
base_main: "960c3682fe9172b90b60d05c22078eb1cafc0df1"
issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/219"
```

## Goal

Expose the adopted `RuleClass1/2/3` model to AI consumers without making
`artifacts/INDEX.md` or every leaf a duplicated 222-row policy registry.
The Issue #219 classification inventory remains the **candidate review
ledger**, not an independent runtime authority.

## Projection design

1. Owner messages/Issue adoption are retained as immutable source events
   under `documents/knowledge/records/2026-10-31-rule-class-adoption/`.
2. The primary classification/authority meaning lives in
   `documents/knowledge/subjects/engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md`.
   Work applicability lives with `work-identity/S001_IDENTITY_MODEL.md`;
   engineering routing with `engineering-operation/S001_CHANGE_LIFECYCLE.md`.
3. `documents/knowledge/system/ARTIFACT_MODEL.md` governs semantics-preserving
   projection. Runtime `artifacts/INDEX.md` defines RC1/RC2/RC3 once.
   Relevant leaves carry compact local RC markers only where ambiguity
   changes the agent's decision.
4. A Project adopting Artifact v2 must use Work Identity for concrete
   implementation, while the actual Git branch/worktree, container and
   language/framework choices remain separate. Owner/project authority is
   not implied by the mere existence of a Work.
5. A required Project-owned Artifact entry is **recommended** when the
   Project needs reliable enforcement in new chats. Both documented hook
   variants remain possible until entry-policy evidence and Owner decisions
   justify a distinct change.

## Scope and status

- **Implemented on this branch:** RC definitions, canonical authority and
  Work Identity applicability, root runtime projection, selected inline
  RC1/RC2/RC3 markers, Owner/source records and targeted test fixtures.
- **Under review:** 222 candidate classification units from Issue #219,
  including 143 NL3→RC3, four RC3-scope-change candidates, 47 RC2, and
  28 RC1. Terminology has been adopted; this inventory does **not**
  individually approve every candidate's semantics.
- **Deferred:** mechanical rewrite of all 42 Artifact Markdown files,
  changes to 36 historical agent scenario expectations, mandatory universal
  entry hook injection, target project synchronization, and new GitHub Actions.

## Validation and evidence

- `bash tests/test-artifacts.sh` (routing/sync)
- `bash tests/test-knowledge-integrity.sh` (canonical/record/projection)
- `bash tests/test-agent-harness.sh` (scenario fixture integrity)
- Fresh blind runs of `rule-class-work-adoption` (no confirmed Work) and
  `rule-class-work-continuation` (confirmed Work from previous session),
  with evaluator-only `EXPECTATIONS.md` withheld until evaluation.
- Replay representative existing test scenarios before declaring broad
  behavior compatibility. Existing recordings remain historical evidence,
  not a current model PASS by implication.

Unrun checks must be labeled NOT RUN; neither a static assertion nor a
deterministic shell fixture proves an agent's reading or judgment.
