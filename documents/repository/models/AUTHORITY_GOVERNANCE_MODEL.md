# Authority and Governance Model

## 目的

Dev-Artifactsの**内容の規範的優先関係**と、保存・整理・運用に関する**概念ごとの定義権**を分けて管理する。物理directoryの親子関係だけで、どの文書が他の全領域より偉いかを決めない。

## 所有する対象

| 対象 | 定義・制定権を持つ者／領域 |
| --- | --- |
| Dev-Philosophyの思想・価値判断の内容 | **Owner本人** |
| Dev-Methodologyの開発指針・方法論 | その正本が意味を所有し、制定済みDev-Philosophyを前提として実現する |
| 原文・source eventの事実 | 第0情報源を根拠とし`records/`が保持する |
| Knowledge/Record/Subject/Decision Lineage/Traceability等の管理契約 | `documents/repository/models/` |
| リポジトリ固有の実行手順・検証 | `documents/repository/operations/` |
| AIに提供する派生Artifact | `artifacts/`。正本を再定義せずStage 3の規則で投影する |

## Dev-PhilosophyのOwner承認ゲート

- AIによる抽出、整理、文章化、改良**提案**は可能。
- Dev-Philosophyの**新規制定、意味を変える変更、撤回**にはOwnerの明示的な最終承認が必須。
- AIの推測、既存規則からの逆算、ファイル配置、Issueへの起票、テスト成功だけで承認したものとしない。
- 承認の対象・適用範囲・元の提案を識別できるsource eventをrecordsへ保全し、Decision Lineageで追跡可能にする。
- 誤字・書式など意味を変えない修正は、制定内容の変更として扱わなくてよい。ただし意味差の疑いがあればOwner承認を必要とする。
- **未承認の哲学候補を、currentの制定済み哲学として読ませてはならない。**

候補の具体的な保存場所、承認を反映する文書形式、複数承認のscope解決、Stage 2での昇格手順は**Stage 2**で設計する。

## 衝突解決の区別

### 規範の衝突

制定済みDev-Philosophyが、方法論その他の下位層の内容と同一の規範的scopeで衝突した場合、哲学の意味を優先する。方法論を直すか、矛盾を未解決として扱いOwnerへ確認する。下位層が哲学を勝手に訂正しない。

### 根拠・内容の衝突

recordとsubjectの間で「何が採用されたか」「何が発言されたか」に疑義がある場合、第0情報源・records・Decision Lineageを確認して現在評価を解決する。これはDev-Philosophyの規範的優先と別の問題である。

### 管理規則と運用手順の衝突

管理契約の意味は`repository/models/`が所有し、`operations/` はそれを具体的な手順として実施する。矛盾があれば運用手順を見直す。モデル変更には根拠となる判断をrecordsへ保存する。

## 証拠と承認は別

- IssueやPRは調整・実装の管理場として利用可能。ただし記録の原文保存は`records/`に従う。
- 「提案」「検証」「暫定配置」と「採用・制定」は区別する。
- 日付が新しいことだけで決定の有効性を判断しない。判断が足りなければ`unresolved`とする。
- この管理モデル自身に哲学の内容を制定する権限はない。

## 根拠

- [3層モデルと用語決定](../../knowledge/records/2026-11-10-dev-layers-terminology/)
- [Stage 1採用](../../knowledge/records/2026-11-11-dev-artifacts-stage1-governance/)
- [Owner相談メモ](../../knowledge/records/2026-11-11-dev-artifacts-owner-memo/)
- [Decision Lineage](DECISION_LINEAGE_MODEL.md)
