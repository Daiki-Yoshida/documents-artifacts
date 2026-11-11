---
record_format: 1
record_kind: bundle
recorded_date: "2026-11-11"
scope: "このChatGPT会話のP04命名相談から『AON原則にしよう』というOwnerの明示的な名称・本文採用およびrecords保存指示まで。Owner発言3件（U1–U3）を選定・全文転記し、assistant提案は二次分析として別に記す。AON以外のDev-Philosophy全体系の採否やsubjects反映は含まない。"
decision_lineage:
  event: "adoption"
  scope: "AON — All and Only Necessary の名称およびOwner U3による原則本文"
---

# AON原則（All and Only Necessary）— 名称・原則本文の採用記録

## 結論と位置付け

Ownerは、P04の検討をきっかけに、境界設計に限定されない開発・作業全般の原則について、**「AON原則にしよう。」**と明示し、以下の名称と本文を自ら提示して採用した。

> # AON — All and Only Necessary
>
> 必要なものはすべて。必要なものだけ。
>
> 目的と責務に照らして必要なものを、実現の困難さや時期を理由に省略してはならない。
>
> 同時に、必要でないものを、可能性や容易さだけを理由に追加してはならない。
>
> 必要性の判断と、実現方法・費用・実施順序の判断を混同しない。

上の定義は閲覧用の再掲であり、採用の**一次証拠と正確な表現**は [USER_MESSAGES.md](USER_MESSAGES.md) **U3** にある。

**採用scope：** AON原則という名称と、U3で提示した標語・原則本文。A-1/P04全体の扱い、Dev-Philosophyのファイル構造、ほかの仮候補の採否、Artifactへの配布方法などは未承認・未変更。

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
| --- | --- | --- | --- |
| [USER_MESSAGES.md](USER_MESSAGES.md)（U1–U3） | このChatGPT会話。P04命名相談、NiN案、AON採用の可視発言。会話URL・message ID・正確な個別時刻は取得できない。2026-11-11 (Asia/Tokyo)に収録 | U1「P04に関して先に軽く議論しようか」からU3「recordsに記録しちゃって」までの**Ownerメッセージ3件すべて**を順に全文転記。ほかのチャット・先行Recordsは含まない | 可視会話テキストからの手作業転記。要約・言い換えなしを意図したが、元APIのbyte-identicalなexport照合は未実施。見出し・fence・metadataは取り込み時に付加 |
| [ASSISTANT_PROPOSALS.md](ASSISTANT_PROPOSALS.md) | 同じ対話のassistantによる名称候補およびAON案 | 必要性本位等の候補からAON案への推移、Owner版との差分、未決事項を**二次的に整理**。assistant応答の完全逐語録ではない | **要約・分析資料**。独立した逐語source eventとしての完全性は主張しない。Ownerの採用事実はU3で判定する |

## 判断の系譜

1. **先行P04（未承認の仮抽出）**：旧subjectsからYAGNIによる投機的機構の抑制と、既に選んだ責務を満たす必要な契約を高コストのみで省略しないことを抽出。A-1でのP04は正式採用ではなかった。
2. **U1（Ownerの問題提起）**：上記を境界面理論より抽象的な、開発や作業一般のYAGNIとは別の原則として命名することを希望。
3. **assistantの複数案→U2（OwnerのNiN案）**：必要なものは必要という方向に加え、今は不要なものは不要という意味も必要と指摘。
4. **assistantのAON案→U3（Ownerの明示採用）**：AON — All and Only Necessaryを選択し、Ownerが自身の表現で完全な定義文を提示。「実現の困難さや**時期**」はU3固有の文言であり省かない。
5. **U3の末尾**：GitHub recordsへの保存を依頼。本Bundleで当該event集合を閉じる。

NiNはU2で検討された候補であり、最終的な採用名称はAON。YAGNIの歴史的説明やP04の未決点を、AON採用と引き換えに無条件で否定・上書きしない。

## 未決・境界

- 「時期を理由に省略しない」と「実施順序の判断を混同しない」の関係・適用例は、今後必要に応じて解釈を確認する。**記録時に文言を調整したり、AIが新たな例外を創作したりしない**。
- AONをDev-Philosophyのどのファイル単位で制定するか、ほかの原則との独立・包含関係はA-3/A-4の後続判断で扱う。
- このrecordは**採用された名称と原則文のsource event**を記録する。正式なsubjects・artifacts・mainの変更や、ほかの哲学候補の承認まで実行するものではない。
- 過去recordは上書きせず、後続の修正・再定義は別recordとして接続する。

## 関連資料

- [P04 — A1_ROUGH_PHILOSOPHY](../../../repository/operations/stage2/A1_ROUGH_PHILOSOPHY.md)
- [境界面理論の再帰的選定・分割圧・統合圧に関する先行record](../2026-11-11-boundary-selection-and-split-pressure-philosophy-baseline/RECORD.md)
- [RECORD_MODEL](../../../repository/models/RECORD_MODEL.md)
- [DECISION_LINEAGE_MODEL](../../../repository/models/DECISION_LINEAGE_MODEL.md)

## GitHubへの反映範囲

- 保存ブランチ：refactor/dev-artifacts-restructure
- 新規保存：このディレクトリ内のRECORD.md / USER_MESSAGES.md / ASSISTANT_PROPOSALS.md
- 既存のrecords・subjects・artifacts・main：内容変更なし
