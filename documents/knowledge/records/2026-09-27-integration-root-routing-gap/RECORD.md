# Source record: 2026-09-27-integration-root-routing-gap

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/84"
source_issue: 84
source_created_at: "2026-09-27T13:04:23Z"
retrieved_date: "2026-09-27"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。Issue本文は会話の原文そのものとは限らない"
関係: "Artifact v2 root routerにrepository integration/merge/rebase taskのrouteが欠落している delivery/routing projection gap — semantic authority自体は既存subjectに存在 — を修正する採用source"
関連source:
  - "https://github.com/Daiki-Yoshida/documents-artifacts/issues/81 (coverage audit — routing gap発見の起点)"
  - "https://github.com/Daiki-Yoshida/documents-artifacts/issues/82 (integration-head-revalidation scenario定義Issue)"
  - "https://github.com/Daiki-Yoshida/documents-artifacts/pull/83 (scenario definition PR。merge済)"
既存semantic_authority:
  - "documents/knowledge/subjects/development-safety/S004_INTEGRATION.md"
  - "documents/knowledge/subjects/engineering-operation/S005_VERIFICATION_AND_DONE.md"
  - "documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md"
observations:
  - "artifacts/INDEX.md の Route by task にrepository integration / merge / rebaseのrouteが存在しない"
  - "semantic leaf (safety/INTEGRATION_AND_CONFIRMATION.md, operation/VERIFICATION_AND_DONE.md) は存在するがrootから到達不能"
  - "integration-head-revalidationはdefinition readyだが、routing未修正のままblind runするとguidance未到達とagent失敗を区別できないため意図的にblockされていた (definition ready / routing prerequisite)"
derived_rule: "semantic ruleの欠落ではなくdelivery/routing projectionの欠落 — root INDEXにintegration task routeを投影して修正する。integration semantic rule本文は変更しない"
```

## 取得本文（原文）

~~~~text
## Purpose

Fix the Artifact v2 root-routing gap discovered while reviewing the new integration-head-revalidation behavior scenario.

Discovery context:
- coverage audit: Issue #81
- scenario definition: Issue #82 / PR #83
- current scenario status: definition ready, blind run intentionally blocked on routing prerequisite

Current reusable integration guidance already exists:
- artifacts/safety/INTEGRATION_AND_CONFIRMATION.md
- artifacts/operation/VERIFICATION_AND_DONE.md

But root artifacts/INDEX.md does not route repository integration / merge / rebase tasks to that guidance.

A blind run now would conflate:
- agent failed to adopt integration guidance
- Artifact root never routed the task to integration guidance

Correct the routing first, then unblock the blind run.

## Baseline

Start from latest main.

At Issue creation:
84f5e980423f9538194d5b4a91b050ee92545ec7

If main legitimately advances, use latest main and record the actual starting SHA.

## Classification

This is primarily an Artifact delivery/routing correction, not a new integration semantic rule.

Existing semantic authority already exists in:
- documents/knowledge/subjects/development-safety/S004_INTEGRATION.md
- documents/knowledge/subjects/engineering-operation/S005_VERIFICATION_AND_DONE.md
- documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md

Do not duplicate those rules into a new subject.

The knowledge-system Artifact model already requires:
- task type → relevant file routing
- shallow routing chain
- progressive disclosure

Therefore the missing piece is the concrete Artifact projection/routing map.

## 1. Source record

Create:
documents/knowledge/records/2026-09-27-integration-root-routing-gap/

Use existing record conventions.

Capture the current Issue body as the source event, with metadata tracing:
- Issue #81 coverage audit;
- Issue #82 / PR #83 scenario definition;
- evaluator review finding that root artifacts/INDEX.md lacks an integration route;
- existing semantic owner leaf safety/INTEGRATION_AND_CONFIRMATION.md;
- reason blind run was intentionally blocked.

Do not rewrite historical Issues/PRs.

## 2. Artifact architecture routing map

Update:
documents/project/ARTIFACT_ARCHITECTURE_V2.md

Add a concise repository-integration routing entry under the existing task routing, semantically:

repository integration / merge / rebase
→ safety/INTEGRATION_AND_CONFIRMATION.md
→ operation/VERIFICATION_AND_DONE.md

Optional follow-ups:
- operation/VERSION_CONTROL_AND_REPORTING.md when commit/push/reporting authority matters;
- project/WORKSPACE.md when repository ownership/topology matters.

Do not duplicate full leaf rules.

## 3. Root Artifact router

Update:
artifacts/INDEX.md

Add an explicit task route for repository integration / merge / rebase to:
- safety/INTEGRATION_AND_CONFIRMATION.md
- operation/VERIFICATION_AND_DONE.md

Keep the root INDEX small. Do not copy integration rule bodies into the root.

## 4. Directory routers

Review:
- artifacts/safety/INDEX.md
- artifacts/operation/INDEX.md

They appear already correct. Do not modify unless a real inconsistency is found.

## 5. Revalidation scenario status

Update:
- tests/INDEX.md
- documents/project/AGENT_ARTIFACT_TEST_HARNESS.md

Change integration-head-revalidation from:
definition ready / routing prerequisite

to:
definition ready / run pending

Only after root routing is corrected in the same branch.

Do not execute the blind run in this Issue.

## 6. Deterministic validation

Run:
- bash tests/test-artifacts.sh
- bash tests/test-knowledge-integrity.sh
- bash tests/test-agent-harness.sh

Also:
bash tests/scripts/prepare-agent-test.sh --scenario integration-head-revalidation --force

Confirm generated documents/artifacts/INDEX.md contains the integration route and it reaches:
- documents/artifacts/safety/INTEGRATION_AND_CONFIRMATION.md
- documents/artifacts/operation/VERIFICATION_AND_DONE.md

Confirm scenario topology remains:
- current branch main;
- feature/export exists;
- branches diverged;
- repo clean;
- no EXPECTATIONS / prepare hook leakage.

Reset afterward.

## 7. Scope

Expected:
- documents/knowledge/records/2026-09-27-integration-root-routing-gap/**
- documents/project/ARTIFACT_ARCHITECTURE_V2.md
- artifacts/INDEX.md
- tests/INDEX.md
- documents/project/AGENT_ARTIFACT_TEST_HARNESS.md

Possible only if genuinely required:
- documents/knowledge/system/ARTIFACT_MODEL.md

Do not modify:
- documents/knowledge/subjects/**
- artifacts/safety/INTEGRATION_AND_CONFIRMATION.md
- artifacts/operation/VERIFICATION_AND_DONE.md
- tests/scenarios/integration-head-revalidation/**
- tests/repositories/integration-revalidation/**
- tests/results/**
- tests/evaluations/**
- tests/scripts/**

unless an independently discovered defect requires it and is explicitly reported.

## 8. VCS / PR

- latest main;
- work branch;
- no direct main commit;
- commit;
- push;
- PR to main;
- reference this Issue, #81, and #83;
- report validation results;
- explicitly state that no integration semantic rule changed — only delivery/routing projection.

Suggested commit:
docs: route repository integration from Artifact root

## Completion

Done when:
- the routing-gap source event is recorded;
- Artifact architecture routing map includes repository integration;
- root artifacts/INDEX.md directly routes integration tasks to existing integration/verification guidance;
- scenario status is unblocked to run-pending;
- deterministic tests pass;
- prepared target contains the corrected route;
- blind behavior run has not yet been executed.


~~~~
