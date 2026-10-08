# Tests

このdirectoryは通常のdeterministic testと、Artifact v2を利用するexecution agent behavior testを所有する。

## Deterministic tests

| Test | Purpose |
|---|---|
| `test-artifacts.sh` | whole-pack sync / replace / remove / safety / advertised-route validity+reachability / remote-delivery bootstrap |
| `test-knowledge-integrity.sh` | knowledge・traceability・Artifact v2 structural integrity |
| `test-agent-harness.sh` | agent harness fixture/scenario/materialization integrity |

Run:

```bash
bash tests/test-artifacts.sh
bash tests/test-knowledge-integrity.sh
bash tests/test-agent-harness.sh
```

`test-artifacts.sh` は `tests/scripts/check-artifact-routes.sh` も実行する。runtime pack内でbacktick記法 (`` `path` ``) でadvertiseされる `.md` 参照は、containing fileのdirectoryからの相対pathとしてpack内に解決されなければならない — 未解決のrouteは `BROKEN`、INDEX.mdから推移的に到達不能なfileは `UNREACHABLE` としてfailする (対象: inline typo・inner-router orphan)。project-owned example token (`documents/...`・`docs-jp/...`・`AGENTS.md`/`CLAUDE.md`/`GEMINI.md`/`README.md`・directory参照・`<...>` placeholder・glob) はruntime edgeとして分類しない — 広範なignoreではなく明示分類。`#fragment` anchorは除去する (anchor自体の検証はしない、現在advertiseなし)。mechanical validityのみで、意味あるrouting・実read・理解を証明しない。現baseline: 98 advertised refs / 42 file全到達。

remote-delivery regressionはREADME記載のbootstrap commandをそのまま抽出し、test-local `git` shim (固定URLをfixture remoteへargv書き換え、user/global Git設定は不変) 経由で実行する (初回install・update/stale除去・fetch失敗・invalid source・temp cleanup・空白を含むtarget path・project-owned file非変更・`.git`/source knowledge非混入)。失敗系はcontent hash・owner file hash・target Git status/HEADを比較する。GitHub実取得はlive probeとして行い、egress不可の場合は成功と区別して報告する。

## AI behavior tests

```text
repositories/  = initial project fixtures
scenarios/     = agent task + evaluator-only expectations
scripts/       = run materialization / reset / inspection / evidence capture
results/       = raw report + machine evidence + run-level records (後から期待値に合わせて改変しない)
evaluations/   = evaluatorによるEXPECTATIONS照合・Artifact改善判断
runtime repo  = /tmp配下へgenerated; source repo外でblind evaluation
```

raw resultとevaluationは別directoryへ分離し、同じfileへ混ぜない。

`results/` 内はauthorshipごとに分離する。`REPORT.md` はagent-authored、`evidence/` はmachine-generated、`provenance.txt` はoperator-authored、`verification/` と `observed-reads.txt` はrun中に生産されたraw recordである。

```text
results/<scenario>/<run-id>/
├─ REPORT.md            = agent-authored raw testimony
├─ evidence/            = capture-agent-test.shが採取したmachine-generated run evidence
├─ provenance.txt       = operator-authored run context (任意)
├─ verification/        = run中に実行されたverification commandのraw output (任意)
└─ observed-reads.txt   = operator/toolが記録した実read観測 (任意)
```

`provenance.txt` はexact model・model version・reasoning effort・agent runtime・run時刻・entry condition・repetition・run set・read evidence source・known limitationsを記録し、model名やrun時期をrun-id命名規約から推測する必要をなくす。scenario・source SHA・fixture・baseline SHAはRUN_METADATAとevidence metadataが機械記録するためprovenanceへ重複して書かない。任意recordが無いrunはevidence metadataへ `not-provided` と記録され、後から補完しない。REPORT.mdのartifact read listは常にself-reported扱いとし、`observed-reads.txt` がある場合のみobserved evidenceとして区別する。これらのrecordを持たない旧runはその旨をlimitationとして扱い、後付けで存在を装わない。

