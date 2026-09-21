# Work Identity

このsubjectは、1つの具体的な開発目標を表すWork Identityと、そのlifecycle・Work Root・Work Documents・Git/worktree・resource ownershipに関するknowledgeを扱う。

## 現在の構成

```text
work-identity/
├─ INDEX.md
├─ MODEL.md
├─ GIT_MATERIALIZATION.md
├─ WORKTREE_COMMAND_CONTRACT.md
└─ REFERENCE_VALIDATION.md
```

### MODEL.md

Work Identityの意味、確定時期、命名、Work Root、Work Documents、Project Documentsとの関係、resource scope、Work lifecycleなど、全体モデルを扱う。

### GIT_MATERIALIZATION.md

Project Repository自身がWorkへ参加する場合のnested worktree materialization問題、実験、採用したGit-native手順、recreation/compatibility境界を扱う。

### WORKTREE_COMMAND_CONTRACT.md

Work Identityからrepository-specific worktreeを操作するpublic semantic operations、入力、preflight、postconditions、rollback、status/remove contractを扱う。

### REFERENCE_VALIDATION.md

上記contractのreference implementation検証、fresh-clone validation、reviewで発見した問題と修正、focused revalidationを扱う。

## Traceability

現段階のsubject本文は、情報劣化を避けた初期migrationとして、次のrecord payloadと同一blobで開始している。

| Subject document | Source record payload |
|---|---|
| `MODEL.md` | `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md` |
| `GIT_MATERIALIZATION.md` | `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md` |
| `WORKTREE_COMMAND_CONTRACT.md` | `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md` |
| `REFERENCE_VALIDATION.md` | `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md` |

これらの本文中には、作成当時の `source_log` status、旧artifactへの反映方針、旧authority関係などの歴史的表現が残っている。

それらを「現在も旧artifactが正本である」という意味で読んではならない。現在のknowledge authorityは `documents/knowledge/` 全体のsystem規則と後続recordを含めて判断する。

今後subject-nativeに再整理する際は、recordへのtraceabilityを維持し、意味・条件・反論・検証結果を失わないこと。
