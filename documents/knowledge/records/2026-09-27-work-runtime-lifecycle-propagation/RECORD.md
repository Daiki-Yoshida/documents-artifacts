# Source record: 2026-09-27-work-runtime-lifecycle-propagation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/77"
source_issue: 77
source_created_at: "2026-09-27T02:05:42Z"
retrieved_date: "2026-09-27"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。Issue本文は会話の原文そのものとは限らない"
関係: "work-runtime-resource-scoping blind run (Issue #75 / PR #76) で観測されたlifecycle identity propagation失敗 — Work-specific configがwork-up/work-verify/work-configには伝播したがwork-downへ伝播しなかった — をknowledge→Artifactへ反映する採用source"
関連source:
  - "tests/results/work-runtime-resource-scoping/2026-09-27-devin/REPORT.md (raw execution report。本recordでは内容を転記せずpathのみ参照)"
  - "tests/results/work-runtime-resource-scoping/2026-09-27-devin/evidence/ (machine evidence)"
  - "tests/evaluations/work-runtime-resource-scoping/2026-09-27-devin.md (evaluator照合結果)"
  - "https://github.com/Daiki-Yoshida/documents-artifacts/pull/76 (run result PR)"
successful_observations:
  - "selective Project-vs-Work resource scope判断 (image/cache共有 + DB/port/network/container分離)"
  - "deterministic Work Identity由来のresource naming"
failure_observations:
  - "Work-specific configurationがcreate/config/verify系には伝播したがteardown (work-down) へは伝播しなかった"
derived_rule: "resolved scoped-resource identity/configurationはlifecycle全体で一貫していなければならない"
```

## 取得本文（原文）

~~~~text
## Purpose

The blind `work-runtime-resource-scoping` run exposed a reusable-guidance gap.

Historical evidence:

- Issue #75
- PR #76
- Evaluation:
  `tests/evaluations/work-runtime-resource-scoping/2026-09-27-devin.md`

The agent correctly classified runtime resources by scope, but the checked-in command surface propagated Work-specific runtime configuration to:

```text
work-up
work-verify
work-config
```

and omitted it from:

```text
work-down
```

so teardown did not reconstruct the same Work-specific Compose model used for creation.

This Issue should turn that observed failure into reusable knowledge and Artifact guidance.

## Baseline

Start from latest `main`.

At Issue creation:

```text
832aac3bed67da15ccf3128748b59f7b26f3e544
```

If `main` legitimately advances, use latest main and record the actual starting SHA.

## Knowledge flow

Preserve the repository's knowledge pipeline:

```text
observed behavior-test evidence
→ documents/knowledge/records/
→ documents/knowledge/subjects/
→ artifacts/
```

Do not patch only the Artifact leaf while skipping the owning knowledge subjects.

## 1. Add a source record

Create a new record for this observed behavioral finding under:

```text
documents/knowledge/records/
```

Use the repository's current record naming/metadata conventions.

The record should capture at least:

- source behavior run: Issue #75 / PR #76;
- evaluator result path;
- successful observations:
  - selective Project-vs-Work resource scope;
  - deterministic Work identity;
  - shared image/cache;
  - isolated DB/port;
- failure:
  - Work-specific configuration propagated to create/config/verify but omitted from teardown;
- why this matters:
  - lifecycle operations can resolve different physical resources even while using the same logical Work Identity;
  - a one-off successful live run does not make an asymmetric checked-in command contract safe;
- resulting reusable rule:
  - a resolved scoped-resource configuration must remain identity-consistent across the complete lifecycle.

Do not rewrite or fabricate historical evidence.

## 2. Update owning knowledge subjects

### Work Identity owner

Update:

```text
documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md
```

Strengthen **Resource Identity propagation**.

Add the concept that Work/resource identity propagation is not only a naming convention between subsystems; the same resolved scoped-resource identity/configuration must be carried through all operations that manage that resource.

Semantically:

```text
resolve scope + identity once
  ↓
