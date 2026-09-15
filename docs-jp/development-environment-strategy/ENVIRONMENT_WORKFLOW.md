# 開発環境の作業フロー

```yaml
document_type: "environment_workflow_translation"
target_audience: "human_readers"
language: "japanese"
source: "../artifacts/ENVIRONMENT_WORKFLOW.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

## 1. 新規プロジェクトへの導入

### 手順1: リポジトリ構造を決める

```yaml
単一repository: "product codeと開発環境toolを同じrepositoryで管理する"
WorkspaceとComponent: "Workspace Repositoryが一つ以上の独立Component Repositoryを管理する"
```

別履歴、安定したcomponent root、共有tool、並列エージェント調整など、実際の必要性がある場合だけ後者を選びます。

### 手順2: ホスト境界を決める

- host制御面へ置くtoolを列挙する。
- project runtime、package manager、build、test、project固有CLIは原則containerへ置く。
- host例外とversion差異の管理方法を記録する。
- 通常commandが昇格権限を要求しないようにする。

### 手順3: 公開commandを作る

- 通常はMakefileを公開command入口にする。
- checkout選択や環境準備が複雑なら共通wrapperを追加する。
- 複雑な処理は `scripts/` などへ分離する。
- help、状態確認、診断、部分検証、最終検証、限定cleanupを用意する。
- 通常操作と破壊的操作を分ける。

### 手順4: resource識別を決める

次を安定した名前で識別します。

- workspaceまたはproject
- component
- resourceの役割
- task固有隔離を使う場合だけtaskまたはworktree

並列taskには、衝突しない可変resourceとhost portを割り当てます。

### 手順5: repositoryと任意worktreeのpathを決める

- 各Component RepositoryのPrimary Checkoutを決める。
- 独立Component RepositoryのpathをWorkspace Repository側でignoreする。
- worktree対応を採用する場合だけ `.worktrees/` を定義してignoreする。
- 必要時に使うworktree命名規則を決める。
- command内部を書き換えず、現在checkoutまたは明示worktreeを対象にできるようにする。
- worktree対応の確認だけを目的に、bootstrap時にTask Worktreeを作らない。

### 手順6: bootstrapを検証する

clean clone相当の状態から、次を確認します。

- 環境を作成できる。
- versionと選択pathを表示できる。
- 最小checkが通る。
- 最終検証が通る。
- 検証で作成したresourceだけを削除できる。

文書化されていないhost前提があれば報告します。

## 2. 既存プロジェクトへの導入

開発環境改善を理由に、無関係なrepository構造やcodeを全面改修してはいけません。

### 現状調査

```yaml
host依存: "runtime、package manager、SDK、CLI"
入口command: "文書化・未文書化のbuild、test、deploy"
container状態: "image、Compose、名前、port、volume、permission"
Git構造: "repository root、embedded repository、branch、任意worktree"
CI: "local scriptとの重複や差異"
破壊経路: "cleanup、reset、force削除、data削除"
```

### 移行順序

1. 現在の動作を覆う安定した公開commandを作る。
2. project固有処理を管理されたcontainerへ移す。
3. resource識別と所有権を整える。
4. 診断と最終検証を追加する。
5. 並列開発または明示的隔離が必要な場合だけworktree対応を追加する。
6. CIをproject管理commandへ合わせる。

一度に一つの開発環境境界だけを変更し、動作を維持します。

### 既存環境の保護

- project固有規則とgeneric strategyが衝突した場合はproject規則を優先し、衝突を報告する。
- repository移動や環境状態削除を黙って行わない。
- 依頼に必要でないWorkspace・Component分割を導入しない。
- 現在checkoutで単独作業を安全に行える場合、Task Worktreeを導入しない。
- scope外の違反は報告し、ついでに全面修正しない。

## 3. checkout選択と任意Task Worktree

### checkout方式を選ぶ

編集前に、最も単純で安全な方式を選びます。

```yaml
現在またはPrimary_Checkout:
  使用条件:
    - "Component Repositoryで書き込み作業が一つだけ"
    - "そのcheckoutでtask branchを安全に使える"
    - "別branchを安定したpathで維持する必要がない"
    - "独立した可変runtime状態が不要"
  対応: "割り当て済みcheckoutを使い、worktreeを作らない"
Task_Worktree:
  使用条件:
    - "複数の書き込みtaskまたはAIエージェントを並列実行する"
    - "別branchを安定したpathで維持する必要がある"
    - "ユーザーまたはproject規則が明示的に要求する"
    - "独立して破棄できるcheckoutとruntime状態が必要"
  対応: "Task Worktreeを作成し、すべての操作で明示選択する"
```

`.worktrees/`、worktree helper、TASK_IDの存在だけでは、worktreeを作る理由になりません。

### 選択checkoutを準備する

どちらの方式でも、次を確認します。

- Component Repository
- taskとtask branch
- 選択checkoutが正しいrepositoryに属すること
- project規則に従ったref同期
- その書き込み可能checkoutを所有する書き込みエージェントが一つだけであること

Primary Checkoutを使う場合は、project規則に従ってtask branchへ切り替えるか作成します。保護されたdefault branch上で直接実装しません。

### 必要な場合だけTask Worktreeを作る

作成前に、次を確認します。

- 実際に並列または隔離条件が存在する。
- Primary Checkoutが意図したrepositoryである。
- branch名とpathが衝突しない。

作成後は、branch、絶対またはworkspace相対path、runtime識別子を報告します。

```yaml
worktree割り当て:
  worktree: "一つの書き込みエージェント"
  branch: "そのworktreeでcheckoutしたbranch"
  可変runtime: "task識別子で分離"
  command対象: "すべての操作で明示選択"
