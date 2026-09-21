# documents-artifacts

再利用可能なengineering knowledgeと、そこから生成・編集されるAI向けartifactを管理するrepository。

このrepositoryでは、**情報の完全性を守る第1情報源**と、**AI利用効率を優先する第2情報源**を分離する。

## 情報源モデル

```text
第0情報源
Chat / Issue / 調査 / 実験 / ユーザー・AIからの提言
        │
        │ 原文を情報劣化なく記録
        ▼
documents/knowledge/
第1情報源・正本
        │
        │ 用途に応じて解釈・圧縮・再構成
        ▼
artifacts/
第2情報源・AI向け派生情報
        │
        ▼
target projects
```

ファイル化された情報について疑義・矛盾・意味差がある場合、常に `documents/knowledge/` を最優先で確認する。

knowledgeに含まれる個々の提言・仮説がすべて採用済みという意味ではない。提言、反論、評価、却下、採用、訂正を含む記録全体が正確に保存されていることを信頼する。

詳細な根拠は:

```text
documents/knowledge/INDEX.md
```

## Repository Layout

```text
.
├─ README.md
├─ artifacts.sh
├─ artifacts/                 # 第2情報源。現在はlegacy projection
├─ docs-jp/                   # legacyの人間向け説明・source log。順次knowledgeへ原文移行対象
├─ documents/
│  ├─ INDEX.md
│  ├─ knowledge/              # 第1情報源。日本語。原文・評価関係を完全保存
│  └─ project/                # このrepository自体の運用・移行documentation
└─ tests/
```

## documents/knowledge/

`documents/knowledge/` は情報における正本であり、第1情報源。

原則:

- 日本語で人間が監査可能にする。
- 第0情報源から取り込む本文を要約しない。
- 抜粋・言い換え・都合のよい削除を行わない。
- 過去の提言や却下案も、評価・時系列とともに保存する。
- 後続判断で過去recordを書き換えず、新しいrecordを追加する。
- 第2情報源に疑義があればknowledgeへ戻る。

## artifacts/

`artifacts/` はAI向けの第2情報源。

ここでは第1情報源に基づき、次を優先してよい:

- 現在有効な結論の抽出
- context圧縮
- 重複除去
- AI向け再構成
- progressive disclosure
- token消費効率
- 必要に応じた翻訳

artifactはknowledgeを上書きしない。

現在の:

```text
artifacts/
├─ design-principles/
├─ documentation-strategy/
└─ development-environment-strategy/
```

および `artifacts.sh --modules` はlegacy互換状態。選択module単位を将来の知識境界とは扱わない。

新artifact構造が決まるまで既存projectionを壊さない。

## 更新フロー

repo更新時は:

```text
第0情報源
  ↓
documents/knowledge/
  ↓
artifacts/
  ↓
target projects
```

詳細:

```text
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
```

新しいreusable knowledgeをartifactだけへ直接追加しない。

artifactの誤りを見つけた場合はまずknowledgeを確認する。knowledgeに訂正が必要なら、その訂正根拠となる第0情報源を新しいrecordとして保存してから派生物を更新する。

## 移行状態

現行artifactからの意味保存監査で作成した再構成候補は:

```text
documents/project/migration/semantic-preservation-candidate/
```

へ退避済み。

これらは監査成果物であり、第1情報源ではない。

今後は、既存の `docs-jp/**/source-logs/`、現行artifactを生んだ議論・Issue・実験結果などを、利用可能な原文単位で `documents/knowledge/` へ移行する。

## Legacy Distribution

現在の `artifacts.sh` は既存project互換のため残している。

```bash
./artifacts.sh
./artifacts.sh --list
./artifacts.sh --target /path/to/project --modules all --non-interactive
```

このinterface自体も将来のartifact再設計時に見直す。

## Validation

legacy distribution validation:

```bash
bash -n artifacts.sh
bash tests/test-artifacts.sh
```