旧runのflat file (`results/<scenario>/YYYY-MM-DD-<agent>.md`) はlegacy recordとして残す。存在しなかったmachine evidenceを後付け生成しない。

### Prepare

```bash
bash tests/scripts/prepare-agent-test.sh --scenario contract-boundary
```

### Execute

prepare scriptが表示したtemporary `repo/` をexecution agentのworking directoryにして、同じrun rootの `PROMPT.md` の本文だけをtaskとして渡す。prepare時点のsource HEAD / generated baselineは `RUN_METADATA.txt` に固定し、後続captureがその値をmachine evidenceへ引き継ぐ。prepareはrun rootへ `RUN_PROVENANCE.txt` templateも出力する — これはagent inputではなく、run operatorがcapture前に記入する。

run rootには任意で次のrun-level recordを置ける (いずれもgenerated `repo/` の外であり、agent task inputではない):

```text
RUN_PROVENANCE.txt    = operator-authored context。allowlist keyのみ:
                        model (provided時は必須) / model_version /
                        reasoning_effort / agent_runtime /
                        run_started_at_utc / run_finished_at_utc /
                        entry_condition / repetition / run_set /
                        read_evidence / known_limitations
verification/         = run中に実行したverification commandのraw output (flat regular fileのみ)
OBSERVED_READS.txt    = operator/toolが観測した実read record
```

**`tests/scenarios/<scenario>/EXPECTATIONS.md` は事前にagentへ見せない。**

### Capture

temporary runが消える前にmachine evidenceを採取する。

```bash
bash tests/scripts/capture-agent-test.sh --scenario contract-boundary --run-id 2026-09-25-devin
```

`tests/results/<scenario>/<run-id>/evidence/` へbundleを書き、agent-authored `REPORT.md` を同じ `<run-id>/` 配下へ記録する。run rootに `RUN_PROVENANCE.txt` (少なくとも1 pair・`model`必須・value≤500文字) / `verification/` / `OBSERVED_READS.txt` / `FILE_OPEN_EVENTS.jsonl` (observer header marker必須) が存在すれば、検証・file全体へのcontent-filter (comment含む)のうえ `<run-id>/provenance.txt`・`<run-id>/verification/`・`<run-id>/observed-reads.txt`・`<run-id>/file-open-events.jsonl` としてverbatim copyする。`file-open-events.jsonl` はinotify OPEN eventの記録でありread証跡ではなく、`observed-reads.txt`とは別名で区別する。header markerは形式検証のみで観測完全性の証明ではない — evaluatorは末尾 `stop` footerの `drained`/`incomplete`/`reasons` を確認する。captureは全destinationをwrite前にpreflightし、既存pathやdangling symlinkを拒否する。試行途中で失敗した場合はその試行が作成したpathのみrollbackされ (single-writer cleanup)、既存recordは保持されretryが可能。存在・非存在はevidence `metadata.txt` の `provenance` / `verification_output` / `observed_reads` / `file_open_events` fieldへ記録される。これらのrecordは `evidence/` 内部へ入れず、authorshipをmachine evidenceと分離する。

`changes.patch` はnon-ignored untracked fileも含める。ただしsecret-like path/contentを検出した場合は、evidenceを作成する前にfail closedする。ignored runtime stateは内容をarchiveせず、path/type/sizeの存在証跡だけを残す。

`evidence/worktrees.txt` は `git worktree list --porcelain` のregistrationと、run directory内へ解決されるworktreeに限った read-only inspect (HEAD / branch / clean-dirty / sparse-checkout状態とpatterns) を記録する。境界外のregistered worktreeは `inspected: no` + `skip_reason` で記録し、外部host pathを再帰inspectしない。旧bundleはworktree evidenceを持たないため、その旨はevaluation側でlimitationとして扱う。

