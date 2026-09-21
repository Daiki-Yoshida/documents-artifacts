# 開発安全性 — 診断と復旧

状態確認、検証、失敗診断、復旧順序を扱う。

## 6. 診断と検証

project環境は、次に相当する操作を提供します。

```yaml
案内: "利用可能な操作と必要parameterを表示"
診断: "tool version、選択repository・checkout、container、port、mount、よくある設定不良を表示"
状態: "変更せず、現在のproject/task resourceを表示"
検証: "完了判定用の標準gateを実行"
```

- 診断でsecretを表示しない。
- 選択repository / checkoutを表示し、Work用のrepository-specific worktreeや分離runtimeを利用する場合は、Work Identity・worktree・runtime namespaceも表示する。
- 実装中は狭い検証から始め、完了前に最終gateを実行する。
- 最終gateが失敗・未実行なら完了と報告しない。

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
