---
record_format: 1
record_kind: bundle
recorded_date: "2026-11-10"
scope: "Muse サイドチャットにおける、AIへ渡す知識の3層モデル（思想／開発指針／AIオーケストレーション）の提示・承認、Dev-Artifacts 内での層分離方針の議論、およびユビキタス言語4語（Dev-Philosophy / Dev-Methodology / Dev-Artifacts / AI-Orchestration）の制定・固定まで。取り込み時点で閉じた集合であり、同チャットの後続議論は含まない"
decision_lineage:
  event: "adoption"
  scope: "Dev-Artifacts / AI-Orchestration ubiquitous language"
---

# Dev layers and terminology — source event bundle

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `USER_MESSAGES.md` (U1–U10) | Muse サイドチャット「Museゆかりの開発プロトコルを議論」(chat_id: 28c0992d-7cee-4cd8-ba80-be3943937c04)、seq 1381–1457、2026-11-10 20:08–20:47 JST | チャット開始から用語固定（U9）と記録指示（U10）までの Owner メッセージ全10件を会話順に全文収録。会話全量ではない（assistant 返信は別 payload の選定分のみ） | Muse チャット表示（chat reader が返した可視テキスト）から転記。要約・言い換えは意図していない。原文 API との byte-level 照合なし。event 見出し・fence は取り込み時に新設 |
| `ASSISTANT_PROPOSALS.md` (P1–P7) | 同チャット、seq 1393–1456 | Owner 判断が参照する assistant 返信7件を選定して全文収録：2リポジトリ把握整理（U4が承認）、3層の再構成と判定テスト、分離案への条件提示、用語候補（Doctrine 案。後に不採用側の経緯として保持）、Philosophy 評価、用語集ドラフトと衝突への注意（U9が固定）、固定後の確認。その他の assistant 返信は含まない | 同上。P4 末尾の options widget 埋め込みトークンはクライアント表示上の artifact であり、表示どおり保持した |

## Decision lineage and scope

- **Adopted (terminology):** Owner は U9「固定しよう。」により、次の4語をユビキタス言語の核として固定した。層1 = **Dev-Philosophy（開発哲学）**（内容の性質は哲学、規範上の地位は憲法的位置＝他層と衝突した場合は優先する）、層2 = **Dev-Methodology（開発方法論）**、層1＋層2の総称 = **Dev-Artifacts**（単独の "Artifacts" は従来どおり射影パック側を指す）、層3 = **AI-Orchestration（AIオーケストレーション）**（性格はプロトコル）。依存は AI-Orchestration → Dev-Methodology → Dev-Philosophy の一方向。
- **Adopted (framing):** Owner は P1 の2リポジトリ把握整理を U4 冒頭で承認し、同メッセージで3層モデル自体を提示した。層の区別は「共通項の有無」ではなく、独立性と依存の向きによる：層2は AI を消しても開発指針として成立し、層3は AI エージェントの存在形式に前提として依存する（特定の AI 製品への依存ではない）。
- **Direction, not yet adopted:** documents-artifacts の中で層1と層2を明確に分けて管理し、層3は独立リポジトリとし、層2で定義済みの概念を層3で再定義しない、という方向（U5、P3 の条件付き賛成）は議論の到達点であって、構造変更の実施判断ではない。棚卸し（既存 subjects の層帰属分類）が後続作業として残っている。
- **Not adopted:** P4 の層1候補「ドクトリン (Doctrine)」は、U7 の Philosophy 提示と P5 の比較を経て採用されなかった。候補として提示された事実のみを保持し、現行用語としては扱わない。
- **Authority boundary:** この記録は会話の保存であり、subjects / artifacts の変更、リポジトリ構造の変更、remote への push や merge を許可するものではない。用語集の正本化（subjects への反映）は別途の source event と判断を要する。
- **Closure:** 本 Bundle は U10 の記録指示時点の source 集合として固定する。同チャットで続く議論（関係を表す用語、棚卸し等）は新しい record として追加し、本 Bundle へ継ぎ足さない。
