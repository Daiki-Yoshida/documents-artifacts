# Design Philosophy — 旧18節の意味差分監査（第1巡）

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
baseline_legacy_commit: "e760eb38841650d60739750953c8342b639ce6f0"
legacy_file: "artifacts/design-principles/DESIGN_PHILOSOPHY.md"
legacy_h2_sections: 18
semantic_migration_complete: "current owner/normative core established; exhaustive line-by-line parity not claimed"
```

## 位置付け

旧 `DESIGN_PHILOSOPHY.md` は、Encapsulation Horizonの原理だけでなく、OOPの解釈、composition、fail-fast、type-driven state、external dependency、domain purity、design priority、performance等を含む。

現行 `encapsulation-horizon` は旧日本語原文のEncapsulation Horizon 17 H2を責務別に再編しているが、旧 `DESIGN_PHILOSOPHY.md` 全体がそのsubjectへ移行済みという意味ではない。

## 取得済みの追加source

- [Encapsulation Horizon artifact反映commit](../../knowledge/records/2026-06-21-encapsulation-horizon-artifact-commit/RECORD.md): 旧日本語原本の思想をartifactへ符号化し、moduleをfloorではなくdefault horizonとして扱ったことを確認。
- [原本照合commit](../../knowledge/records/2026-06-21-encapsulation-source-alignment-commit/RECORD.md): resource/determinism等のcontract semantics、outer surface維持、graduation costを旧原本に照らして補完したことを確認。
- [探索方向commit](../../knowledge/records/2026-06-22-horizon-search-direction-commit/RECORD.md): macro→micro、public surface hardening、module=priorに関する後続反映を確認。
- [review運用版commit](../../knowledge/records/2026-06-22-design-review-guard-commit/RECORD.md): misreading guard / refined AND / coordinate≠own等のレビュー反映。
- [旧Issue #1](../../knowledge/records/2026-09-06-design-principles-proposals/RECORD.md) → [中央PR #10](../../knowledge/records/2026-09-15-design-principles-contract-decision/RECORD.md): semantic identity、state ownership等の後続修正採用。
- [performance PR #17](../../knowledge/records/2026-09-20-performance-contract-evolution/RECORD.md): load-bearing performance requirementに基づく後続改訂。

## 1. 18 H2の差分

| 旧節 | 現行knowledgeでの状態 | 主なowner / gap | source状態 |
|---|---|---|---|
| Redefining "Object-Oriented" | **移行済み**。boundary-oriented shell / internal freedomはEHとcode-design/S001-S002へ、Rich/Lightweight Domain ModelとDIはS006-S007へ整理 | code-design + EH | 2026-01-31 source snapshots + 2026-06-13 reference + final snapshot |
| Core Philosophy: Bounded Contracts & Explicit Interfaces | **原理は移行済み**。contractはsignatureだけでなくsemantics/constraintsを含むことをEHが保持 | encapsulation-horizon | EH source + 1ea/1b1 commitで補強 |
| Boundaries Are Recursive | **移行済み** | encapsulation-horizon | EH旧原文とcurrent subjectにtraceabilityあり |
| Module — The Primary Boundary | **移行済み**。module=default prior / floorではない原理はEH、feature-first / layer-insideのcode realizationはcode-design/S005へ整理 | EH + code-design | EH source + recovered code-design source snapshots |
| Module Shell vs Internal Implementation | **主要原理は移行済み**。boundary strict / interior flexibleとleakage channelをS001/S005が保持。DTO/dependency direction等はcode-design gap | EH + code-design | EH source + 1ea/1b1 |
| Encapsulation Horizon | **移行済み**。current subjectの中心 | encapsulation-horizon | 旧日本語source +関連commit |
| Common Misreadings to Prevent | **大部分移行**。S008に誤読guardあり。ただしResult/Domain purity等の具体rule ownerは未整備 | EH + code-design | 41f review commit、後続source |
| Responsibility-Driven Design | **移行済み**。責務・AND・seam costはEH、state ownership / realization detailはcode-design/S004-S005へ整理 | EH + code-design | EH source + DP2 state ownership + source snapshots |
| Composition Over Inheritance | **移行済み**。inheritanceの意味・許容境界をS003、composition preferenceをS006へ整理 | code-design | 2026-06-13 PROGRAMMING_PARADIGM snapshot + final source |
| Reliability & Safety | **主要code ruleは移行済み**。side-effect containment / state ownership / failure semanticsをcode-designへ整理。destructive operation safetyはdevelopment-safetyが別所有 | code-design + development-safety | recovered code-design source snapshots + current owner split |
| Appropriate Complexity | **移行済み**。YAGNIのhardening / placement側はEH、不要なabstractionを避けるdesign判断はcode-design/S012のpriorityへ接続 | EH + code-design | final source + current design priority |
| Concept Altitude | **移行済み＋後続修正済み**。one-sentence testをneutrality signalへ限定 | encapsulation-horizon | EH source + DP1→DP2 |
| External Dependency Containment | **移行済み**。wrap / allow / prohibitとdependency directionをcode-design/S006へ整理 | code-design | dependency-boundary / final source snapshots |
| Domain Purity (Mechanism vs Concept) | **移行済み**。origin-based ownershipとmapping境界をcode-design/S007へ整理 | code-design | domain-model / final source snapshots |
| Internal Paradigm Agnosticism | **移行済み**。inside flexibleの境界原理はEH、code-level implementation freedomはcode-design/S002へ整理 | EH + code-design | EH source + recovered snapshots |
| Design Priority Order | **移行済み**。code design decisionのconflict priorityとしてcode-design/S012が所有 | code-design | PROGRAMMING_PARADIGM §8–9 + final source |
| Mistake Prevention Priority | **移行済み**。後続のfailure / compatibility semanticsへ合わせてcode-design/S012へ整理 | code-design | final DESIGN_PHILOSOPHY + S008/S010後続decision |
| Performance vs. Abstraction Policy | **source-backedだが完全移行前**。resource guaranteeはEH S005に接続。interaction shape redesignはcode-design | EH + code-design | DP1提案4→保留→PR #17で条件付き実装 |

## 2. Encapsulation Horizonへ残すもの

次は現行subjectの主語と一致する。

- Bounded Contractの境界原理
- recursive boundary
- hardening horizon / module=prior
- responsibility / seam cost / maturity
- boundary completenessとleakage channels
- Concept Altitude / semantic identity
- outer surfaceを保ったgraduation
- contract changeのimpact/confirmation

これらは「どこを硬化し、何をcaller-visible guaranteeとして閉じるか」という一つの問いで説明できる。

## 3. Code Designへ移した／今後移す知識

次はboundaryを決めた後のcode realizationであり、EHへ入れると主語が変わる。回収済みreferenceで裏付けられる内部paradigm・inheritance・design priority等は `code-design` 初期subjectへ移行した。詳細sourceが不足する項目は未昇格。

- OOP shellの具体的DI / Domain Modelの使い分け
- feature-first / layer-insideのcode layout
- Composition Over Inheritance
- fail-fast / type-driven state
- External Dependency Containmentのwrap/allow/prohibit
- Domain Purityの具体配置
- internal paradigmの運用rule
- performance interaction shape

詳細は [LEGACY_DESIGN_SUBJECT_OWNERSHIP.md](LEGACY_DESIGN_SUBJECT_OWNERSHIP.md) と [LEGACY_CODE_DESIGN_GAP_AUDIT.md](LEGACY_CODE_DESIGN_GAP_AUDIT.md) で追跡する。

## 4. Engineering Operation / Code Designへの現在の割当

Design Priority Order / Mistake Prevention Priorityは、回収したPROGRAMMING_PARADIGM referenceとfinal DESIGN_PHILOSOPHYを根拠に `code-design/S012_DESIGN_PRIORITY.md` へ移行した。task scope / VCS / reporting等の作業規律は `engineering-operation/` が別所有する。

## 5. 現在のcoverage判断

旧 `DESIGN_PHILOSOPHY.md` 18 H2は、現在の8 subject上でowner / history / replacementを説明できる状態にある。

- Bounded Contracts / Recursive Boundaries / Module prior / Shell-vs-Interior / Encapsulation Horizon / Responsibility / Concept Altitude → 主に `encapsulation-horizon`
- OOP reinterpretation / Composition-Inheritance boundary / side-effect-state / External Dependency / Domain Purity / Internal Paradigm / Design Priority / Mistake Prevention / performance interaction → 主に `code-design`
- task進行上のscope / verification / VCS / reporting → `engineering-operation`
- destructive operation safety → `development-safety`

旧sourceと現行subjectが逐語一致することは要求しない。後続sourceで訂正されたsemantic identity / compatibility / performance等は後続decisionを優先する。元sourceを取得できないlegacy-only細則はprovenance gapとして残し、現在採用済みと偽らない。
