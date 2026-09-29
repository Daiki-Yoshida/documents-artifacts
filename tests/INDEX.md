# Tests

このdirectoryは通常のdeterministic testと、Artifact v2を利用するexecution agent behavior testを所有する。

## Deterministic tests

| Test | Purpose |
|---|---|
| `test-artifacts.sh` | whole-pack sync / replace / remove / safety |
| `test-knowledge-integrity.sh` | knowledge・traceability・Artifact v2 structural integrity |
| `test-agent-harness.sh` | agent harness fixture/scenario/materialization integrity |

Run:

```bash
bash tests/test-artifacts.sh
bash tests/test-knowledge-integrity.sh
bash tests/test-agent-harness.sh
```

## AI behavior tests

```text
repositories/  = initial project fixtures
scenarios/     = agent task + evaluator-only expectations
scripts/       = run materialization / reset / inspection / evidence capture
results/       = raw report + machine evidence (後から期待値に合わせて改変しない)
evaluations/   = evaluatorによるEXPECTATIONS照合・Artifact改善判断
runtime repo  = /tmp配下へgenerated; source repo外でblind evaluation
```

raw resultとevaluationは別directoryへ分離し、同じfileへ混ぜない。

`results/` 内はagent-authored reportとmachine-generated evidenceを分離する。

```text
results/<scenario>/<run-id>/
├─ REPORT.md    = agent-authored raw testimony
└─ evidence/    = capture-agent-test.shが採取したmachine-generated run evidence
```

旧runのflat file (`results/<scenario>/YYYY-MM-DD-<agent>.md`) はlegacy recordとして残す。存在しなかったmachine evidenceを後付け生成しない。

### Prepare

```bash
bash tests/scripts/prepare-agent-test.sh --scenario contract-boundary
```

### Execute

prepare scriptが表示したtemporary `repo/` をexecution agentのworking directoryにして、同じrun rootの `PROMPT.md` の本文だけをtaskとして渡す。prepare時点のsource HEAD / generated baselineは `RUN_METADATA.txt` に固定し、後続captureがその値をmachine evidenceへ引き継ぐ。

**`tests/scenarios/<scenario>/EXPECTATIONS.md` は事前にagentへ見せない。**

### Capture

temporary runが消える前にmachine evidenceを採取する。

```bash
bash tests/scripts/capture-agent-test.sh --scenario contract-boundary --run-id 2026-09-25-devin
```

`tests/results/<scenario>/<run-id>/evidence/` へbundleを書き、agent-authored `REPORT.md` を同じ `<run-id>/` 配下へ記録する。

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

## Nineteenth-stage scenarios — definition ready / run pending

| Scenario | Fixture | Main observation |
|---|---|---|
| `documentation-structural-migration` | documentation-structural-migration | canonical docのauthorized move/rename — incoming refs発見・INDEX/link修復・byte-for-byte本文維持・旧path消滅 / DOC_L2 moveはDOC_L3 model rebuildの権限ではない |

Harness design: `documents/project/AGENT_ARTIFACT_TEST_HARNESS.md`
