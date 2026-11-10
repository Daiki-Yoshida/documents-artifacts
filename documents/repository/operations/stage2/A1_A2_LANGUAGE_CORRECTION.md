# A-1/A-2初期資料の言語是正記録

## 根拠

今回のOwner本人の問題提起は[2026-11-11-stage2-language-issue](../../../knowledge/records/2026-11-11-stage2-language-issue/)に原文保存した。以前の英語版からの単なる翻訳ではなく、日本語原文を再確認することを是正方針とする。

## 発端

初期の`A1_ROUGH_PHILOSOPHY.md`、`A2_FINDINGS.md`、coverage台帳、`STAGE2_WORKFLOW.md`などを、AIが不適切に英語で作成した。

旧`documents-artifacts`では、`records`は原文言語、`subjects`は日本語、`artifacts`は配布向け英語という役割分離があった。粗哲学はsubjectsへ向かう途中の知識資料であり、Artifacts向けの英語方針を当てはめる理由はない。

## 是正

- 英語版の初稿は**現在のレビュー対象として無効**。原本Git履歴を保ちつつ、調査資料を日本語に書き換える。
- A-1粗哲学の主要な候補は、検証済みの**旧subjects日本語原文**から改めて記述し、原文引用とAIの暫定解釈を分ける。
- A-2所見も、確認済みrecordsから日本語で再記述する。
- A-1/A-2 coverage台帳の列名・確認状態の説明を日本語にし、各source path・blob SHAと確認状況は保持する。
- Stage 2の運用手順に、**records原文言語の尊重／subjectsおよび中間抽出資料の日本語標準／翻訳による意味改変の防止**を明文化する。
- 現在の分析を正しいと断定しない。A-1の未調査文書とA-2の未調査recordsはこれまでどおり未確認。

## 範囲・注意

初回の英語記述により生じた意味差を、すべて解決できたと保証しない。今後のA-1/A-2は引き続き原文から監査し、必要な条件・例外・規範強度・Decision Lineageを確認する。OwnerのA-3承認は未実施。

変更前の英語版は、`refactor/dev-artifacts-restructure`の`b1ba497caafd049091538c608925f06a3e5fa14b`時点のGit履歴から追跡できる。既存recordおよび`main`は変更しない。