```

### 実装と検証

1. 最も狭い関連検証から始める。
2. host toolを直接呼ばず、project管理commandを使う。
3. 選択checkoutのlogと状態から失敗を診断する。
4. 他の書き込み可能checkoutへ触れない。
5. 完了報告前に最終HEADで標準最終検証を実行する。

### 変更を保存する

統合、checkout切替、worktree削除の前に、次を行います。

- working treeを確認する。
- project規則に従って意図した変更をcommitへ保存する。
- untracked generated fileを確認する。
- 必要ならremoteなどへの保存条件を確認する。

## 4. 統合

統合方式はproject固有ですが、repository境界を守ります。

- merge、rebase、PRはbranchを所有するrepositoryで行う。
- Component Repositoryの変更をWorkspace Repositoryへcommitしない。
- 統合後HEADで必要な検証を再実行する。
- Workspace toolが変わった場合、意図したWorkspace refでComponentを検証する。
- 必要ならPrimary Checkoutをproject規則の安定状態へ戻す。

このstrategyはPR承認やrelease方針を決めません。

## 5. 後片付け

task専用resourceを作成した場合、task終了時にその最終状態を判断する責任が生じます。

```yaml
完了状態:
  削除済み: "不要になったresourceを、通常の限定cleanupで削除した"
  意図的に保持: "具体的な後続作業のために必要であり、resourceと保持理由を報告した"
原則: "所有者や理由が不明な残存resourceを、完了状態として認めない"
```

共有resourceや永続dataは、taskが利用したという理由だけでtask cleanupの対象にしません。破壊的な削除は、後述のpurge規則に従います。

### worktreeを作らなかった場合

現在またはPrimary Checkoutを使ったtaskでは、次のようにします。

- worktree cleanupを実行しない。
- task branchをproject規則に従って保存する。
- 実際に作成したtask専用runtime resourceをすべて確認する。
- 不要なresourceは削除し、意図的に保持するresourceは対象と理由を報告する。
- project workflowが要求する場合だけ、期待branchへcheckoutを戻す。

### 通常のworktree削除

Task Worktreeを作った場合だけ、通常削除で次を行います。

1. 対象worktreeを決定的に解決する。
2. 正しいComponent Repositoryに属することを確認する。
3. 未commit変更があれば拒否する。
4. 未保存commitがある場合は警告または拒否する。
5. task専用runtime resourceを停止・削除する。
6. forceなしでGit worktreeを削除する。
7. 必要な場合だけstale metadataをpruneする。
8. branchなど残るものを報告する。
9. 意図的に保持するtask専用resourceと、その理由を報告する。

### 破壊的purge

purgeは未保存作業や永続dataを失う可能性があります。通常削除とは別の明示操作とし、対象範囲を報告します。

branch削除、worktree強制削除、DB削除、共有cache削除を一つの曖昧なcleanupへまとめません。

すべてのtask専用resourceが削除済み、または理由を伴って意図的に保持されている場合だけ、後片付け完了とします。想定外の残存resourceは無視せず報告します。

## 6. 診断と復旧

失敗時は次の順番で確認します。

```yaml
1_対象選択: "workspace、component、branch、checkout、任意worktree"
2_ホスト境界: "必要な制御面toolとpermission"
3_version: "container、runtime、tool、lock file"
4_runtime: "container、network、port、mount、所有権、volume"
5_command: "公開command parameterとexit status"
6_Git状態: "dirty状態、branch所有、必要な場合のworktree metadata、remote ref"
7_CI差異: "provider準備またはWorkspace ref不一致"
```

- host全体cleanupの前に、問題taskのresourceだけを再作成する。
- rebuildや削除前にsource変更を保存する。
- 通常失敗の理由を理解する前にforce削除しない。
- 最初の診断としてglobal Docker pruneや広範囲file削除を行わない。
- 失敗層と証拠を報告し、失敗操作の再実行が成功するまで修復完了としない。

## 7. 開発環境変更の確認レベル

```yaml
L0_観察のみ:
  例: ["help", "status", "diagnostics", "変更を伴わないversion確認"]
  対応: "そのまま実行"
L1_安全なlocal追加:
  例: ["非破壊target", "診断script", "task専用container設定"]
  対応: "実行して報告"
L2_構造変更:
  例: ["Workspace・Component分割", "repository root移動", "worktree path変更", "標準command名変更", "CI Workspace ref方針変更"]
  対応: "依頼から明確に必要な場合だけ実行し、明示報告"
L3_破壊的またはhost変更:
  例: ["dirty worktree破棄", "branch・永続volume削除", "DB破棄", "host全体cleanup", "host runtime追加・削除", "history書き換え"]
  対応: "その破壊効果を明示依頼されていない限り事前確認"
```

無害に見えるcommand名の裏へ破壊的処理を隠し、確認levelを下げてはいけません。

## 8. 文書を読み直す条件

```yaml
必ず読み直す:
  - "このstrategyを使うprojectへ初めて触れる"
  - "Workspace・Component構造を作成または変更する"
  - "worktree対応を追加または再設計する"
  - "hostとcontainerの境界を変更する"
  - "破壊的な開発環境操作を追加する"
読み直すことを推奨:
  - "Docker resource命名や分離を変える"
  - "Makefileや公開command構造を変える"
  - "ローカルとCIの経路を合わせる"
  - "Workspace tool version選択を変える"
読み直し不要:
  - "確立済みcommandの日常利用"
  - "単独書き込みtaskで現在checkoutを選ぶ"
  - "実際の隔離条件がある場合の通常Task Worktree作成"
  - "command契約を変えない小さな内部script修正"
```
