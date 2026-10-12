# 開発安全性 — 基本原則

開発操作で優先する安全性、使いやすさとの両立、fail-safeな日常経路を扱う。

## 優先順位

```yaml
優先順位:
  1: "ホストとデータの安全性"
  2: "再現性"
  3: "リポジトリとリソースの分離"
  4: "複数AIエージェントの並列運用"
  5: "操作内容と副作用の明確さ"
  6: "診断と復旧のしやすさ"
  7: "ローカルとCIの実行経路の一致"
  8: "開発効率"
```

安全性を理由に、日常作業を不必要に面倒にしてはいけません。安全な操作を最も短く、使いやすい経路にします。

---

## 安全性と使いやすさの両立

```yaml
原則: "安全な操作を最も簡単な操作にする"
方針:
  - "日常操作は初期状態で非破壊的"
  - "破壊的操作は名前と対象範囲を明確にする"
  - "診断コマンドを見つけやすくする"
  - "最終検証の標準経路を一つ定義する"
  - "後片付けは選択したProject / Work scopeのresourceだけを対象にする"
```

安全性は、何度も手作業を要求するのではなく、command設計とresource identityへ組み込む。

Project / Work / Runのresource ownershipは `../work-identity/` が主所有し、このsubjectはそのscopeを安全な操作境界として利用する。

## 実効的な操作対象と構造変更

Project Root配下の隔離領域・一時環境は、project-localなowner、Git追跡/ignore境界、lifecycle/cleanup対象を明確にして使用する。旧checkout等の移設は、意図した内容保存だけでなく、staged/dirty state、Git metadata、linked worktree登録、absolute path依存への影響を調査してから行う。

書込場所の文字列ではなく、symlink / bind mount / container mount / host operation等を通じた実効的な変更先と副作用を評価する。外部への必要な書込の権限判断は `../engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md`、destructive / structural operationのgateは `S002_DESTRUCTIVE_OPERATIONS.md` と `S005_CONFIRMATION_AND_REREAD.md` が所有する。

## Sources

- `../../records/2026-10-12-project-root-write-boundary/ISSUE_199_BODY.md`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
