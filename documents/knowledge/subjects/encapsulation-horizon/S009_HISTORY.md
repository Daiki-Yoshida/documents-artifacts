# Encapsulation Horizon — Historical Context

この文書は、原本の位置づけ、旧artifactとのauthority関係、旧artifactへの圧縮対応を歴史的文脈として保持する。

現在の第1情報源が旧artifactであるという意味ではない。以下は原本作成時点の記録として保持する。

## Original preamble

# Encapsulation Horizon — 境界設計の原本

```yaml
document_scope: "reference_material"
exported_artifact: false
default_copy_target: false
ai_loading: "AIに毎回読ませる文書ではない。これは思想の原本(source of truth/rationale)であり、AI常読のコンテキストファイルではない"
language: "japanese"
purpose: "境界設計思想（Encapsulation Horizon）の全推論を保存する原本。artifacts/ はこの思想の運用サブセットを圧縮符号化したものであり、本書がその出典である"
authored_by: "project owner"
```

---

## 0. この文書の位置づけ

`artifacts/` の各文書は **AIが毎回読む運用版**である。トークン効率のため圧縮されており、
圧縮は必ず文脈を落とす。落ちた文脈は、別のAIセッションや別の読み手による**再解釈（伝言ゲーム）**を招く。

本書はそれを防ぐための **原本** である。ここには結論だけでなく、結論に至る**推論の全鎖**を残す。
artifacts が矛盾して見えたり、運用ルールの「なぜ」が失われたときは、**本書が最終的な出典**となる。

```yaml
relation:
  this_document: "思想の全推論（why の why まで）。非配布・非AI常読"
  artifacts/:     "上記の運用サブセット。配布・AI常読。圧縮版"
  rule: "artifacts は本書から導出される。両者が食い違ったら本書が正。artifacts からは本書を参照しない（配布先に存在しないため）"
```

---

---

## 11. artifacts との対応（この原本が出典である運用版）

本書の各部は、artifacts では以下に**圧縮符号化**されている。artifacts 単独では「なぜ」が落ちるため、
意図の確認は常に本書へ戻ること。

| 本書の節 | 対応する artifact |
| :--- | :--- |
| §1 境界面は固く内部は柔軟 | `DESIGN_PHILOSOPHY.md` → Redefining OOP（Shell vs Core Logic） |
| §2 フラクタル | `DESIGN_PHILOSOPHY.md` → Boundaries Are Recursive (Scale-Invariant) |
| §4–5 地平線・コスト非対称 | `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal / `accuracy_vs_speed`；`PROJECT_STRUCTURE.md` |
| §5 責務＝機能のまとまり | `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design (SRP) |
| §6 硬化の条件・YAGNI | `CODING_STANDARDS.md` → Interface Requirement Threshold |
| §6.5 探索方向・既定・初期地平線 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（direction / default-harden / module=prior / maturity）；`AI_WORKFLOW.md` → Pre-Implementation Scan #1（Module Shell & Horizon） |
| §7 完全な契約・漏洩チャネル | `DESIGN_PHILOSOPHY.md` → Bounded Contracts / Module Shell の `leakage_channels`＋`duality`；`CODING_STANDARDS.md` → Interface Documentation（Semantics に resource/determinism を宣言）, Error/Concurrency 契約 |
| §8 AND テスト・再分割 | `DESIGN_PHILOSOPHY.md` → SRP validation（"AND" appears → split）, Encapsulation Horizon（`re_draw_reactively`） |
| §8 外面保持 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（`preserve_outer_surface`）；`CODING_STANDARDS.md` → Contract Evolution（`internal_split`） |
| §9 昇格コスト | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon（`graduation_cost`） |
| §5 意味の束 | （原本のみ。artifacts には持ち込まず症状で操作） |
| §6.6 決定表 | `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon の split/seam-cost cue（圧縮）；`CODING_STANDARDS.md` |
| §6.7 概念の高度 | `DESIGN_PHILOSOPHY.md` → Concept Altitude；`CODING_STANDARDS.md` → Concept Generality；`AI_WORKFLOW.md` → Pre-Implementation Scan #3 |
| §8 AND 精緻化 | `DESIGN_PHILOSOPHY.md` → SRP validation（Refined AND） |
| §13.1 誤読防止 | `DESIGN_PHILOSOPHY.md` → Common Misreadings to Prevent |
| §13.2 module 四義 | `AI_WORKFLOW.md` → Pre-Implementation Scan（module 解決） |
| §13.3 確認段階 | `AI_WORKFLOW.md` → Contract Confirmation Gate（L0–L3） |

> 注：`module` は artifacts では「主境界(primary boundary)」として既定値扱い。本書の §5 が示すとおり
> それは**既定値であって原理の床ではない**。artifacts がそこを定数のように書いている箇所は、
> 本書の動的地平線で上書き解釈する。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
