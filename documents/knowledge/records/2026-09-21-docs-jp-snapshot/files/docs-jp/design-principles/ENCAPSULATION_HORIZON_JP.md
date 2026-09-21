# Encapsulation Horizon — 設計判断の情報源ログ

```yaml
document_scope: "rationale_log_index"
exported_artifact: false
default_copy_target: false
authoritative: false
language: "japanese"
canonical_guidance: "artifacts/design-principles/"
purpose: "Encapsulation Horizon に関する設計判断の背景・推論・変遷を、人間が後から参照できるようにする"
```

## この文書の位置づけ

この文書と配下の source log は、**現在有効な設計規範の正本ではありません**。

現在有効なルール・判断基準は、`artifacts/design-principles/` 配下の英語ドキュメントを正本とします。ここに残す日本語資料は、Encapsulation Horizon を形作った推論、検討過程、過去の方針を保存し、将来の再検討時に参照するための **情報源ログ（rationale/source log）** です。

```yaml
relation:
  artifacts/: "現在有効な規範。AI向け配布物であり唯一の正本"
  this_document: "情報源ログへの入口。規範ではない"
  source_logs: "過去の推論・背景・判断材料を保存する記録"
  conflict_rule: "内容が食い違う場合は artifacts/ を正とする。source log から artifacts/ を上書き解釈しない"
  update_rule: "source log の考えを再採用する場合は、改めて評価して artifacts/ を明示的に更新する"
```

## 読み方

現在の設計判断を行う場合は、まず次を参照します。

- `../../artifacts/design-principles/DESIGN_PHILOSOPHY.md`
- `../../artifacts/design-principles/CODING_STANDARDS.md`
- `../../artifacts/design-principles/PROJECT_STRUCTURE.md`
- `../../artifacts/design-principles/AI_WORKFLOW.md`

「なぜその方針になったのか」「以前どのような考え方をしていたのか」を調べる場合に、source log を参照します。

## 保存している詳細ログ

- [`source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`](source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md)
  - Encapsulation Horizon の詳細な推論を保存した旧文書を、そのまま履歴資料として残しています。
  - 文中の「原本」「source of truth」「artifacts より本書を優先する」といった記述は**当時の方針を示す歴史的記述であり、現在は失効しています**。
  - 現在の規範解釈に利用してはいけません。

## このログから現在も参照価値がある主な論点

以下はあくまで再検討の入口です。具体的な現在ルールは必ず `artifacts/` を参照します。

- 境界面は厳密にし、内部実装は柔軟に保つという非対称性
- 境界原理は再帰的だが、すべての粒度を機械的に硬化しないこと
- Encapsulation Horizon を固定スケールではなく、責務・成熟度・継ぎ目コストで動く硬化線として捉える考え
- module を絶対的な floor ではなく、初期の prior として扱う考え
- 内部の自由は、外部契約が漏洩チャネルを閉じることで成立するという考え
- 責務の成熟や分裂に応じて、内部境界を後から昇格させる考え

## 履歴管理

この領域独自の版管理・アーカイブ機構は持ちません。変更履歴、過去版、差分、復元は Git の履歴を利用します。
