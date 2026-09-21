# 開発環境戦略 — 日本語版インデックス

```yaml
document_type: "index_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/INDEX.md"
strategy_version: "1.4.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

このフォルダは、AIエージェント向けの正本である `artifacts/` を、人が理解しやすく確認するための非正本資料です。

## 設計原本 / source log

Work Identity関連の背景・判断理由・実験証拠は、正本artifactとは分離してsource/rationale logに保持します。

- [Work Identity 設計原本](source-logs/WORK_IDENTITY_DESIGN_JP.md)
  - status: `artifactized_reference`
  - authority: non-canonical source/rationale log
  - 用途: Work Identityの背景・判断理由・圧縮前の文脈を確認する
- [Work Identity Git Materialization 実験記録](source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md)
  - status: `artifactized_reference`
  - authority: non-canonical experiment record
  - 用途: Worktree Materialization Contractの実機検証、失敗経路、採用根拠、互換性条件を確認する
- [Work Identity Worktree Command Contract 設計原本](source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md)
  - status: `artifactized_reference`
  - authority: non-canonical source/rationale log
  - 用途: Worktree public command contractの入力、導出、idempotency、rollback、安全境界の設計根拠を確認する
- [Work Identity Worktree Reference Implementation 検証記録](source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md)
  - status: `artifactized_reference`
  - authority: non-canonical experiment record
  - 用途: artifact化済みのpublic command参照実装検証、base/upstream問題と修正、Primary checkout guard、検証範囲を確認する

これらのsource logは現行artifactを上書きしません。

## 読む順番

```yaml
1_思想: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # なぜ: Work Identity、安全性、分離、checkout選択
2_基準: "ENVIRONMENT_STANDARDS.md"             # どうする: ホスト、Docker、公開コマンド、Git安全性
3_構造: "WORKSPACE_STRUCTURE.md"               # どこに置く: Project Root、Work Root、repository、Work Documents、worktree
4_流れ: "ENVIRONMENT_WORKFLOW.md"               # どう進める: Work確定、create、検証、統合、cleanup、復旧
```

## 基本モデル

```text
User Goal
   ↓
Work Identity
   ↓
Work Root
.worktrees/<work-type>/<work-name>/
   ├─ documents/       # Work Documents
   └─ <repository>/    # 必要な場合だけGit worktree
```

Work Identityは具体的な開発目標のownership/lifecycle単位です。Git branchやworktreeはWork Identityの表現手段であり、Work Identityそのものではありません。

## Worktree選択

Work Identityが存在するだけではGit worktreeを作りません。

```yaml
通常:
  条件: "repositoryに書き込みWorkが一つで、現在/Primary Checkoutを安全に使える"
  対応: "Work branchを現在/Primary Checkoutで使用"
Git_worktreeを作る条件:
  - "同じrepositoryで複数の書き込みWork/agentを並列実行する"
  - "別branchを安定したpathで維持する"
  - "ユーザー/projectが明示的に要求する"
  - "独立して破棄可能なcheckout/runtimeが必要"
理由にならないもの:
  - ".worktrees/ が存在する"
  - "worktree helperが存在する"
  - "Work Identityが存在する"
```

## Worktree public command

単一repo / 複数repoで同じpublic inputを使用します。

```text
WORK=<work-type>/<work-name>
REPO=<stable repository selector>
```

単一repoでも `REPO` を省略しません。

意味上、projectは次の操作を持ちます。

```text
worktree-create
worktree-status
worktree-remove
```

exact CLI syntaxはproject-ownedですが、routine callerは原則としてpath、sparse適用要否、branch名を直接決めません。project-owned helperがWork IdentityとREPOからdeterministically解決します。

新規Work branchでは、`BASE` はbranchの開始点でありupstreamとは別です。mainを開始点にしただけで、そのWork branchのupstreamをmainへ自動設定してはいけません。同名remote Work branchをtrackingする場合は、project policyとして別に選択します。

project-level helperはProject Rootを安定して解決する必要があります。linked worktreeからの呼び出しでProject Rootを誤認する可能性があるprojectでは、Primary checkoutからの実行に限定するか、同等に安全なexplicit resolutionを行います。

## Worktree Materialization Contract

Project Repository自身など、selected branchがProject-level tracked `.worktrees/**` を含む場合、nested worktreeへその `.worktrees/` を再帰materializeしてはいけません。

正本では、適用対象に対して次のlow-level semanticsを規定しています。

```bash
git worktree add --no-checkout <worktree-path> <work-branch>

git -C <worktree-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <worktree-path> \
  reset --hard HEAD
```

この低レベル手順はroutine callerに直接実行させず、project-owned create operationへ隠蔽します。

## 文書ごとの責務

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  担当:
    - "Work IdentityのWHY・確定タイミング・Gitとの関係"
    - "checkout/worktree選択の考え方"
    - "並列分離の理由"

ENVIRONMENT_STANDARDS.md:
  担当:
    - "Project / Work / Run resource scope"
    - "public command interface"
    - "Worktree create/status/remove contract"
    - "Git安全性・互換性・diagnostics"
    - "Docker/runtime lifecycle"

WORKSPACE_STRUCTURE.md:
  担当:
    - "Project Root / Work Root"
    - "単一repo / 複数repoの統一形状"
    - "Work Documentsの配置とGit ownership"
    - "REPO selector、path/branch mapping"
    - "Worktree Materialization Contract"

ENVIRONMENT_WORKFLOW.md:
  担当:
    - "Work Identity確定"
    - "worktree create preflight / postcondition / rollback"
    - "実装・検証・統合"
    - "worktree remove"
    - "Work Documents reconciliation / Work completion"
```

## 他artifactとの境界

```yaml
design_principles:
  担当: "コード設計、module contract、実装、テスト戦略"
documentation_strategy:
  担当: "canonical Project Documents / active Work Documentsの内容、routing、versioning、reconciliation"
development_environment_strategy:
  担当: "Work Identity、Work Root/worktree topology、開発ツール、resource lifecycle、execution path"
```

複数領域にまたがる場合も、それぞれのartifactを担当範囲にだけ適用します。
