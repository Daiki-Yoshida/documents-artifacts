# Source record: 2026-09-15-cross-artifact-consistency-issue

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/15"
source_created_at: "2026-09-15T21:27:21Z"
source_updated_at: "2026-09-15T21:42:53Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## Priority

**High / distributed canonical artifacts**

repo全体棚卸しで確認した `artifacts/` 配下の不整合をまとめて修正する。非配布docsのIssue #13 / #14より先に扱う。

## 1. documentation-strategy: `documents/artifacts/` managed subtree を明示する

現在のdistribution contractでは artifact は target project の

`documents/artifacts/<module>/`

へ同期される。一方 `documentation-strategy` は旧構造を前提に、top-level `artifacts/` を想定しつつ「documents/ 配下の全ファイルを documents/INDEX.md へ登録・version/hash管理する」と読める。

このままだと installed artifact 自身を target project-owned docs とみなし、`document_version` / `last_updated_commit` を付与・編集する誤運用を誘発する。

修正方針:
- `documents/artifacts/` を distributor-managed guidance subtree と定義
- AI-facingだが project-owned documentation ではない
- target `documents/INDEX.md` の project-doc inventory/version registry から除外
- installed artifact fileへ target project側の version/hash metadata を付与しない
- module内routingは各 `documents/artifacts/<module>/INDEX.md` が所有
- artifact更新は配布syncで行い、project documentation workflowから直接編集しない
- agent entry fileは必要に応じて project `documents/INDEX.md` と installed artifact INDEX の双方を参照できる

対象候補:
- `artifacts/documentation-strategy/DOCUMENTATION_PHILOSOPHY.md`
- `FILE_AND_STRUCTURE.md`
- `DOCUMENT_WORKFLOW.md`
- `INDEX.md`

## 2. documentation-strategy INDEX の scope が狭すぎる

`INDEX.md` は `scope: "documents/ only"` と要約しているが、ownerである `DOCUMENTATION_PHILOSOPHY.md` は docs-jp、agent entry files、README role、documentation commit/version tracking も管理対象としている。

INDEXのrouting summaryをowner本文へ一致させる。

## 3. commit hash workflow の `git commit --amend` 代替案を修正

`FILE_AND_STRUCTURE.md` のtwo-phase workflowに、commit後にそのhashを文書へ書き込み `git commit --amend` で最終化できるという代替案がある。

tracked contentをamendするとcommit hash自体が変わるため、自己hashを最終commit自身へ固定することはできない。

内部document version/hash機構自体は維持する。

修正方針:
- two-phase commitを正規手順として維持
- `last_updated_commit` は document content / reviewed code state が反映されたcommitを示す、と意味を明確化
- metadata記録commit自体を再帰的に追跡しない
- amendではself-referential hash問題を解決できないことを明記

## 4. design-principles PROJECT_STRUCTURE の runtime seam が旧 `additive evolution` 前提

`PROJECT_STRUCTURE.md` に runtime seam governance として `additive evolution + Contract Confirmation Gate` が残っている。

現在の正本では「additiveはchange shapeでありcompatibilityの証明ではない」。

修正方針:
- compatibility-governed evolutionへ変更
- caller/consumer + provider/implementer + relevant wire/schema等の互換性を見る
- additiveは互換性を保ちやすい手段であって判定基準ではない

## 5. PROJECT_STRUCTURE の `contract owns correctness` を contract conformance に修正

Contract Test配置説明に `the contract owns correctness; implementations conform` が残っている。

PR #10で確定した現在方針は:
- Contract Test = contract conformance
- User requirement / requested outcome satisfaction = separate verification

配置ルールの意味を `contract owns conformance` 相当に修正する。

## 6. CODING_STANDARDS の interface documentation example が DbException を漏らしている

同一文書のError Boundary Translationは raw `DbException` をApplication/Domain境界へ漏らすことを禁止しているが、Interface Documentation例は `Throws DbException if connection fails` と書いている。

AIが例を模倣すると規範に反するため、project-owned/business-meaningful errorまたはResultへ置き換える。

## 7. AI_WORKFLOW Step 2 が Contract の Constraints を落としている

現在:
`The Core Logic must satisfy the Shell's Contract (Signature + Semantics).`

正本定義:
`Contract = Signature + Semantics + Constraints`

Constraintsを含める。

## 8. DESIGN_PHILOSOPHY の formula が Constraints を side-effects だけに狭めて見える

現在:
`Contract = Signature (Type) + Semantics (Behavior) + Constraints (Side-effects)`

同じartifactではfailure/resource/determinism/dataもload-bearing contract constraintsとして扱っている。

Constraintsがside-effectsだけを意味すると誤読しない表現へ修正する。

## Validation

- [ ] 上記8点を正本内で修正
- [ ] `INDEX.md` Ownership Map / routing とowner本文が一致
- [ ] `documents/artifacts/` を target project-owned docs と誤認しない
- [ ] documentation-strategy内部のversion/hash方式は削除しない
- [ ] proposal #4 / Issue #11 のPerformance policyはこの修正に混ぜない
- [ ] explicit project conventions > generic artifacts の原則を維持
- [ ] proportionalityを維持
- [ ] `artifacts.sh` distribution semanticsは変更しない（別途不具合が見つからない限り）

## Versioning note

`documentation-strategy` は managed-subtreeという新しい重要ルールを追加するため、実装時に strategy version の **minor bump（2.3.0 → 2.4.0候補）** を検討する。
~~~~