`scenario.conf` が `EVIDENCE_REPOSITORIES="api=repo/components/api ..."` (selector=run-root-relative-path) を宣言する場合、`evidence/repositories/<selector>/` へ各独立Component Repositoryのevidence set (metadata/status/changed-files/diff-stat/changes.patch/filesystem/inspection) と `INDEX.txt` を追加する。prepare時にgeneric側でcomponent baseline tagを作成し`RUN_METADATA.txt`へselector/path/baseline SHAを記録する。captureはcomponent repoのreal index/worktreeを変更せず、component non-ignored untrackedにも同一のsecret fail-closed保護を適用する。

### Inspect

```bash
bash tests/scripts/inspect-agent-test.sh --scenario contract-boundary
```

その後evaluatorが `tests/scenarios/contract-boundary/EXPECTATIONS.md` と `REPORT.md` / captured evidenceを比較する。

### Cycle

1. prepare;
2. agent run;
3. machine evidenceを `capture-agent-test.sh` で採取 (run消失前);
4. agent-authored `REPORT.md` を `tests/results/<scenario>/<run-id>/` へ記録;
5. push / PR等でGitHubから取得可能にする;
6. evaluatorがEXPECTATIONS + REPORT + evidenceと照合;
7. evaluationを `tests/evaluations/<scenario>/` へ保存;
8. Artifact改善が必要ならIssue化;
9. execution agentが改善を実装;
10. evaluator review。resetは適切なタイミングで行う。

execution agentは原則 `main` へ直接commitせず、最新 `main` からwork branchを作り、commit → push → PR作成し、IssueをPR本文で参照する。final reportはPR bodyまたはIssue commentへ残す。reportのchatへのcopy/pasteは前提にしない。

### Reset

```bash
bash tests/scripts/reset-agent-test.sh --scenario contract-boundary
```

## Initial scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `contract-boundary` | minimal | small surface / strong contract + internal YAGNI |
| `brownfield-scope` | brownfield | task scopeを不必要なrefactorへ拡張しない |
| `local-rule-precedence` | structured | project-local rulesがgeneric artifactをspecializeできる |

## Second-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `failure-boundary` | failure-service | expected business failure / vendor failure translation / async boundary |
| `work-identity-confirmation` | work-planning | Work Identity提案とexplicit confirmation前のmaterialize禁止 |
| `destructive-cleanup` | cleanup-safety | disposable scope限定削除 / persistent・shared・host保全 |
| `documentation-routing` | documented-project | 既存INDEX経由のowner発見 / duplicate authority回避 |

## Third-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `worktree-materialization` | worktree-project | deterministic linked worktree materialization / nested `.worktrees/` 不発生 |

## Fourth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `docker-ci-parity` | docker-ci-project | Docker-first boundary / local・CI同一final verification / host Node npm非依存 |

## Fifth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `performance-contract-preservation` | performance-reporting | structural perf bound / public sync Array contract維持 / internal optimization判断 |

## Sixth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `provider-compatibility-gate` | provider-compatibility | additive≠compatible / provider側breaking判定 / 未授权breakingのgate停止 |

## Seventh-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `work-runtime-resource-scoping` | work-runtime-resources | per-resource scoping判断は成功 / lifecycle identity propagationにfollow-up必要 |

## Eighth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `work-runtime-lifecycle-propagation` | work-runtime-lifecycle | lifecycle全operationが同一Work-scoped resource setをresolve / teardownのdefault fallback排除 / scoped cleanupの限定性 |

## Ninth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `integration-head-revalidation` | integration-revalidation | feature branch green / clean mergeをdone扱いせずintegrated HEADを再verifyし、semantic mismatchをcurrent contractへadaptしてPASS |

## Tenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `diagnostics-before-recovery` | diagnostics-recovery | failureに対しobserve before mutate / failure layer特定 / Work-scoped stateのみrepair・shared/persistent保護 / broad resetの回避 |

## Eleventh-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `external-dependency-containment` | external-dependency-containment | vendor SDK更新時にvendor vocabularyをApplicationまで追従させない / Infrastructure edgeへのcontainment / 最小限のproject-owned capability・translation boundary / public behavior維持 |

## Twelfth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `multi-repo-workspace-ownership` | multi-repo-workspace | stable selectorでapi/webを解決 / Project・api・web各repoのownershipを保持して全参加repo更新 / coordinated verify PASS / per-repo machine evidence分離 |

## Thirteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `requested-outcome-verification` | requested-outcome-verification | unit contract greenとrequested outcomeを分離 / focused composition fix / enabled・disabled CLI outcomeを実測 / final project gate PASS |

## Fourteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `documentation-maintenance-reconciliation` | documentation-maintenance-reconciliation | completed Work Documentsの分類 (durable confirmed / rejected / scratch / verification log) / owner documentへ統合・temporary drop / closeout / archive suggestion拒否・Gitがhistory |

## Fifteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `state-ownership-consistency` | state-ownership-consistency | OrderStore/PaymentGatewayの独立ownership維持 / Application coordinatorがexplicit compensation / success・両failure invariant PASS / public contract維持 |

## Sixteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `brownfield-execution-adoption` | brownfield-execution-adoption | brownfield projectの段階移行 — test実行のみ既存Compose runtimeへ / public `make test`維持 / CIを同じstable commandへ収束 / build・deployのlegacy pathはscope外として維持 |

## Seventeenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `vcs-authority-and-reporting` | vcs-authority-and-reporting | project-local VCS authority — local `review/*` task commitはauthorized・push/main commit/remote mutationはunauthorized / external checkはmaintainer input不足でNOT RUNとしてPASSと分離してreport |

## Eighteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `responsibility-and-concept-altitude` | responsibility-and-concept-altitude | consumer-neutral `Money`へsemantic altitudeを上げつつcheckout-local配置維持 / shared hardeningなし / pricing policy分離 / public contract維持 |

## Nineteenth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `documentation-structural-migration` | documentation-structural-migration | canonical docのauthorized move/rename — incoming refs発見・INDEX/link修復・byte-for-byte本文維持・旧path消滅 / DOC_L2 moveはDOC_L3 model rebuildの権限ではない |

## Twentieth-stage scenarios — completed/evaluated

| Scenario | Fixture | Main observation |
|---|---|---|
| `project-root-execution-routing` | project-root-execution-routing | fresh isolated subjectがProject Root entryからArtifact root→WORKSPACE/COMMANDS_AND_CIへ到達、whole-pack preloadなし / root public command + literal `DIR` で独立Component Repositoryのみ64→128 / final Project state PASS |

## Discovery pilots — defined, awaiting evaluation

| Scenario | Fixture | Main observation |
|---|---|---|
| `project-entry-discovery` | documented-project-entry | promptにartifact pathを与えずproject-owned hook (AGENTS→documents/INDEX→artifacts/INDEX) のみでentry discoveryを観測 / output評価はdocumentation-routingと同一 / self-reported readsのみではdiscoveryはUNVERIFIED扱い (Issue #138) |
| `project-entry-required` | documented-project-required-entry | 同一task・同一promptのまま、project INDEXが変更前のroot参照を**required**とするvariant。conditional linkとの比較用 / outcome・reported route・observed routeは別々に採点 / telemetryなしのread主張はUNVERIFIED (Issue #140) |

## Projection-coverage scenarios — defined, awaiting evaluation

| Scenario | Fixture | Main observation |
|---|---|---|
| `separate-runtime-boundary` | separate-runtime-boundary | separate deployables間はpublished wire contract経由 / frontend→backend internals import禁止 (boundary guard `make verify`) / same-runtime CLI→Applicationは合法維持 / reported vs observed reads分離 (Issue #141) |
| `worktree-removal-preflight` | worktree-project | clean・registered・期待pathのworktreeが**別branch**にbindされている mismatch を検出してremoval前に停止するか (PASS=refusal) / force・branch削除禁止 (Issue #144) |
| `multi-repo-workspace-bootstrap` | multi-repo-bootstrap | component sources外部・component checkout未配置の状態からagent自身がprimary checkout containment + 全participating repositoryのWork worktree materializationを解決 / sibling配置・ad-hoc checkout・unregistered dirは不可 (Issue #191) |

Harness design: `documents/project/AGENT_ARTIFACT_TEST_HARNESS.md`
