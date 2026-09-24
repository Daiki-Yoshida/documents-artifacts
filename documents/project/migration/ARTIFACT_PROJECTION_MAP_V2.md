# Artifact v2 Projection Map — Initial

```yaml
document_type: "repository_local_projection_map"
status: "initial"
date: "2026-09-24"
authority: "../ARTIFACT_ARCHITECTURE_V2.md"
```

このmapはartifact本文のauthorityではない。
current subjectsからどのAI-facing leafへprojectionするかを保守するためのrepository-local mappingである。

## design/

| Artifact | Primary subject input |
|---|---|
| `BOUNDARY_HORIZON.md` | encapsulation-horizon S001 / S002 / S003 / S006 |
| `CONTRACTS.md` | encapsulation-horizon S005 / S008 + code-design S010 |
| `RESPONSIBILITY.md` | encapsulation-horizon S002 / S003 / S006 + code-design S012 |
| `CONCEPT_ALTITUDE.md` | encapsulation-horizon S004 |
| `STATE_AND_CONSISTENCY.md` | code-design S004 + relevant encapsulation-horizon contract guards |

YAGNI across the Horizonは `BOUNDARY_HORIZON.md` と `CONTRACTS.md` の接続規則として扱う。
同じ本文を両方へ複製せず、boundary側は適用強度、contract側はsmall surface / strong contractを所有する。

## implementation/

| Artifact | Primary subject input |
|---|---|
| `CODE_STRUCTURE.md` | code-design S001 / S002 / S005 |
| `DEPENDENCIES.md` | code-design S003 / S006 |
| `DOMAIN_AND_DATA.md` | code-design S004 / S007 |
| `FAILURE_AND_ASYNC.md` | code-design S008 |
| `TESTING.md` | code-design S009 + S010のverification distinction |
| `COMPATIBILITY.md` | code-design S010 + encapsulation-horizon S008 contract levels |
| `PERFORMANCE.md` | code-design S011 + S012 |

## operation/

| Artifact | Primary subject input |
|---|---|
| `CHANGE_LIFECYCLE.md` | engineering-operation S001 |
| `SCOPE_AND_AUTHORITY.md` | engineering-operation S002 |
| `PRE_IMPLEMENTATION_SCAN.md` | engineering-operation S003 / S004 |
| `VERIFICATION_AND_DONE.md` | engineering-operation S005 |
| `VERSION_CONTROL_AND_REPORTING.md` | engineering-operation S006 |
| `BROWNFIELD.md` | engineering-operation S007 |

## documentation/

| Artifact | Primary subject input |
|---|---|
| `PRINCIPLES_AND_ROUTING.md` | documentation S001 / S002 |
| `WORKFLOW_AND_MAINTENANCE.md` | documentation S003 / S004 + work-identity S003 reconciliation |
| `FORMAT_AND_GIT.md` | documentation S005 |

## project/

| Artifact | Primary subject input |
|---|---|
| `WORKSPACE.md` | workspace-structure S001 / S002 |
| `WORK_IDENTITY.md` | work-identity S001 / S002 / S003 |
| `WORK_LIFECYCLE.md` | work-identity S004 |
| `WORKTREES.md` | work-identity S005 / S006 / S007 |

## execution/

| Artifact | Primary subject input |
|---|---|
| `EXECUTION_MODEL.md` | development-execution S001 |
| `HOST_AND_CONTAINER.md` | development-execution S002 |
| `COMMANDS_AND_CI.md` | development-execution S003 |
| `ADOPTION_AND_MIGRATION.md` | development-execution S004 |

## safety/

| Artifact | Primary subject input |
|---|---|
| `SAFETY_PRINCIPLES.md` | development-safety S001 |
| `DESTRUCTIVE_OPERATIONS.md` | development-safety S002 / S005 |
| `DIAGNOSTICS_AND_RECOVERY.md` | development-safety S003 |
| `INTEGRATION_AND_CONFIRMATION.md` | development-safety S004 / S005 |

## Excluded by default

各subjectの `*_HISTORY.md` はartifactへ通常projectionしない。

source / provenance / migration説明もAI runtime guidanceには含めず、repository側のknowledgeと本mapに残す。

history由来の情報でも現在採用されている規範の理解に不可欠な場合は、historyであることを理由に自動除外せずcurrent normative subjectへ先に昇格させてからartifactへprojectionする。
