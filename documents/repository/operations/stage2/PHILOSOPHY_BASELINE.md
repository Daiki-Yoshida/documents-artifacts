# 開発哲学を再構築するための基準点（Philosophy Baseline）

**Stage 2-A-3の優先的な参照起点。永久的な規範順位を表すものではない。**

## 位置づけ

2026-11-11にOwner自身が**直接哲学を議論した5つの独立record**を、先行する歴史的記録を読み解くときの重要な基準点として識別する。

- `-philosophy-baseline` の接尾辞は、議論の重要性・当面の参照順を示す**発見の手掛かり**。 `record_kind`、`decision_lineage`、`current`、`supersedes` 等の意味上の状態ではない。
- これらの**Ownerの原文**を優先的に把握する。AIの提案や推論を同格に扱わない。
- 旧recordsのうち同一論点について先行していた記述との違いは、まずこの基準点のOwnerの意図を踏まえて調査し、**新旧の採否を暗黙に決めず**Decision Lineage・対象scope・明示的な訂正を調べる。
- 明示採用が確認できるのは例えば**AON原則の名称とOwner自身による定義**。ほかの対話は、深い思想形成を示していても、完成版Dev-Philosophyを一括承認したものではない。
- 未来のOwnerの哲学の改訂・補足は**新しいrecord**に保存する。後続recordが判断をrefine / correct / supersedeし得る。後続のrecordsをこの接尾辞で一律に格下げしない。
- 旧recordsは削除せず、あらゆる矛盾を「新しい日付のほうが上」と判断しない。**基準点の優先的な参照と、規範的authorityの確定は別の軸**。
- Dev-Philosophyのsubject構造は、A-3の内容吟味を経てA-4で合意する。Stage3のArtifacts構造も本件では決めない。

## 対象recordと旧path→新path対応

すべて`documents/knowledge/records/`配下。リンクは改名後のディレクトリへ向ける。

| 対話の主題 | 旧ディレクトリ | 現在のディレクトリ |
| --- | --- | --- |
| 命名・意味・契約 | `2026-11-11-naming-semantics-contract-philosophy/` | [`2026-11-11-naming-semantics-contract-philosophy-philosophy-baseline/`](../../../knowledge/records/2026-11-11-naming-semantics-contract-philosophy-philosophy-baseline/RECORD.md) |
| 境界面理論・第1段 | `2026-11-11-boundary-horizon-dialogue/` | [`2026-11-11-boundary-horizon-dialogue-philosophy-baseline/`](../../../knowledge/records/2026-11-11-boundary-horizon-dialogue-philosophy-baseline/RECORD.md) |
| 境界の選定・分割圧・統合圧 | `2026-11-11-boundary-selection-and-split-pressure/` | [`2026-11-11-boundary-selection-and-split-pressure-philosophy-baseline/`](../../../knowledge/records/2026-11-11-boundary-selection-and-split-pressure-philosophy-baseline/RECORD.md) |
| AON原則のOwnerによる制定 | `2026-11-11-aon-principle-adoption/` | [`2026-11-11-aon-principle-adoption-philosophy-baseline/`](../../../knowledge/records/2026-11-11-aon-principle-adoption-philosophy-baseline/RECORD.md) |
| 真実・原本・解釈・NAL | `2026-11-11-truth-source-interpretation-nal/` | [`2026-11-11-truth-source-interpretation-nal-philosophy-baseline/`](../../../knowledge/records/2026-11-11-truth-source-interpretation-nal-philosophy-baseline/RECORD.md) |

## 同じ日付でも対象としないもの

- `2026-11-11-truth-intent-information-nal-dialogue/` は、最後の真実・NALの基準recordと**Owner発言11件が全て同一**であることを照合した重複取り込み（`RECORD.md` なし）。後続のOwner指示により、**開発ブランチの現在のrecordsから重複ディレクトリを削除済み**。正規記録の4ファイルは一切変更していない。削除側の別文面のAI二次分析も、削除前commit `9012d8fc3699927256e28297264693e9d69e2a72` およびblob SHA `4577ee7858acd45ebce31999f94c51f0fe049fc0` から復元可能。経緯は[重複取り込み整理record](../../../knowledge/records/2026-11-11-truth-nal-duplicate-cleanup/RECORD.md)に保存した。
- `2026-11-11-dev-artifacts-owner-memo/`、`2026-11-11-dev-artifacts-stage1-governance/`、`2026-11-11-stage2-philosophy-first/`、`2026-11-11-stage2-language-issue/` 等は、同日の重要な**管理・工程・是正記録**だが、今回の哲学形成の直接対話とは別。接尾辞を付けない。
- 本件を記録する`2026-11-11-philosophy-baseline-designation/`も管理上の判断であり、接尾辞の対象外。

## 参照と移行の取り扱い

記録原本の`USER_MESSAGES.md`や`ASSISTANT_MESSAGES.md`、`ASSISTANT_PROPOSALS.md`の**blob SHAは改名前後で不変**。 `RECORD.md` 内にある旧ディレクトリ名を参照するmetadata上の相対リンクのみ必要最小限で更新する。

古いGitHub Issue/Chatのリンクはコミット時点のパスを記録していることがある。改名後の現在の位置を本表で確認できる。Git履歴の元コミットのファイルは保持される。

**決定根拠：** [Ownerの接尾辞要望と暫定基準点の原文](../../../knowledge/records/2026-11-11-philosophy-baseline-designation/USER_MESSAGE.md)。`-philosophy-baseline`という具体的な語はAI選定であり、Owner自身の逐語表現ではない。
