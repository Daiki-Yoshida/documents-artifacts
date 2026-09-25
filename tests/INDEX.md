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

## Third-stage scenarios — definitions ready / runs pending

定義・fixtureのみ整備済み。run / evaluationは未実施。

| Scenario | Fixture | Main observation |
|---|---|---|
| `worktree-materialization` | worktree-project | deterministic linked worktree materialization / nested `.worktrees/` 不発生 |

Harness design: `documents/project/AGENT_ARTIFACT_TEST_HARNESS.md`
