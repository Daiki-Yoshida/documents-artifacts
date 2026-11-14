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

**匿名レビュー用本文の扱い：** [草案](A3_PHILOSOPHY_DRAFT.md)が唯一の継続編集元であり、[独立レビュー用本文](review-export/CONTRACT_BOUNDARY_PHILOSOPHY.md)はそこから私が手動で整えた独立スナップショット。現在の版は草案blob `9c67c531053052bbfbb7f04efae0836825d9fe05` を基準に手動で整え、出力blob `f5f412d1bea08059126c00c0007c298e19abcea4`。今回のD2.2・D3.4・D5.4・D6.1の説明拡充を反映済み。S17・S18、Subject完全性を重視した説明拡充、今回の契約成立・履行・境界・乖離の接続整理を反映済み。草案を更新したときは必要に応じて私が本文を手動で整え直す。**恒久的な生成スクリプトは設けない。** 匿名レビューではリポジトリやこのINDEXのURLではなく、出力ファイルのMarkdown本文のみを渡す。

**本文・章構成とも未承認。** Ownerは現在の六章を**契約境界哲学体系**と位置づけ、まず本体系をほぼ完成させてからAON・記録・環境の潔癖など他の思想を別途論じると判断した。これら他領域の詳細・分類や相互関係は本A-3資料では未決定。A-4の構造合意やA-5のsubject化を完了したものではない。