materialize / create / start
inspect / status / config
verify / use
stop
cleanup / remove
```

These operations must refer to the same resource set.

Rules should include:

- do not let lifecycle counterpart commands silently fall back to default Project resource names;
- if environment variables/config files/compose project names/selectors determine resource identity, every lifecycle operation must resolve them consistently;
- avoid independent duplicate derivations that can drift;
- prefer a single resolver/config source when identity derivation is non-trivial;
- cleanup must remain scoped and destructive semantics remain separate.

Do not prescribe one Compose-specific implementation as universal policy.

### Development execution owner

Update:

```text
documents/knowledge/subjects/development-execution/S002_HOST_AND_CONTAINER.md
```

Add runtime materialization guidance:

- container/network/volume/port identity configuration must be symmetric through lifecycle commands;
- an operation that created resource `R(work)` must not later stop/remove `R(default)` because scoped configuration was omitted;
- rendered/config inspection should verify the same resolved identities for start and teardown paths when practical.

Update:

```text
documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md
```

as appropriate for the public command contract:

- command families such as `<scope>-up`, `<scope>-status`, `<scope>-verify`, `<scope>-down`, scoped cleanup should share the same target/scope resolution;
- command names alone are not sufficient if their internal scope resolution differs;
- complex identity derivation should have one project-owned resolver/script rather than duplicated shell/Make/JS algorithms where practical;
- normal stop and destructive purge remain separate.

Keep ownership boundaries clear: Work/resource semantics remain primarily in work-identity; command implementation/public routing remains development-execution.

## 3. Update Artifact v2

Reflect the distilled rules minimally in:

```text
artifacts/project/WORK_LIFECYCLE.md
artifacts/execution/HOST_AND_CONTAINER.md
artifacts/execution/COMMANDS_AND_CI.md
```

### WORK_LIFECYCLE.md

Add a concise lifecycle identity consistency rule.

A suitable semantic statement:

```text
A Work-scoped resource is not identified only at creation time.
The same resolved scope/identity must target that resource through
create/start → inspect/verify → stop → cleanup.
```

### HOST_AND_CONTAINER.md

Add runtime-specific guidance that env/config/Compose project/resource-name selectors must be propagated consistently across counterpart operations.

Do not make Compose mandatory.

### COMMANDS_AND_CI.md

Add that a scoped command family must use one consistent scope/identity resolver. If identity logic is non-trivial, prefer a project-owned script/config resolver over reimplementing it separately in multiple Make recipes/languages.

Keep the Artifact concise; do not copy the full subject prose.

## 4. Traceability / indexes

Update any required:

- record indexes;
- subject source lists;
- knowledge traceability metadata;
- generated/structural references

according to existing repository conventions.

Do not introduce a parallel documentation system.

## 5. Validation

Run:

```bash
bash tests/test-artifacts.sh
bash tests/test-knowledge-integrity.sh
bash tests/test-agent-harness.sh
```

Also inspect the resulting Artifact route to ensure a future agent handling Work-specific runtime operations can reach both:

```text
project/WORK_LIFECYCLE.md
execution/HOST_AND_CONTAINER.md
```

without needing a new router solely for this rule.

## 6. Revalidation design

Do **not** rewrite historical raw result/evidence for the failed run.

Do not change:

```text
tests/results/work-runtime-resource-scoping/2026-09-27-devin/**
tests/evaluations/work-runtime-resource-scoping/2026-09-27-devin.md
```

As part of this Issue, decide whether the best follow-up is:

A. a focused new scenario such as `work-runtime-lifecycle-propagation`; or
B. a new run of a clearly versioned/new scenario definition derived from the same fixture.

Prefer a new focused scenario if it gives a cleaner blind test and preserves the historical meaning of the existing scenario.

Do not execute the new blind run in this Issue unless the Issue is explicitly extended later. This Issue's main job is the knowledge/Artifact correction plus a merge-ready revalidation definition if useful.

### Focus of future revalidation

A future blind test should detect the exact class of bug observed in #76:

- Work-specific create/start resolves resource set A;
- config/status/verify resolve A;
- stop/down must also resolve A;
- cleanup/remove, if implemented, must resolve A;
- default Project resources must not be accidentally targeted;
- shared Project-scoped resources must not be deleted.

A deterministic checker should validate lifecycle identity propagation without requiring Docker daemon introspection alone.

## Scope

Expected changes may include:

```text
documents/knowledge/records/<new-record>/**
documents/knowledge/subjects/work-identity/S004_LIFECYCLE_AND_RESOURCES.md
documents/knowledge/subjects/development-execution/S002_HOST_AND_CONTAINER.md
documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md
artifacts/project/WORK_LIFECYCLE.md
artifacts/execution/HOST_AND_CONTAINER.md
artifacts/execution/COMMANDS_AND_CI.md
relevant indexes / traceability metadata
optional focused scenario definition
tests/INDEX.md
documents/project/AGENT_ARTIFACT_TEST_HARNESS.md
```

Do not modify historical run/evaluation files listed above.

## VCS / PR

- latest main;
- work branch;
- no direct main commit;
- commit / push / PR;
- reference this Issue;
- final report in PR body;
- include exact knowledge/Artifact files changed;
- include test results;
- explicitly state historical run/evidence remained unchanged.

Suggested commit:

```text
docs: propagate scoped resource identity through lifecycle
```

## Completion

Done when the observed #76 failure has a traceable knowledge record, owning subjects and Artifact guidance encode lifecycle-wide identity consistency, tests pass, historical evidence is untouched, and the next blind revalidation path is clearly defined.

~~~~
