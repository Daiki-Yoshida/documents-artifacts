# 開発環境 — 安全性とライフサイクル

破壊的操作、診断、統合、cleanup、復旧、確認レベル、再読条件を扱う。Work Identity固有のworktree lifecycleは別subjectが所有する。

## 5. 破壊的操作

```yaml
通常操作:
  性質: "source変更と永続dataを保持する"
破壊的操作:
  性質: "source変更、commit、volume、DB、cache、remote状態を失う可能性がある"
  必須:
    - "明示的な名前"
    - "狭い対象範囲"
    - "事前条件確認"
    - "削除内容の報告"
```

- global Docker pruneのようなhost全体操作を通常project lifecycleへ入れない。
- cleanup対象は決定的なproject/task識別子で限定する。
- DB reset、volume削除、worktree強制削除、remote deploy破棄を曖昧な `clean` にまとめない。

---

## 6. 診断と検証

project環境は、次に相当する操作を提供します。

```yaml
案内: "利用可能な操作と必要parameterを表示"
診断: "tool version、選択repository・checkout、container、port、mount、よくある設定不良を表示"
状態: "変更せず、現在のproject/task resourceを表示"
検証: "完了判定用の標準gateを実行"
```

- 診断でsecretを表示しない。
- 選択checkoutを表示し、Task Worktree利用時だけworktreeとcontainer namespaceも表示する。
- 実装中は狭い検証から始め、完了前に最終gateを実行する。
- 最終gateが失敗・未実行なら完了と報告しない。

---

## 4. 統合

統合方式はproject固有ですが、repository境界を守ります。

- merge、rebase、PRはbranchを所有するrepositoryで行う。
- Component Repositoryの変更をWorkspace Repositoryへcommitしない。
- 統合後HEADで必要な検証を再実行する。
- Workspace toolが変わった場合、意図したWorkspace refでComponentを検証する。
- 必要ならPrimary Checkoutをproject規則の安定状態へ戻す。

このstrategyはPR承認やrelease方針を決めません。

---

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

---

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

---

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

---

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