基点主体と枝ごとのミクロ側の壁、既存原理からの帰結と規範的指針を[草案本文](A3_PHILOSOPHY_DRAFT.md)へ接続した。[現行のレビュー状態](A3_PHILOSOPHY_REVIEW.md#review-status)では、本六章について独立して維持する未解決論点はない。具体的な実務的実現はDev-Methodologyが担い、草案本文の正式承認と構成の最終確定は引き続きA-3以降で扱う。

[六章全体レビュー](A3_WHOLE_DRAFT_REVIEW.md)では、固定版 `0d8e5953` を対象に概念接続と主要原文を照合した。その後、**E01（探索方向）・E02（認識した乖離への対処）・E03（実現するの関係語）・E04（出典注記）を現行草案へ編集反映**した。加えて[今回の概念・境界の反例検証](A3_CONCEPTUAL_STRESS_REVIEW.md)では10事例を点検し、E06（まとまりの定義と契約の成立の区別）・E07（乖離と変化の区別）・E08（独立理論名の不必要な追加を避ける）を編集で明瞭化した。**これらの編集結果自体はOwnerによる全文承認前**である。E05（重複説明の圧縮）は意味の欠落を避けるため任意のまま保留する。

[導出検討のrecord](../../../knowledge/records/2026-11-13-philosophy-question-derivations/RECORD.md)に先行対話を保存。さらに[別チャット由来の本質論・対象範囲の対話record](../../../knowledge/records/2026-11-13-development-philosophy-essence-dialogue-import/RECORD.md)を原文のまま取り込み、Owner発言に基づく補強案を草案D1.2と冒頭へ反映した。

[認識・情報化・実体験と欲求＝本質のOwner発言／Assistant応答を収録した哲学baseline](../../../knowledge/records/2026-11-14-recognition-information-and-virtuality-philosophy-baseline/RECORD.md)、[合意の具体的成立が具象と結びつくことを示すOwner原文record](../../../knowledge/records/2026-11-14-agreement-and-concrete-formation-philosophy-baseline/RECORD.md)、[Subjectとしての意味完全性と作業基点を再確認したOwner指示record](../../../knowledge/records/2026-11-14-philosophy-subject-completeness-and-context-realignment/RECORD.md)、[今回の完成度向上に向けたOwnerの継続依頼](../../../knowledge/records/2026-11-14-contract-boundary-quality-review-request/RECORD.md)、[契約境界哲学体系そのものを原則とするOwner判断](../../../knowledge/records/2026-11-14-contract-boundary-principle-unification/RECORD.md)、[命名の採用範囲に関する先行Owner判断](../../../knowledge/records/2026-11-14-contract-boundary-terminology-approval/RECORD.md)、[契約境界哲学体系の範囲・検討順序に関するOwner判断](../../../knowledge/records/2026-11-14-contract-boundary-philosophy-scope-sequencing/RECORD.md)、[哲学と方法論の責務境界についてのOwner判断](../../../knowledge/records/2026-11-14-q01-closure-q02-guidance/RECORD.md)、[基点主体と双璧の継続対話](../../../knowledge/records/2026-11-14-contextual-base-subject-and-branchwise-walls-philosophy-baseline/RECORD.md)、[今回の分析へのOwner承認](../../../knowledge/records/2026-11-14-q02-closure-and-baseline-integration/RECORD.md)を、それぞれ独立したrecordsとして保持する。

**今回の匿名レビューを受けた追加編集：** D2.2で欲求のフラクタル性と「幸せになりたい」のような広い欲求の扱いを補強。D3.4で内部自由を契約上の自由と明示し、実現可能性・下位や他の契約による制約と区別。D5.4で分割既定の根底にある独立した意味・責任・内部自由の価値を説明し、ねじの一体性と現状密結合だけでは統合を正当化しない留保を接続。D6.1で再定義の望ましさを弱めず、実態修正による乖離解消と両立することを明示した。詳細は[A3レビューL09](A3_PHILOSOPHY_REVIEW.md#l09)。 D1.2で境界の意味と構造上の役割を区別（境界の独立分類は増設しない）。D3.3で履行を成立済み契約と実態の対応状態として明示し、成立前の適合と区別。D3.2の法律公布例は当事者関係を一律推定しないよう限定。D4.2の認識説明の重複を整理。D6.1で乖離への対処、再定義の望ましさ、実態修正で解消できる場合、再定義の大きなコスト・影響と境界の堅牢性をOwner原文に沿って接続した。詳細は[A3レビューL08](A3_PHILOSOPHY_REVIEW.md#l08)。これらはAssistant編集案でありOwnerの修正文面承認ではない。

**今回のSubject完全性に関する編集：** 草案本文は今回、背景・概念間の接続・誤読防止を20箇所補い、約3,000文字を追加した。六章23節の構造は維持し、認識された情報と仮想的なまとまりを独立階層・工程としない説明、欲求＝本質、合意の具体的成立、履行状態と評価行為の区別などを拡充した。A-3草案は `documents/repository/operations/stage2/` に置かれた作業資料だが、内容上は将来の `documents/knowledge/subjects/` に整理されるDev-PhilosophyのSubject候補である。したがって `SUBJECT_MODEL.md` のsemantic completenessを適用し、背景・概念間の接続・例・反例・誤読防止を必要に応じて本文に保持する。Artifactのtoken圧縮・runtime projectionを草案へ逆適用しない。匿名レビュー用本文は草案から派生する別成果物であり、匿名化は派生文書側で行う。詳細は[Ownerの作業責務・基点再確認record](../../../knowledge/records/2026-11-14-philosophy-subject-completeness-and-context-realignment/RECORD.md)と[A3レビューL07](A3_PHILOSOPHY_REVIEW.md#l07)を参照する。

**今回の根源的な接続：** [S17のOwner原文とAssistant応答](../../../knowledge/records/2026-11-14-recognition-information-and-virtuality-philosophy-baseline/RECORD.md)に基づき、[草案](A3_PHILOSOPHY_DRAFT.md)のD1.1・D1.3・D2.2・D4.2に、認識を介する言及、個体にも及ぶ仮想性、直接の体験と情報化された記憶の違い、欲求＝本質の強い結合を追記した。旧「中身を未決定として論じられる」という説明はD1.3から除去。**これは草案へのAssistant編集反映であり、今回の修正文のOwner承認ではない。** また、**「仮想」「情報化」「認識＝情報」の用語の最終的な関係はまだ検討中**とする。S17の「情報化」は正式な全面改名の合意ではない。

**契約境界哲学体系をほぼ完成と評価するための残る確認：** 六章23節の本文と出典対応のOwnerによる通読・意図の確認、E01〜E04・E06〜E08および今回のS17に基づく修正文が原意を保っているかの確認、E05の要否判断、仮想と情報化の用語関係の検討。**体系そのものを原則とし、個別の原則名や略称を設けない判断は確定済み**。章名・用語と性質の参照名もOwner採用範囲で反映済み。現在の独立したQ01・Q02は終了済みであり、他思想をこの六章へ混ぜることは完成条件としない。正式制定とA-4の構成確定は別の承認判断とする。

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
