# 開発安全性 — 確認境界と再読

開発環境変更の確認levelと、重大な環境・構造変更時に文書を読み直す条件を扱う。

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

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
