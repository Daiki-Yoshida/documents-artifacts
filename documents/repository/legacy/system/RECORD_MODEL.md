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

Record directoryは、**1つのsource event、または取り込み時に範囲を確定したsource event群**を保存する。日付や同一topicであることだけではBundleの同一性を決めない。recordの物理配置はsourceを保存するためのもので、意味分類や現在有効なauthorityを表さない。

新規取り込みでは次の3形を区別する。

- **event**: Chatの1メッセージ、Issue本文、1コメント、報告等、境界を特定できる単独のsource event。本文が短ければ`RECORD.md`内へ原文を置いてよい。
- **bundle**: 1つの判断・調査・検証・完了などを追跡するために関連付けた、複数の独立したsource eventの集合。共通する出来事・取り込み目的と選定範囲を明示し、個々の出典・原文・境界を識別可能にする。同じIssue・話題・期間というだけで全履歴を1つへ無制限に集約しない。1ファイルに複数の完全メッセージを収録しても、各メッセージを明確に区切ればよい。
- **snapshot**: 特定時点のrepository / directory / 文書群を保存する取り込み。元のtreeを`files/`等に維持し、`MANIFEST.md`に取得元・snapshot point・範囲・完全性と検証状況を記述する。

Bundleは**取り込み時点で閉じたsource集合**である。後日の新たな判断・レビュー・完了結果は、既存Bundleへ継ぎ足さず、別recordに追加して参照関係を張る。取り込み時の転記ミスを直す例外は後述の「修正」に従う。

### Bundleを成立させる条件

1. **まとまり**: 保存対象が共通の出来事や意思決定の根拠・経緯を検証するsource群である。
2. **独立性**: 各source eventの境界、出典と元の順序を識別できる。承認・訂正が短い場合、その参照対象の提案・調査を同じBundleか別recordへの参照で追跡する。
3. **収録範囲（Coverage）**: 全会話か、選んだ完全メッセージ群か、Issue本文の取得時点全体か、snapshot全体かを明示する。「選択したeventが全文」と「source集合を網羅した」は別の保証である。
4. **本文忠実性（Fidelity）**: 原文との一致、改行・Markdown等の整形、転記、取得欠落を収録範囲とは別に記述する。収録したeventは原則全文とし、抜粋を完全なeventとして表示しない。
5. **固定性**: 収録後に新しいsourceが発生しても、そのBundleを現在の状態に合わせて再編集しない。

対象となる全eventを強制的に取り込む必要はない。必要なsourceを選定してよいが、その境界と選定方針を明示し、欠落した文脈を「完全記録」と呼ばない。

典型的なevent:

- Chatの1メッセージ
- Issue本文 / 1コメント
- AIまたはユーザーの提言 / 採用 / 却下 / 訂正
- 調査・実験・検証の1報告
- repository snapshot/import

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

## 新規取り込みの最小契約（`record_format: 1`）

これ以降の新規recordには、`RECORD.md`（event / bundle）または`MANIFEST.md`（snapshot）の先頭YAML metadataで、次の最低限の項目を記述する。既存recordには一括で適用・変換しない。

```yaml
record_format: 1
record_kind: bundle
recorded_date: "YYYY-MM-DD"
scope: "今回のsource集合として取り込む出来事と境界"
```

- `record_kind` は `event` / `bundle` / `snapshot` のいずれか。これは**保存形状**であり、Decision Lineageの `proposal` / `adoption` / `validation` 等とは別の軸である。
- `recorded_date` とdirectoryの日付は**取り込み日**で一致させる。過去の出来事を後日取り込んでも日付を遡らせない。source発生日時と取得日時（分かる場合はtimezoneを含む）は別に残し、不明な日時を推定しない。
- `scope` は選定したsource集合の取り込み目的と境界を示す。recordsを意味・主題で分類するtaxonomyではない。
- `record_type`等の従来metadataを無理に削除しないが、新規形状の判定は `record_kind` を使用する。
- `## Source inventory` に、収録する各eventまたはsnapshot payloadの **位置、source種別と取得可能なlocator、Coverage、Fidelity** を記述する。表や箇条書きなど記述形式は固定しない。識別子・URL・日時が得られないときは無理に創作せず、その限界を説明する。
- 原文の完全性を確認できない場合は、その限界・取得可能な範囲・整形内容を明示する。「原文」「全文」「byte-identical」といった保証は証拠の範囲でのみ使用する。
- Source inventoryは原文payloadの代わりではない。本文をmetadataへ要約して差し替えない。Bundle内のsource event単位の境界・出典・順序を保持する。

`RECORD.md` はevent / bundleのsource inventoryとprovenanceの入口であり、単独eventなら原文自体を含んでもよい。`MANIFEST.md` はsnapshot/importの原本位置・payload一覧・capture point・integrityを所有し、別の要約authorityを要求しない。recordは原文source、subjectsは意味の整理とcurrent statusを所有する。

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

- `../records/2026-10-13-record-intake-regulation/` — Issue #189のB案・取り込み単位・保存保証の採用判断。
- `../records/2026-09-21-knowledge-source-model/`
- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-10-03-knowledge-effective-status-lineage/`
