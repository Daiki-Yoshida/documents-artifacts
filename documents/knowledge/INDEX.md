# Knowledge Index

```yaml
文書種別: "第1情報源ルーティング"
言語: "日本語"
意味内容の要約: false
```

`documents/knowledge/` は、このリポジトリでファイル化された情報における第1情報源である。

このINDEXは知識本文を要約・再解釈しない。原文記録への経路と、記録間の関係だけを示す。

## 情報源の優先順位

```text
第0情報源
チャット / Issue / 調査 / 実験 / ユーザーまたはAIからの提言
        ↓ 原文を情報劣化なく記録
第1情報源
documents/knowledge/
        ↓ 現在の評価・文脈・結論を読み取って変換
第2情報源
artifacts/ などのAI向け派生情報
```

ファイル化された情報同士で矛盾または意味差がある場合、`documents/knowledge/` の記録を最優先して確認する。

第1情報源に記録された個々の発言・仮説・提言が、すべて肯定的に採用されていることを意味しない。提言、反論、評価、却下、採用、後続の訂正を含む**記録全体の関係と内容が正確に保存されていること**を信頼する。

## 原文記録

INDEXは原文内容を要約しない。記録ID・情報源・時系列・明示された関係だけを管理する。

| 記録 | 情報源 | 日付 | 関係 |
|---|---|---|---|
| [K-2026-09-21-000](records/K-2026-09-21-000.md) | ChatGPT会話内のユーザーメッセージ | 2026-09-21 | — |
| [K-2026-09-21-001](records/K-2026-09-21-001.md) | ChatGPT会話内のユーザーメッセージ | 2026-09-21 | K-2026-09-21-000 の方針を具体化 |
| [K-2026-09-21-002](records/K-2026-09-21-002.md) | ChatGPT会話内のユーザーメッセージ | 2026-09-21 | K-2026-09-21-001 の「正確」の意味を補足 |
| [K-2026-09-21-003](records/K-2026-09-21-003.md) | ChatGPT会話内のユーザーメッセージ | 2026-09-21 | — |

## Legacy source log 原文コピー

以下は既存 `docs-jp/**/source-logs/` から本文を変更せずにコピーした記録である。

コピー元snapshot:

```text
d68ec413b4bb3dafe90e1aaed3c8de9487b1453c
```

INDEXは内容を要約しない。source pathとblob同一性だけを記録する。

| knowledge record | 元path | blob SHA |
|---|---|---|
| [ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md](records/legacy-source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md) | `docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md` | `ecad4ecf22fe510b7f71ef0e7c9be684298d73c9` |
| [WORK_IDENTITY_DESIGN_JP.md](records/legacy-source-logs/WORK_IDENTITY_DESIGN_JP.md) | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md` | `914c937eb0ae9813b4c736d74723212126bda04e` |
| [WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md](records/legacy-source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md) | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md` | `eb7a9d28d05297128845056b9c019796ad31efad` |
| [WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md](records/legacy-source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md) | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md` | `9fd3fbdc6dc9dfda105bfb4ef956b77fec7557a2` |
| [WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md](records/legacy-source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md) | `docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md` | `dc5ef3b599a35d6f908f10c536ead3886cfb539c` |

これらの内部にある旧authority/status表現も歴史的記録の一部なので改変しない。現在の情報源優先順位は、後続のユーザー決定recordを含む全記録の時系列・評価関係から判断する。

## docs-jp snapshot

旧 `docs-jp/` のsnapshot移行状況は次を参照する。

- [docs-jp snapshot manifest — 2026-09-21](manifests/docs-jp-snapshot-2026-09-21.md)

snapshot commit `d68ec413b4bb3dafe90e1aaed3c8de9487b1453c` に存在した16ファイルは、すべてknowledge側に本文無加工で確保済み。

manifestは内容の要約ではなく、copy元・copy先・分類・blob SHAのprovenanceだけを管理する。

## 記録原則

- 原文本文を要約しない。
- 原文本文を抜粋して元の意味を失わせない。
- 原文本文を言い換えない。
- 原文内の提言・仮説・否定・採用・保留などの評価関係を改変しない。
- 後から結論が変わっても、以前の記録を書き換えて歴史を消さない。
- 新しい判断・訂正・反論は、新しい原文記録として追加する。
- provenanceや記録間の関係を示すmetadataは付与してよいが、原文そのものの代替にはしない。

## 第2情報源への変換

`artifacts/` などの第2情報源では、第1情報源を根拠として次の変換を許可する。

- コンテキスト圧縮
- 重複除去
- 現在有効な結論の抽出
- AI向けの再構成
- progressive disclosure
- token消費効率の最適化
- 必要に応じた言語・表現形式の変更

ただし、第2情報源は第1情報源の意味を上書きしない。第2情報源に疑義がある場合は第1情報源へ戻って確認する。

## 移行中の注意

このbranchで以前作成した意味再構成候補は、第1情報源の原文保存要件に適合しないため `documents/project/migration/semantic-preservation-candidate/` へ退避している。

それらは意味保存監査の成果物であり、第1情報源ではない。
