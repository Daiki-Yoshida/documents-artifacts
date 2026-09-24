# Legacy Artifact H2 Section Inventory (2026-09-24)

```yaml
document_type: "repository_local_migration_audit"
authority: "mechanical_inventory_not_semantic_coverage"
baseline_commit: "e760eb38841650d60739750953c8342b639ce6f0"
source_kind: "legacy_second_source_artifact_git_blob"
file_count: 14
h2_count: 129
inventory_unit: "H2見出し。H3・本文・条件・例外は別途人手でsemantic auditが必要"
current_semantic_classification: "129/129 H2 owner/history/replacement classified"
remaining_gaps: ["provenance", "optional_line_parity", "artifact_reprojection"]
```

## 読み方

旧artifact 14文書について、**基準commitに存在する全H2見出しと開始行**を機械抽出した一覧。H2の一致・数・関連subjectの推定は、原文を追跡できたことや現在の採用状態を証明しない。各項目の完了にはH3・本文の条件/例外/反論・後続recordの採否・現在のsubjectでの表現を突合する必要がある。

**現在のsemantic classificationは129 / 129 H2についてowner / intentional history / replacement decisionへの分類完了。** 下表の「未完了」「詳細突合待ち」は、このmechanical inventoryを作成した初回監査時点のworking statusをhistoricalに残したものであり、現在statusではない。現在判定は [LEGACY_ARTIFACT_COVERAGE_AUDIT.md](LEGACY_ARTIFACT_COVERAGE_AUDIT.md) と各gap auditを参照する。逐語一致・全provenance回収・artifact再projectionは別の残課題である。

- 正本の移行状況: [LEGACY_ARTIFACT_COVERAGE_AUDIT.md](LEGACY_ARTIFACT_COVERAGE_AUDIT.md)
- 旧再構成候補: [TRACEABILITY.md](semantic-preservation-candidate/TRACEABILITY.md)（当時の別モデルへのmapping。現行6 subjectのcoverage証明ではない）

## `artifacts/design-principles/AI_WORKFLOW.md`

