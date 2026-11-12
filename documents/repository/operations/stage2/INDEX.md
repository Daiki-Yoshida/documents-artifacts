# Stage 2：調査・検証資料（未承認）

本ディレクトリはStage 2の監査・抽出・Owner吟味の作業資料領域であり、Dev-Philosophyの正本ではない。見出し・ファイル名は英語でも、**記述・分析・Ownerレビューは日本語を標準**とする。

進行規則：[Stage 2の進行手順](../STAGE2_WORKFLOW.md)。

**[開発哲学の基準点（-philosophy-baseline）](PHILOSOPHY_BASELINE.md)：** Ownerが直接議論した対話recordsを、Stage 2-A-3の優先参照起点として識別する。対象と継続関係は基準点一覧で管理し、形式上の接尾辞だけで採用statusや永続的な規範優先順位を付与しない。

## A-3：編集用の哲学体系草案

| 成果物 | 用途 |
| --- | --- |
| [A3_PHILOSOPHY_DRAFT.md](A3_PHILOSOPHY_DRAFT.md) | 六章・D番号で継続編集する哲学本文の草案。定義・主体・契約三定義・内部自由・双璧と幅／粒度・乖離と再定義を扱い、既存原理からの導出案を該当節へ明示する |
| [A3_PHILOSOPHY_REVIEW.md](A3_PHILOSOPHY_REVIEW.md) | 本文とOwner原文の対応、訂正経緯、AIの接続案、現在の未解決論点Q01・Q02と出典対応を管理するレビュー資料 |

**本文・章構成とも未承認。** AONと真実・原本・記録・NALの統合は今回の対象外。これはA-3の吟味を進める編集面であり、A-4の構造合意やA-5のsubject化を完了したものではない。

既存の哲学から導いた説明は[草案本文](A3_PHILOSOPHY_DRAFT.md)に反映し、[現在の未解決論点はQ01とQ02](A3_PHILOSOPHY_REVIEW.md#remaining-questions)に絞った。検討経緯はrecordsとGit履歴から辿れる。導出案や本文は未承認である。

[導出説明・更新依頼のrecord](../../../knowledge/records/2026-11-13-philosophy-question-derivations/RECORD.md) には、Ownerの問い、Assistantの回答全文、Ownerの記録・草案更新指示を、選定した3メッセージとして保存している。

今後は同じ草案ファイルを編集し、変更をGit履歴で追う。原文recordsは編集用本文と分離して保持する。[草案作成依頼のrecord](../../../knowledge/records/2026-11-13-philosophy-editable-draft-request/RECORD.md) / [議論の入口：Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)。

## A-1/A-2：一次監査完了

| 成果物 | 用途 |
| --- | --- |
| [A1_A2_COMPLETION_REPORT.md](A1_A2_COMPLETION_REPORT.md) | A-1/A-2の完了判定・Ownerへ引き継ぐ論点 |
| [A1_SUBJECTS_COVERAGE.md](A1_SUBJECTS_COVERAGE.md) | 旧 `main` のsubjects **70/70ファイル**の全件照合台帳 |
| [A1_ROUGH_PHILOSOPHY.md](A1_ROUGH_PHILOSOPHY.md) | 日本語原文を起点とする**未承認の粗哲学候補P01〜P17** |
| [A2_RECORDS_COVERAGE.md](A2_RECORDS_COVERAGE.md) | records **206/206ファイル**の全件確認台帳（source SHA固定） |
| [A2_DECISION_LINEAGE_REVIEW.md](A2_DECISION_LINEAGE_REVIEW.md) | **105 recordディレクトリ**別の原文役割と後続判断の照合 |
| [A2_FINDINGS.md](A2_FINDINGS.md) | 主要な意味差・採用訂正・歴史状態の照合**16件** |
| [A1_A2_LANGUAGE_CORRECTION.md](A1_A2_LANGUAGE_CORRECTION.md) | 英語初稿の不備・日本語での原文起点再構成 |

**範囲：** 全ファイルの本文取得と哲学関連の一次点検、重要な系譜の確認を実施。全命題の唯一解釈の証明や、候補のOwner承認を意味しない。継続的な意味の精緻化・本人の価値判断はA-3、実際の分類構造はA-4に進める。

**現在：A-1/A-2の一次監査完了、A-3のOwner対話・草案吟味進行中。** `documents/knowledge/subjects/dev-philosophy/`と`artifacts/`は未構築。
