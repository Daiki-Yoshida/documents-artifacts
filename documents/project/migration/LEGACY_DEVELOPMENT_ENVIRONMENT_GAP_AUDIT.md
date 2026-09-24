# Development Environment Strategy — legacy baseline 44 H2の意味差分監査

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
legacy_source_snapshot: "../../knowledge/records/2026-08-03-development-environment-final-source-snapshot/"
legacy_files: 5
independent_repository_h2_sections: 42
central_legacy_baseline_h2_sections: 44
semantic_migration_complete: false
```

## 結論

旧独立 `development-environment-strategy` repositoryの最終実質stateは5ファイル・42 H2。その後、中央repositoryでWork Identity / Worktree契約へ再構成され、監査baseline `e760eb38841650d60739750953c8342b639ce6f0` では **44 H2** になっている。現在は **44 / 44を現行knowledgeへ分類できる**。

ただし旧1moduleは現在、責務の主語に応じて次へ分割されている。

- `workspace-structure`: project / repository / filesystem / Git ownershipの静的構造
- `development-execution`: host/container、Docker、公開command、local/CI、導入
- `development-safety`: destructive operation、診断、復旧、integration、confirmation
- `work-identity`: Work / Work Root / Work Documents / resource ownership / worktree lifecycle

旧Task Worktree中心のcheckout modelは、そのまま現行規範ではない。2026-09-22のsubject split / workspace-work-identity alignment後は、**静的repository topologyとWork固有lifecycleを分離**し、Work Identityを基準に再構成している。

## Source integrity

最終実質状態は旧 `Daiki-Yoshida/development-environment-strategy` commit
`821497fad747042de48a3d7b523c4f295496dfb3`。

[final source snapshot](../../knowledge/records/2026-08-03-development-environment-final-source-snapshot/MANIFEST.md) の5ファイルは、旧repositoryの同commitにあるGit blob SHAと **5 / 5一致**を確認した。

中央統合後はPR #19〜#22でWork Identity、Worktree Materialization Contract、public command contract、reference validationが順次artifactへ追加された。旧repo final snapshotを改変せず、これらは後続source eventとして評価する。

後続評価・再編source:

- [initial PR #1](../../knowledge/records/2026-07-18-development-environment-initial-pr/RECORD.md)
- [task resource ownership PR #2](../../knowledge/records/2026-08-02-task-resource-ownership-pr/RECORD.md)
- [Docker resource reuse PR #3](../../knowledge/records/2026-08-03-docker-resource-reuse-pr/RECORD.md)
- [development-environment subject split](../../knowledge/records/2026-09-22-development-environment-subject-split/RECORD.md)
- [workspace / work-identity alignment](../../knowledge/records/2026-09-22-workspace-work-identity-alignment/RECORD.md)
- [six-subject cross audit fixes](../../knowledge/records/2026-09-22-six-subject-cross-audit-fixes/)
- [Work Identity artifactization PR #19](../../knowledge/records/2026-09-20-work-identity-artifactization-pr/RECORD.md)
- [Worktree Materialization PR #20](../../knowledge/records/2026-09-20-worktree-materialization-pr/RECORD.md)
- [Worktree command contract PR #21](../../knowledge/records/2026-09-20-worktree-command-contract-pr/RECORD.md)
- [Worktree reference validation PR #22](../../knowledge/records/2026-09-21-worktree-reference-validation-pr/RECORD.md)

## 1. DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md — 12 / 12（旧repo 11 + 中央追加1）

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| Development Environment Contract | 現行。environmentを再現可能なcontractとして扱う | development-execution/S001 |
| Priority Order | 現行。安全性・再現性・明示性等の優先関係をsafety側へ整理 | development-safety/S001 |
| Control Plane and Execution Plane | 現行。host側制御とcontainer側実行を分離 | development-execution/S001 |
| Work Identity | 中央PR #19で追加。具体的development goalのsemantic identity / ownership / lifecycleを定義 | work-identity/S001〜S004 |
| Workspace Topology Concepts | **分割移管**。静的repository topologyはworkspace-structure、Work固有構造はwork-identity | workspace-structure + work-identity |
| Checkout Selection Rule | **旧Task Worktree modelを置換**。Primary Checkoutは静的基準、Workごとのcheckout/worktree選択はWork Identity / project policy | workspace-structure + work-identity history/current |
| Parallel-Agent Isolation | 現行思想をWork Identityへ再構成。全Workへworktreeを強制せず、必要なisolationだけmaterialize | work-identity |
| Explicit Operations | 現行。公開command / operationを明示 | development-execution/S003 |
| Reproducibility | 現行 | development-execution/S001 |
| Safety Without Friction | 現行 | development-safety/S001 |
| Scope Boundary | 旧umbrella moduleの範囲説明としてhistory。現在は4 subjectへ責務分割 | development-execution/S005 +各INDEX |
| Common Misreadings | 旧model固有の誤読guardをhistoryに保存 | development-execution/S005 / work-identity/S008 |

## 2. ENVIRONMENT_STANDARDS.md — 7 / 7

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| 1. Host Dependency Boundary | 現行 | development-execution/S002 |
| 2. Docker Standards | 現行。2026-08-03のresource reuse修正も反映 | development-execution/S002 + work-identity/S004 |
| 3. Command Interface | 現行 | development-execution/S003 |
| 4. Git Operation Safety | 責務分離。repository identity / worktree lifecycleはwork-identity、破壊性はdevelopment-safety | work-identity + development-safety |
| 5. Destructive Operations | 現行 | development-safety/S002 |
| 6. Diagnostics and Validation | 現行 | development-safety/S003 |
| 7. Local and CI Parity | 現行 | development-execution/S003 |

### Docker resource ownershipの後続整理

旧final sourceにはPR #2 / #3まで反映済み。

現在はさらに次へ分ける。

- **resource scope / ownership / lifecycle**: `work-identity/S004_LIFECYCLE_AND_RESOURCES.md`
- **container / network / volume等へのmaterialization・reuse**: `development-execution/S002_HOST_AND_CONTAINER.md`
- **cleanup時の破壊性・confirmation**: `development-safety/S002_DESTRUCTIVE_OPERATIONS.md`

この分離により「Workがあるから専用Docker resourceを作る」という誤読を避け、shared resourceを安全にreuseする規則を維持している。

## 3. ENVIRONMENT_WORKFLOW.md — 8 / 8

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| 1. New Project Setup | 現行 | development-execution/S004 |
| 2. Brownfield Adoption | 現行 | development-execution/S004 |
| 3. Checkout Selection and Optional Task Worktree Lifecycle | **旧Task Worktree workflowとしてhistoryへ移し、Work Identity lifecycleへ置換** | work-identity/S001〜S006 + S008_HISTORY |
| 4. Integration | 現行。integration operationの安全条件 | development-safety/S004 |
| 5. Cleanup | 責務分離。resource lifecycleはwork-identity、destructive cleanupはdevelopment-safety | work-identity/S004 + development-safety/S002 |
| 6. Diagnosis and Recovery | 現行 | development-safety/S003 |
| 7. Environment Confirmation Gate | 現行。Safety Levelへ再整理 | development-safety/S005 |
| 8. Re-read Triggers | 現行 | development-safety/S005 |

## 4. INDEX.md — 6 / 6

| 旧H2 | 現在の扱い |
|---|---|
| Read Order | 旧5-file packagingのrouting。現在はsubjects/INDEXと各subject INDEXへ置換 |
| Foundational Lens | 旧umbrella要約。各責務を4 subjectへ分配 |
| Absolute Worktree Selection Rule | **旧model**。現行はWork Identity / project policyにより必要なworktreeだけmaterialize |
| Ownership Map | 旧5 artifact fileのownership map。現行4 subjectへのmigration資料としてhistory扱い |
| Quick Task Routing | 現在は各subject INDEXへrouting |
| Relationship to Sibling Artifact Sets | 旧artifact packaging関係としてhistory。現在はsubject responsibilityで分離 |

## 5. WORKSPACE_STRUCTURE.md — 11 / 11（旧repo 10 → 中央でWork Identity中心に再構成）

中央legacy baselineでは、旧repo finalのPrimary Checkout / Task Worktree中心の10 H2をそのまま維持せず、PR #19〜#22で11 H2へ再構成した。

| 中央legacy baseline H2 | 現在の扱い | 現行owner |
|---|---|---|
| 1. Repository Topology | Project / Workspace / Component Repository等の静的topology | workspace-structure/S001 |
| 2. Project Root and Primary Checkouts | Project Rootとstable Primary Checkoutの静的役割 | workspace-structure/S001 |
| 3. Work Root | Work固有のdynamic root | work-identity/S002 |
| 4. Uniform Single- and Multi-Repository Shape | stable repository identityはworkspace、Work Root内mappingはwork-identity | workspace-structure + work-identity/S002 |
| 5. Work Documents Placement and Ownership | Work Documentsのplacement / Git ownership / lifecycle | work-identity/S003 |
| 6. Repository Worktrees and Identity | Work-specific branch/worktree identity・materialization | work-identity/S002/S005/S006 |
| 7. Recommended Top-Level Layout | 静的layoutをprojectへ適応可能な形で保持 | workspace-structure/S001 |
| 8. Git Tracking and Materialization Boundaries | Project-level Git ownershipはworkspace、Work Documents / recursive worktree materializationはwork-identity | workspace-structure/S002 + work-identity/S003/S005 |
| 9. Multi-Repository Coordination and Resource Identity | repository topologyはworkspace、Work/resource lifecycleはwork-identity | workspace-structure/S002 + work-identity/S004 |
| 10. Workspace-to-Component Tool Dependency | workspace tool dependency | workspace-structure/S002 |
| 11. Cross-Artifact Boundaries | 旧artifact分類としてhistory。現在はsubject responsibility / routingへ置換 | workspace-structure/S003_HISTORY + subjects/INDEX |

旧repo finalの `Task Worktrees` 等は履歴として残すが、current ruleへ戻さない。中央PR #19でWork Identityへ置換され、PR #20〜#22でmaterialization / command / validation contractが追加された。

## 6. 現行4 subjectの責務境界

### workspace-structure

**静的なProject / Repository / filesystem / Git ownership**を扱う。

- stable repository identity
- Project Root / Primary Checkout
- Project vs Component Repository
- top-level placement
- Git tracking boundary
- multi-repository topology
- workspace tool dependency

### development-execution

**開発処理をどのenvironment / runtime / public commandで実行するか**を扱う。

- host vs container
- Docker-first
- resource materialization / safe reuse
- public command
- local / CI parity
- new / brownfield adoption

### development-safety

**operationのrisk・destructive boundary・diagnosis・recovery**を扱う。

- destructive operation
- diagnostics
- recovery
- integration safety
- confirmation level
- reread trigger

### work-identity

**1つのWorkのidentity / lifecycle / resources / optional worktree**を扱う。

- Work Root
- Work Documents
- repository selector
- branch / worktree materialization
- Project / Work / Run resource ownership
- resource identity propagation
- completion / cleanup lifecycle

## 7. 残るgap

H2単位のowner不在は今回確認していない。一方、次はsemantic parity監査を継続する。

1. final英語sourceのH3 / YAML rule / exceptionが4 subjectへ正しく移されたか。
2. 2026-07-18日本語snapshotから2026-08-03 final sourceまでの差分、特にresource ownership / Docker reuse。
3. 旧Task Worktree semanticsのうち、Work Identity導入後も残すべき一般原則と、完全にhistoricalな操作規則の分離。
4. `workspace-structure` と `work-identity` のstatic / dynamic境界が各本文で重複定義されていないか。
5. cleanup / integration / Git operation safetyがdevelopment-safetyとwork-identity間で二重authority化していないか。

従って中央legacy baselineでは **44 / 44 H2 classified**。旧独立repository由来42 H2と、中央でのWork Identity再構成によるnet +2 H2を区別して追跡する。ただしdevelopment-environment-strategy全体を逐語的semantic migration PASSとはまだ宣言しない。


## 7.1 中央repository移行後のnet +2 H2

全体inventory 129 H2と旧repo final 42 H2の差は、中央統合後のWork Identity再構成で生じた。

- `DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`: **Work Identity** をPR #19で追加し、11 → 12 H2。
- `WORKSPACE_STRUCTURE.md`: 旧10 H2をWork Identity中心に再構成し、中央baselineでは11 H2。単なる1節追加ではなく、Primary Checkout / Task Worktree中心の旧heading群をProject Root / Work Root / Work Documents / repository worktree / resource identityへ置換した。
- `ENVIRONMENT_WORKFLOW.md` と `INDEX.md` はH2数は同じだが、Work Identity modelに合わせてheading / semanticsを置換した。

このため全体は42 + net2 = **44 H2**。後続sourceはPR #19〜#22のrecordで追跡し、旧repo final snapshotへ遡及編集しない。

## 8. H3 / detail監査（2026-09-24）

final英語snapshotのH3・YAML ruleと、導入・変更commit patchを突合した。

### 追加取得したGit source

- [Environment Standards初出](../../knowledge/records/2026-07-18-environment-standards-origin-commit/RECORD.md)
- [Workspace Structure初出](../../knowledge/records/2026-07-18-workspace-structure-origin-commit/RECORD.md)
- [Environment Workflow初出](../../knowledge/records/2026-07-18-environment-workflow-origin-commit/RECORD.md)
- [optional worktree policy](../../knowledge/records/2026-07-19-optional-worktree-policy-commit/RECORD.md)
- [task resource reconciliation](../../knowledge/records/2026-08-02-task-resource-reconciliation-commit/RECORD.md)
- [Docker reuse PR](../../knowledge/records/2026-08-03-docker-resource-reuse-pr/RECORD.md)

### H3 detailの現行owner確認

| 旧detail | 現行owner | 判定 |
|---|---|---|
| Docker-first / host dependency exceptions | development-execution/S002 | 保持 |
| resource identity / narrow isolation | work-identity/S004 + development-execution/S002 | 責務分離して保持 |
| bind mount file ownership | development-execution/S002 | 保持 |
| cache / volume reuse | development-execution/S002 | 保持 |
| host port collision / allocation | development-execution + work-identity | 保持 |
| secretをimage/repo/logへ漏らさない | development-execution/S002 + safety diagnostics | 保持 |
| Make/public command / target semantics | development-execution/S003 | 保持 |
| canonical final validation / local-CI parity | development-execution/S003/S004 | 保持 |
| optional worktree | work-identity + execution adoption | 後続policyに合わせて保持 |
| destructive cleanup | development-safety/S002 | 保持 |
| diagnosis / recovery | development-safety/S003 | 保持 |
| task-scoped resource end responsibility | work-identity/S004 | **今回補強** |

### resource reconciliationの補強

2026-08-02 sourceは、task-scoped resourceを作成した場合にWork終了時の状態を次へ分類する。

- removed
- concrete follow-upのためintentionally retained + reason reported
- unexplained residual resourceはcompletion stateとして不可

現行Work Identityは「resources reconciled / cleaned」とだけ書いており、この強い条件が薄かった。S004へ**removed / intentionally_retained / invalid residual**の完了条件を追加し、destructive deletionそのものはdevelopment-safetyへ委ねた。

### worktree modelの後続変更

2026-07-18初版はTask Worktreeを通常flowとして強く扱ったが、2026-07-19 commitで「worktree supportはcapabilityでありper-task mandatoryではない」へ明示修正された。

現在のWork Identityはさらに、Task identityではなくWork identityとoptional materializationとして一般化している。したがって初版の「Primary Checkoutはfeature workに使わない」「taskごとにworktree作成」はcurrent ruleへ戻さない。

## 9. Development Environment側の現在判定

旧42 H2に加え主要H3 detailを確認した範囲では、静的topology / execution / safety / Work lifecycleの4 ownerへ合理的に分離できている。

残る主なsemantic riskは、同一ruleを複数subjectが独立authorityとして再定義すること。特にresource identity、cleanup、integration、checkout selectionは、主ownerを次のように維持する。

- identity / lifecycle → work-identity
- runtime materialization / reuse → development-execution
- destructive action safety → development-safety
- static repository/filesystem ownership → workspace-structure
- general task authority / scope / brownfield discipline → engineering-operation


## 10. 8 subject横断のbrownfield authority確認

`development-execution/S004_ADOPTION_AND_MIGRATION.md` に残っていた「project-local rule優先」「scope外違反をついでに全面修正しない」は、実行環境固有の規則ではなく一般的engineering change disciplineである。

8 subject化後は次へ整理した。

- local convention / task scope / surrounding violation → `engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md` / `S007_BROWNFIELD_AND_APPROACH.md`
- existing build/test/deploy pathを段階移行し、environment状態を黙って破壊しない → `development-execution/S004_ADOPTION_AND_MIGRATION.md`
- destructive cleanup → `development-safety/`
- branch/worktree/resource lifecycle → `work-identity/`

これにより、brownfieldという同じ語を複数subjectが使っていても、一般scope disciplineとenvironment migration disciplineを二重authorityとして定義しない。
