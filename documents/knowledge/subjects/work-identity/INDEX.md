# Work Identity

このsubjectは、1つの具体的な開発目標を意味上の単位として扱う **Work Identity** と、そのownership・lifecycle・Work Root・Work Documents・repository/Git worktree・resource identityを扱う。

通常は `S001_IDENTITY_MODEL.md` から読み、必要な責務へ進む。

## 構成

```text
work-identity/
├─ INDEX.md
├─ S001_IDENTITY_MODEL.md
├─ S002_WORK_ROOT_AND_REPOSITORIES.md
├─ S003_WORK_DOCUMENTS.md
├─ S004_LIFECYCLE_AND_RESOURCES.md
├─ S005_WORKTREE_MATERIALIZATION.md
├─ S006_WORKTREE_COMMANDS.md
├─ S007_VALIDATION.md
└─ S008_HISTORY.md
```

### S001_IDENTITY_MODEL.md

Work Identityそのものの意味、必要性、確定タイミング、命名、Gitとの依存方向を扱う。

### S002_WORK_ROOT_AND_REPOSITORIES.md

Project Root、Work Root、単一/複数repositoryの統一形状、repository派生identity、Git worktree配置、Project-level `.worktrees/` の物理境界を扱う。

### S003_WORK_DOCUMENTS.md

Work Documents、Project Documentsとの関係、Git ownership、Primary/mainの役割、完了時reconciliation、Git historyによる履歴管理を扱う。

### S004_LIFECYCLE_AND_RESOURCES.md

Work lifecycle、Work completion、Project/Work/Run resource scope、Resource Identity伝播、Work Identityの非目標を扱う。

### S005_WORKTREE_MATERIALIZATION.md

Project Repository自身がWorkへ参加する場合のrecursive materialization問題、実験、採用したworktree-local sparse contract、creation/recreation invariant、compatibility境界を扱う。

### S006_WORKTREE_COMMANDS.md

Work Identityとrepository selectorを入力とするworktree create/status/removeのpublic semantic contract、preflight、postconditions、idempotency、rollback、安全境界を扱う。

### S007_VALIDATION.md

worktree command reference implementationのfresh-clone検証、post-reviewで発見したbase/upstream問題、その修正・再検証、実証済み範囲と未実証範囲を扱う。

### S008_HISTORY.md

旧source log metadata、旧artifactへの反映予定、当時の未検証事項など、現在のsubject構造ではnormative本文に混ぜない歴史的文脈を保持する。

## Traceability

主要source record:

```text
../../records/2026-09-21-docs-jp-snapshot/
└─ files/docs-jp/development-environment-strategy/source-logs/
   ├─ WORK_IDENTITY_DESIGN_JP.md
   ├─ WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md
   ├─ WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md
   └─ WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md
```

今回のsubject-native再編では、旧4文書のnumbered section **72 / 72** が新しい責務文書内へ欠落なく再配置されていることを機械確認した。

初回再編では、意味変更リスクを抑えるため、各section本文は原則そのまま保持し、主に以下だけを変更した。

- file責務による再配置
- legacy section番号の除去
- subject-native title / intro / source参照の追加
- 旧authority / artifact migration文脈の `S008_HISTORY.md` への分離

今後さらに文体や重複を整理する場合も、recordsへのtraceabilityを維持し、条件・例外・反論・検証結果を失わないこと。
