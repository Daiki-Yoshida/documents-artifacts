# 開発実行 — 履歴・旧umbrella

この文書は、旧 `development-environment` umbrellaの責務定義や、現在の複数subjectへ分解される前の誤読防止を歴史的文脈として保持する。

現在は `development-execution` / `workspace-structure` / `development-safety` / `work-identity` がそれぞれ主責務を持つ。

## Original preambles

### DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md

# 開発環境の基本思想

```yaml
document_type: "development_environment_philosophy_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_STANDARDS.md

# 開発環境の実装基準

```yaml
document_type: "environment_standards_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_STANDARDS.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_WORKFLOW.md

# 開発環境の作業フロー

```yaml
document_type: "environment_workflow_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_WORKFLOW.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

---

## この戦略が担当する範囲

```yaml
担当する:
  - "ホストとcontainerの責務"
  - "開発toolの実行方法"
  - "repositoryと任意worktreeの構造"
  - "開発環境に関するトップレベルfolder"
  - "公開commandと開発環境script"
  - "ローカルとCIの実行経路"
  - "環境状態、診断、後片付け、復旧"
担当しない:
  - "application codeの設計"
  - "domain moduleの境界"
  - "documents/ の案内やversion管理"
  - "Issue整理やPull Request承認方針"
  - "release統制やteam権限"
```

---

## よくある誤解

- **Dockerファースト**は、すべての操作をDocker内で行うという意味ではない。
- **ホスト依存を最小化する**とは、全プロジェクト共通の固定許可リストを作ることではない。
- **worktree対応**は、すべてのタスクでworktreeを作るという意味ではない。
- **branchを作ること**と**worktreeを作ること**は別である。
- **Primary Checkout**はdefault branch専用ではなく、単独作業ではtask branchの実装場所として使える。
- **Workspace Repository**は、Git上の親リポジトリや必須submoduleを意味しない。
- **resource分離**は、すべてのcacheを複製する意味ではない。
- **安全性**は、作業を遅くすることではない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`


---

## 2026-09-22 cross-subject alignment

6 subject横断監査で、旧development-environment umbrella由来の責務がdevelopment-executionの現行本文へ残存していたことを確認した。

現行本文から次を除去・委譲した。

- repository / Workspace / Componentの静的構造 → `workspace-structure`
- Work / branch / worktree / resource lifecycle → `work-identity`
- destructive operation / diagnostics / recovery / confirmation → `development-safety`

旧modelではexecution workflow自身がrepository構造、Task Worktree path、task resource identity、安全性まで広く所有していた。この意味は本historyとsource recordへ保持する。

現在のdevelopment-executionは、host/container boundary、Docker-first、runtime materialization、public command surface、local/CI、reproducibilityへ責務を限定する。

Source decision:

- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
