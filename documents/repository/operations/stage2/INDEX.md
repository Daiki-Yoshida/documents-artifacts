# Stage 2：調査・検証資料（未承認）

本ディレクトリはStage 2の監査・抽出・Owner吟味の作業資料領域であり、Dev-Philosophyの正本ではない。見出し・ファイル名は英語でも、**記述・分析・Ownerレビューは日本語を標準**とする。

進行規則：[Stage 2の進行手順](../STAGE2_WORKFLOW.md)。

**[開発哲学の基準点（-philosophy-baseline）](PHILOSOPHY_BASELINE.md)：** Ownerが直接議論した対話recordsを、Stage 2-A-3の優先参照起点として識別する。対象と継続関係は基準点一覧で管理し、形式上の接尾辞だけで採用statusや永続的な規範優先順位を付与しない。

## A-3：契約境界哲学体系の編集用草案

| 成果物 | 用途 |
| --- | --- |
| [A3_PHILOSOPHY_DRAFT.md](A3_PHILOSOPHY_DRAFT.md) | 開発哲学の一領域である**契約境界哲学体系**の六章23節の草案。採用された章名・性質参照名を反映し、内部の独立した原則名は設けない |
| [A3_PHILOSOPHY_REVIEW.md](A3_PHILOSOPHY_REVIEW.md) | 本文とOwner原文の対応、訂正経緯、命名の採用範囲、現在のレビュー状態を管理する資料 |
| [A3_UBIQUITOUS_LANGUAGE.md](A3_UBIQUITOUS_LANGUAGE.md) | Ownerが採用した体系・章名、用語、性質の参照名と、体系自体を原則とし個別原則名を設けない方針の索引 |
| [A3_WHOLE_DRAFT_REVIEW.md](A3_WHOLE_DRAFT_REVIEW.md) | 固定版の六章23節横断レビュー。E01〜E04は現行草案へ反映済み、E05は未反映の任意編集候補 |
| [A3_CONCEPTUAL_STRESS_REVIEW.md](A3_CONCEPTUAL_STRESS_REVIEW.md) | 定義・合意・履行・共有実態・再定義・分割についての10事例による概念上の反例検証。E06〜E08の表現精度を改善。正式承認ではない |
| [匿名・単独レビュー用本文](review-export/CONTRACT_BOUNDARY_PHILOSOPHY.md) | A3_PHILOSOPHY_DRAFT.mdから今回手動で整えた六章23節の独立した提示文。原文の議論・出典・Issue・編集指示を含めず、別AIへ本文だけ渡す用途。正式制定物ではない |

**匿名レビュー用本文の扱い：** [草案](A3_PHILOSOPHY_DRAFT.md)が唯一の継続編集元であり、[独立レビュー用本文](review-export/CONTRACT_BOUNDARY_PHILOSOPHY.md)はその時点の手動生成スナップショット。基準にした草案blobは `a3bee3c2dc51829ead624f3e9829fd4473f038e9`。以後草案に変更があれば、必要時に改めて本文を手動で整え直す。**恒久的な生成スクリプトは設けない。** 匿名レビューではリポジトリやこのINDEXのURLではなく、出力ファイルの中身のみを渡す。

**本文・章構成とも未承認。** Ownerは現在の六章を**契約境界哲学体系**と位置づけ、まず本体系をほぼ完成させてからAON・記録・環境の潔癖など他の思想を別途論じると判断した。これら他領域の詳細・分類や相互関係は本A-3資料では未決定。A-4の構造合意やA-5のsubject化を完了したものではない。

基点主体と枝ごとのミクロ側の壁、既存原理からの帰結と規範的指針を[草案本文](A3_PHILOSOPHY_DRAFT.md)へ接続した。[現行のレビュー状態](A3_PHILOSOPHY_REVIEW.md#review-status)では、本六章について独立して維持する未解決論点はない。具体的な実務的実現はDev-Methodologyが担い、草案本文の正式承認と構成の最終確定は引き続きA-3以降で扱う。

[六章全体レビュー](A3_WHOLE_DRAFT_REVIEW.md)では、固定版 `0d8e5953` を対象に概念接続と主要原文を照合した。その後、**E01（探索方向）・E02（認識した乖離への対処）・E03（実現するの関係語）・E04（出典注記）を現行草案へ編集反映**した。加えて[今回の概念・境界の反例検証](A3_CONCEPTUAL_STRESS_REVIEW.md)では10事例を点検し、E06（まとまりの定義と契約の成立の区別）・E07（乖離と変化の区別）・E08（独立理論名の不必要な追加を避ける）を編集で明瞭化した。**これらの編集結果自体はOwnerによる全文承認前**である。E05（重複説明の圧縮）は意味の欠落を避けるため任意のまま保留する。

[導出検討のrecord](../../../knowledge/records/2026-11-13-philosophy-question-derivations/RECORD.md)に先行対話を保存。さらに[別チャット由来の本質論・対象範囲の対話record](../../../knowledge/records/2026-11-13-development-philosophy-essence-dialogue-import/RECORD.md)を原文のまま取り込み、Owner発言に基づく補強案を草案D1.2と冒頭へ反映した。

[今回の完成度向上に向けたOwnerの継続依頼](../../../knowledge/records/2026-11-14-contract-boundary-quality-review-request/RECORD.md)、[契約境界哲学体系そのものを原則とするOwner判断](../../../knowledge/records/2026-11-14-contract-boundary-principle-unification/RECORD.md)、[命名の採用範囲に関する先行Owner判断](../../../knowledge/records/2026-11-14-contract-boundary-terminology-approval/RECORD.md)、[契約境界哲学体系の範囲・検討順序に関するOwner判断](../../../knowledge/records/2026-11-14-contract-boundary-philosophy-scope-sequencing/RECORD.md)、[哲学と方法論の責務境界についてのOwner判断](../../../knowledge/records/2026-11-14-q01-closure-q02-guidance/RECORD.md)、[基点主体と双璧の継続対話](../../../knowledge/records/2026-11-14-contextual-base-subject-and-branchwise-walls-philosophy-baseline/RECORD.md)、[今回の分析へのOwner承認](../../../knowledge/records/2026-11-14-q02-closure-and-baseline-integration/RECORD.md)を、それぞれ独立したrecordsとして保持する。

**契約境界哲学体系をほぼ完成と評価するための残る確認：** 六章23節の本文と出典対応のOwnerによる通読・意図の確認、E01〜E04およびE06〜E08の修正文が原意を保っているかの確認、E05の要否判断。**体系そのものを原則とし、個別の原則名や略称を設けない判断は確定済み**。章名・用語と性質の参照名もOwner採用範囲で反映済み。現在の独立したQ01・Q02は終了済みであり、他思想をこの六章へ混ぜることは完成条件としない。正式制定とA-4の構成確定は別の承認判断とする。

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