- Git blob: `6e3e4caccedccb8a13cdc6638c7ad3819a9aef6e`
- H2: 8件
- 候補ルート: encapsulation-horizon / 未整理のcode-design・engineering-operation (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 10 | Core Thinking Process | 詳細突合待ち |
| 27 | Step 1: Define Boundaries & Contracts | 詳細突合待ち |
| 75 | Step 2: Implementation (The Shell & The Core Logic) | 詳細突合待ち |
| 90 | Step 3: Verification | 詳細突合待ち |
| 108 | Operational Discipline | 詳細突合待ち |
| 131 | Brownfield Policy (existing code that violates these standards) | 詳細突合待ち |
| 146 | Special Instructions | 詳細突合待ち |
| 156 | Worked Example (End-to-End) | 詳細突合待ち |

## `artifacts/design-principles/CODING_STANDARDS.md`

- Git blob: `5fd238fc44094a2ac1435792cfe2de5993801b2b`
- H2: 12件
- 候補ルート: encapsulation-horizon / 未整理のcode-design・engineering-operation (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 20 | Interface Design Rules | 詳細突合待ち |
| 113 | Contract Evolution & Versioning | 詳細突合待ち |
| 142 | Performance-Shaped Contracts | 詳細突合待ち |
| 179 | Architectural Boundaries (Layering) | 詳細突合待ち |
| 281 | External Dependency Boundary Policy | 詳細突合待ち |
| 315 | Domain Purity Rules | 詳細突合待ち |
| 338 | Dependency Injection (DI) | 詳細突合待ち |
| 368 | Error Handling Strategy | 詳細突合待ち |
| 419 | Concurrency & Async Contracts | 詳細突合待ち |
| 435 | Data Model & Internal Implementation | 詳細突合待ち |
| 493 | Mapping & Conversion Policy | 詳細突合待ち |
| 519 | Testing Strategy | 詳細突合待ち |

## `artifacts/design-principles/DESIGN_PHILOSOPHY.md`

- Git blob: `bb6103f87c5259b6b339f8a9497631044eedd011`
- H2: 18件
- 候補ルート: encapsulation-horizon / 未整理のcode-design・engineering-operation (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 12 | Redefining "Object-Oriented" | 詳細突合待ち |
| 34 | Core Philosophy: Bounded Contracts & Explicit Interfaces | 詳細突合待ち |
| 59 | Boundaries Are Recursive (Scale-Invariant) | 詳細突合待ち |
| 71 | Module — The Primary Boundary | 詳細突合待ち |
| 85 | Module Shell vs Internal Implementation | 詳細突合待ち |
| 102 | Encapsulation Horizon (the hardening line) | 詳細突合待ち |
| 125 | Common Misreadings to Prevent | 詳細突合待ち |
| 149 | Responsibility-Driven Design | 詳細突合待ち |
| 202 | Composition Over Inheritance | 詳細突合待ち |
| 230 | Reliability & Safety | 詳細突合待ち |
| 268 | Appropriate Complexity | 詳細突合待ち |
| 275 | Concept Altitude (YAGNI Bounds Mechanism, Not Meaning) | 詳細突合待ち |
| 291 | External Dependency Containment | 詳細突合待ち |
| 303 | Domain Purity (Mechanism vs Concept) | 詳細突合待ち |
| 315 | Internal Paradigm Agnosticism | 詳細突合待ち |
| 329 | Design Priority Order | 詳細突合待ち |
| 339 | Mistake Prevention Priority | 詳細突合待ち |
| 351 | Performance vs. Abstraction Policy | 詳細突合待ち |

## `artifacts/design-principles/INDEX.md`

- Git blob: `78b4e0586234ef67a9a880fba5168f6e1e84da3f`
- H2: 5件
- 候補ルート: encapsulation-horizon / 未整理のcode-design・engineering-operation (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 13 | Read Order | 詳細突合待ち |
| 24 | Document Split Policy | 詳細突合待ち |
| 34 | Foundational Lens | 詳細突合待ち |
| 46 | Ownership Map (Single Source of Truth) | 詳細突合待ち |
| 126 | Quick Task Routing | 詳細突合待ち |

## `artifacts/design-principles/PROJECT_STRUCTURE.md`

- Git blob: `4538ada096c5e8ad8b872ca347152715592469d6`
- H2: 5件
- 候補ルート: encapsulation-horizon / 未整理のcode-design・engineering-operation (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 29 | 1. Module Public Surface (default-internal) | 詳細突合待ち |
| 81 | 2. Shared Kernel & Cross-Cutting Placement | 詳細突合待ち |
| 104 | 3. Runtime Topology & Multi-Deployable Layout (frontend + backend) | 詳細突合待ち |
| 162 | 4. Test File Placement | 詳細突合待ち |
| 193 | How These Interlock | 詳細突合待ち |

## `artifacts/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`

- Git blob: `45d064572ac884ccb5afd8765387e4662e3a94f2`
- H2: 12件
- 候補ルート: workspace-structure / development-execution / development-safety / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 10 | Development Environment Contract | 詳細突合待ち |
| 26 | Priority Order | 詳細突合待ち |
| 42 | Control Plane and Execution Plane | 詳細突合待ち |
| 57 | Work Identity | 詳細突合待ち |
| 97 | Workspace Topology Concepts | 詳細突合待ち |
| 116 | Checkout Selection Rule | 詳細突合待ち |
| 137 | Parallel-Agent Isolation | 詳細突合待ち |
| 155 | Explicit Operations | 詳細突合待ち |
| 170 | Reproducibility | 詳細突合待ち |
| 185 | Safety Without Friction | 詳細突合待ち |
| 199 | Scope Boundary | 詳細突合待ち |
| 220 | Common Misreadings | 詳細突合待ち |

## `artifacts/development-environment-strategy/ENVIRONMENT_STANDARDS.md`

- Git blob: `90c8e33dd080f9bd18fe9115fc70e2e74937c0df`
- H2: 7件
- 候補ルート: workspace-structure / development-execution / development-safety / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 11 | 1. Host Dependency Boundary | 詳細突合待ち |
| 41 | 2. Docker Standards | 詳細突合待ち |
| 125 | 3. Command Interface | 詳細突合待ち |
| 236 | 4. Git Operation Safety | 詳細突合待ち |
| 267 | 5. Destructive Operations | 詳細突合待ち |
| 286 | 6. Diagnostics and Validation | 詳細突合待ち |
| 302 | 7. Local and CI Parity | 詳細突合待ち |

## `artifacts/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`

- Git blob: `fe05113a4cdc8e1166a9ac6ada60b49310250c60`
- H2: 8件
- 候補ルート: workspace-structure / development-execution / development-safety / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 11 | 1. New Project Setup | 詳細突合待ち |
| 72 | 2. Brownfield Adoption | 詳細突合待ち |
| 109 | 3. Work Identity Lifecycle | 詳細突合待ち |
| 261 | 4. Integration | 詳細突合待ち |
| 273 | 5. Work Completion and Cleanup | 詳細突合待ち |
| 339 | 6. Diagnosis and Recovery | 詳細突合待ち |
| 361 | 7. Environment Confirmation Gate | 詳細突合待ち |
| 385 | 8. Re-read Triggers | 詳細突合待ち |

## `artifacts/development-environment-strategy/INDEX.md`

- Git blob: `95c831e350559203577e95bb3925f144bb2bbcae`
- H2: 6件
- 候補ルート: workspace-structure / development-execution / development-safety / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 14 | Read Order | 詳細突合待ち |
| 25 | Foundational Lens | 詳細突合待ち |
| 37 | Worktree Selection Rule | 詳細突合待ち |
| 55 | Ownership Map | 詳細突合待ち |
| 104 | Quick Routing | 詳細突合待ち |
| 130 | Relationship to Sibling Artifact Sets | 詳細突合待ち |

## `artifacts/development-environment-strategy/WORKSPACE_STRUCTURE.md`

- Git blob: `b1ed4e30545321a1d19f4340386fe832d4d67479`
- H2: 11件
- 候補ルート: workspace-structure / development-execution / development-safety / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 11 | 1. Repository Topology | 詳細突合待ち |
| 51 | 2. Project Root and Primary Checkouts | 詳細突合待ち |
| 75 | 3. Work Root | 詳細突合待ち |
| 102 | 4. Uniform Single- and Multi-Repository Shape | 詳細突合待ち |
| 133 | 5. Work Documents Placement and Ownership | 詳細突合待ち |
| 151 | 6. Repository Worktrees and Identity | 詳細突合待ち |
| 251 | 7. Recommended Top-Level Layout | 詳細突合待ち |
| 272 | 8. Git Tracking and Materialization Boundaries | 詳細突合待ち |
| 354 | 9. Multi-Repository Coordination and Resource Identity | 詳細突合待ち |
| 381 | 10. Workspace-to-Component Tool Dependency | 詳細突合待ち |
| 400 | 11. Cross-Artifact Boundaries | 詳細突合待ち |

## `artifacts/documentation-strategy/DOCUMENTATION_PHILOSOPHY.md`

- Git blob: `0c00113e4cdf39f2e87027f6f4d4fd13a3b54486`
- H2: 10件
- 候補ルート: documentation / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 10 | Core Principle: Information Accuracy First | 詳細突合待ち |
| 33 | Scope: What This Strategy Governs | 詳細突合待ち |
| 84 | Work Documents: Active-Work Knowledge | 詳細突合待ち |
| 113 | AI-Facing by Default | 詳細突合待ち |
| 134 | Routing Over Truncation | 詳細突合待ち |
| 152 | Git as a Recording Tool | 詳細突合待ち |
| 172 | Single Source of Truth | 詳細突合待ち |
| 186 | Universality | 詳細突合待ち |
| 201 | Relationship to design-principles | 詳細突合待ち |
| 249 | Common Misreadings | 詳細突合待ち |

## `artifacts/documentation-strategy/DOCUMENT_WORKFLOW.md`

- Git blob: `e51e6570940ec21ac0bba419922bf62529f6e302`
- H2: 12件
- 候補ルート: documentation / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 20 | Use Cases | 詳細突合待ち |
| 33 | Use Case 1: New Project Setup | 詳細突合待ち |
| 124 | Use Case 2: Existing Project Adoption (Brownfield) | 詳細突合待ち |
| 192 | Use Case 3: Ongoing Document Updates | 詳細突合待ち |
| 241 | Use Case 4: Staleness Handling | 詳細突合待ち |
| 274 | Use Case 5: Managed Artifact Handling | 詳細突合待ち |
| 294 | Use Case 6: Work Documents | 詳細突合待ち |
| 339 | Version Bumping Workflow | 詳細突合待ち |
| 368 | Document Creation Decision Tree | 詳細突合待ち |
| 401 | Document Deletion Workflow | 詳細突合待ち |
| 425 | Re-read Triggers | 詳細突合待ち |
| 452 | Confirmation Gate | 詳細突合待ち |

## `artifacts/documentation-strategy/FILE_AND_STRUCTURE.md`

- Git blob: `ceeb4082b4584a2876a22394f53ab63c4cda181a`
- H2: 11件
- 候補ルート: documentation / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 21 | 1. Top-Level Directory Layout | 詳細突合待ち |
| 103 | 2. File Roles | 詳細突合待ち |
| 257 | 3. Cross-Reference and Routing Strategy | 詳細突合待ち |
| 284 | 4. Document Versioning System | 詳細突合待ち |
| 419 | 5. Git Commit Message Conventions | 詳細突合待ち |
| 462 | 6. File Format Standards | 詳細突合待ち |
| 476 | 7. Directory Splitting Guide | 詳細突合待ち |
| 510 | 8. Hierarchical Projects | 詳細突合待ち |
| 556 | 9. Document Deletion Rules | 詳細突合待ち |
| 573 | 10. Multi-Developer INDEX.md Conflict Mitigation | 詳細突合待ち |
| 590 | How These Interlock | 詳細突合待ち |

## `artifacts/documentation-strategy/INDEX.md`

- Git blob: `cb10d7d1932e28f1d98f6311786b5cf90051ee0b`
- H2: 4件
- 候補ルート: documentation / work-identity (候補)
- 初回監査時の意味保存判定: **未完了（historical）**

| 開始行 | 旧H2見出し（原文） | 初回監査status（historical） |
|---:|---|---|
| 13 | Read Order | 詳細突合待ち |
| 23 | Foundational Lens | 詳細突合待ち |
| 35 | Ownership Map (Single Source of Truth) | 詳細突合待ち |
| 86 | Quick Task Routing | 詳細突合待ち |

