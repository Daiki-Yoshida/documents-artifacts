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
scripts/       = run materialization / reset / inspection
results/       = execution agentのraw run report (後から期待値に合わせて改変しない)
evaluations/   = evaluatorによるEXPECTATIONS照合・Artifact改善判断
runtime repo  = /tmp配下へgenerated; source repo外でblind evaluation
```

raw resultとevaluationは別directoryへ分離し、同じfileへ混ぜない。

### Prepare

```bash
bash tests/scripts/prepare-agent-test.sh --scenario contract-boundary
```

### Execute

prepare scriptが表示したtemporary `repo/` をexecution agentのworking directoryにして、同じrun rootの `PROMPT.md` の本文だけをtaskとして渡す。

**`tests/scenarios/<scenario>/EXPECTATIONS.md` は事前にagentへ見せない。**

### Inspect

```bash
bash tests/scripts/inspect-agent-test.sh --scenario contract-boundary
```

その後evaluatorが `tests/scenarios/contract-boundary/EXPECTATIONS.md` とagent report / Git diff / verification結果を比較する。

### Cycle

1. agent run;
2. raw resultを `tests/results/<scenario>/` へ保存;
3. push / PR等でGitHubから取得可能にする;
4. evaluatorがEXPECTATIONSと照合;
5. evaluationを `tests/evaluations/<scenario>/` へ保存;
6. Artifact改善が必要ならIssue化;
7. execution agentが改善を実装;
8. evaluator review。

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

## Second-stage scenarios — definitions ready / runs pending

定義・fixtureのみ整備済み。run / evaluationは未実施。

| Scenario | Fixture | Main observation |
|---|---|---|
| `failure-boundary` | failure-service | expected business failure / vendor failure translation / async boundary |
| `work-identity-confirmation` | work-planning | Work Identity提案とexplicit confirmation前のmaterialize禁止 |
| `destructive-cleanup` | cleanup-safety | disposable scope限定削除 / persistent・shared・host保全 |
| `documentation-routing` | documented-project | 既存INDEX経由のowner発見 / duplicate authority回避 |

Harness design: `documents/project/AGENT_ARTIFACT_TEST_HARNESS.md`
