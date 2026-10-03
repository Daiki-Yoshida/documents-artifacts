# Record Model

`records/` は、第0情報源から得られた原文・記録・snapshotを保存する層である。

## Directory

1つのsource eventまたは取り込み単位を1directoryとして扱う。

```text
records/
└─ YYYY-MM-DD-<short-title>/
   ├─ RECORD.md
   └─ ...
```

例:

```text
records/2026-09-21-knowledge-source-model/
records/2026-09-21-work-identity-design/
records/2026-09-21-docs-jp-snapshot/
```

日付を年/月/日directoryへ分割しない。

`<short-title>` は内容を識別できる短い英数字・hyphen形式とし、意味分類そのものをpath authorityにしない。

## Record単位

典型的なrecord:

- Chatの1メッセージ
- Issue本文
- Issue comment
- AIまたはユーザーの提言
- 調査報告
- 実験結果
- 検証報告
- repository snapshot/import

複数fileで1つのsource eventを構成する場合は同じrecord directoryに置く。

## 原文保存

第0情報源から取り込む本文について、原則として以下を行わない。

- 要約
- 抜粋
- 言い換え
- 順序変更
- 重複を理由とした削除
- 現在不要という理由での削除
- 後続判断に合わせた過去記録の書き換え

提言が後に却下された場合も、過去recordを「間違いだったから」と削除・修正しない。

却下・訂正・追加判断そのものを新しいrecordとして保存する。

## Metadata

原文とは別に、次のprovenance metadataを付与してよい。

- source種別
- source日時
- source URL / Issue / commit等の識別情報
- 取り込み日時
- 原文言語
- record間の明示的な関係
- snapshot commit
- integrity hash

metadataは原文の代替ではない。

decision eventを含むrecordでは、raw source本文とは別にoptionalな `decision_lineage` metadataを持てる。relation / scopeの意味は `DECISION_LINEAGE_MODEL.md` が所有する。

## Decision event metadata

recordは「そのsource eventで何が起きたか」を保存する。

後から変化し得る現在評価をimmutable recordへ固定しない。

禁止例:

```yaml
current: true
superseded: true
```

optional metadata例:

```yaml
decision_lineage:
  event: "adoption"
  scope: "repository role model"
  adopts:
    - "../proposal-record/"
  supersedes:
    - "../older-decision-record/"
```

relationは必要なkeyだけを記述する。old recordへretroactively current statusを書き込むのではなく、later event側からrelationを張る。

event type / relation / scope / conflict解決は `DECISION_LINEAGE_MODEL.md` を参照する。

## Snapshot / Import

directory単位のsnapshotは次のように保存できる。

```text
records/YYYY-MM-DD-<snapshot-name>/
├─ MANIFEST.md
└─ files/
   └─ <original tree>
```

`files/` は可能な限り元のdirectory構造と本文を維持する。

`MANIFEST.md` はprovenance、snapshot point、integrity verificationを管理し、payloadの意味を要約する場所にはしない。

## 修正

record本文の変更を許可する代表例は、取り込み時の転記ミスなど「sourceとrecordが一致していない」場合。

判断の変化はrecordの修正ではなく、新しいsource eventとして追加する。

## 根拠records

- `../records/2026-09-21-knowledge-source-model/`
- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-10-03-knowledge-effective-status-lineage/`
