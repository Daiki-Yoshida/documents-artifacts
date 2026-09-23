# Design Philosophy — 旧18節の意味差分監査（第1巡）

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
baseline_legacy_commit: "e760eb38841650d60739750953c8342b639ce6f0"
legacy_file: "artifacts/design-principles/DESIGN_PHILOSOPHY.md"
legacy_h2_sections: 18
semantic_migration_complete: false
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
| Redefining "Object-Oriented" | **部分移行**。shell / internal freedomの原理はEHと接続するが、Rich/Lightweight Domain ModelやDI shellの具体は未移行 | code-design候補 | 詳細はlegacy L中心 |
| Core Philosophy: Bounded Contracts & Explicit Interfaces | **原理は移行済み**。contractはsignatureだけでなくsemantics/constraintsを含むことをEHが保持 | encapsulation-horizon | EH source + 1ea/1b1 commitで補強 |
| Boundaries Are Recursive | **移行済み** | encapsulation-horizon | EH旧原文とcurrent subjectにtraceabilityあり |
| Module — The Primary Boundary | **原理は移行済み**。module=default prior / floorではない。feature-first/layer-insideの具体は未移行 | EH + code-design候補 | EH source + 1b1等 |
| Module Shell vs Internal Implementation | **主要原理は移行済み**。boundary strict / interior flexibleとleakage channelをS001/S005が保持。DTO/dependency direction等はcode-design gap | EH + code-design候補 | EH source + 1ea/1b1 |
| Encapsulation Horizon | **移行済み**。current subjectの中心 | encapsulation-horizon | 旧日本語source +関連commit |
| Common Misreadings to Prevent | **大部分移行**。S008に誤読guardあり。ただしResult/Domain purity等の具体rule ownerは未整備 | EH + code-design候補 | 41f review commit、後続source |
| Responsibility-Driven Design | **原理は移行済み**。責務・AND・seam costはS002/S003/S006。code-specific anti-patternは未移行 | EH + code-design候補 | EH source、DP2 state ownership |
| Composition Over Inheritance | **未移行** | code-design候補 | baseline L中心。現行採否の第0情報源不足 |
| Reliability & Safety | **部分移行**。boundary safety / failure leakageの原理はEHに関連するが、constructor validation、type-driven state、RAII等のcode ruleは未移行 | code-design候補。destructive operationはdevelopment-safetyと別 | baseline L中心 |
| Appropriate Complexity | **部分移行**。YAGNIはhardening/concept altitudeで扱うが、一般的abstraction complexity規則は独立未移行 | code-design候補またはengineering-operation候補 | baseline L中心 |
| Concept Altitude | **移行済み＋後続修正済み**。one-sentence testをneutrality signalへ限定 | encapsulation-horizon | EH source + DP1→DP2 |
| External Dependency Containment | **原理の一部のみ**。leakage/ownershipに接続するが、wrap/allow/prohibitの具体規則は未移行 | code-design候補 | baseline L中心 |
| Domain Purity (Mechanism vs Concept) | **誤読guardのみ移行**。origin-based ownershipの詳細・例は未移行 | code-design候補 | EHに関連概念、詳細はL中心 |
| Internal Paradigm Agnosticism | **原理は概ね移行**。inside flexibleはEHに存在。module/file内consistent等の具体規則は未移行 | EH + code-design候補 | EH source / L |
| Design Priority Order | **未移行**。現在のsubject横断priorityとして正式ownerなし | engineering-operation候補またはcode-design判断原則 | baseline L中心 |
| Mistake Prevention Priority | **未移行**。一部個別ruleは存在するが5段ranking自体はcurrent authorityなし | engineering-operation候補 | baseline L中心 |
| Performance vs. Abstraction Policy | **source-backedだが完全移行前**。resource guaranteeはEH S005に接続。interaction shape redesignはcode-design候補 | EH + code-design候補 | DP1提案4→保留→PR #17で条件付き実装 |

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

## 3. Code Designへ回す候補

次はboundaryを決めた後のcode realizationであり、EHへ入れると主語が変わる。

- OOP shellの具体的DI / Domain Modelの使い分け
- feature-first / layer-insideのcode layout
- Composition Over Inheritance
- fail-fast / type-driven state
- External Dependency Containmentのwrap/allow/prohibit
- Domain Purityの具体配置
- internal paradigmの運用rule
- performance interaction shape

詳細は [LEGACY_DESIGN_SUBJECT_OWNERSHIP.md](LEGACY_DESIGN_SUBJECT_OWNERSHIP.md) と [LEGACY_CODE_DESIGN_GAP_AUDIT.md](LEGACY_CODE_DESIGN_GAP_AUDIT.md) で追跡する。

## 4. Engineering Operationへ回す候補

Design Priority Order / Mistake Prevention Priorityはcode structureの一個別規則ではなく、複数のdesign decisionをどう優先するかという横断判断である。

ただし現在はbaseline artifact以外の第0情報源が不足している。現在の正式priorityとして復活させず、[LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md](LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md) のsource recoveryと合わせて判断する。

## 5. 現時点のcoverage判断

旧 `DESIGN_PHILOSOPHY.md` 18 H2について:

- Encapsulation Horizonの原理として現在のsubjectへ意味が明確に引き継がれている節: Bounded Contracts / Recursive Boundaries / Module prior / Shell-vs-Interior / Encapsulation Horizon / Responsibility / Concept Altitudeを中心とする。
- 現行subjectに一部だけ存在し、code-level detailが不足する節: OOP reinterpretation / Misreadings / Reliability / Appropriate Complexity / External Dependency / Domain Purity / Internal Paradigm / Performance。
- 現在の正式ownerがなく、source回収が必要な節: Composition Over Inheritance / Design Priority / Mistake Preventionを中心とする。

この分類は節全体のPASS/FAILではなく、次のsource recovery優先順位を決めるための監査結果である。
