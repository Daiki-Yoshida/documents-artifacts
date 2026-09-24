# Agent Artifact Test Harness

```yaml
document_type: "repository_local_test_architecture"
status: "initial"
date: "2026-09-24"
target: "Artifact v2 AI consumption / routing behavior"
```

## Goal

Artifact v2はshell distributionだけでなく、**target project上のAIがroot routerから必要なknowledgeだけを読み、期待する設計・scope・safety判断へ到達できるか**を検証する。

このtest harnessはArtifact knowledge自体のauthorityではない。repository-localな検証設備である。

## Layout

```text
tests/
├─ INDEX.md
├─ test-artifacts.sh
├─ test-knowledge-integrity.sh
├─ test-agent-harness.sh
├─ scripts/
│  ├─ prepare-agent-test.sh
│  ├─ reset-agent-test.sh
│  └─ inspect-agent-test.sh
├─ repositories/
│  ├─ minimal/
│  ├─ brownfield/
│  └─ structured/
└─ scenarios/
   ├─ contract-boundary/
   ├─ brownfield-scope/
   └─ local-rule-precedence/
```

## Repository fixture vs Scenario

`tests/repositories/` はAIが作業する**初期world template**。

- nested `.git/` を保持しない。
- scenarioごとにtemporary run directoryへcopyする。
- fixture原本をexecution agentへ直接編集させない。

`tests/scenarios/` はAIへ与える**taskと評価軸**。

各scenario:

```text
scenario.conf
PROMPT.md
EXPECTATIONS.md
```

- `PROMPT.md`: execution agentへ渡してよい。
- `EXPECTATIONS.md`: evaluator専用。agentへ事前提示しない。
- `scenario.conf`: fixture mapping等のharness metadata。

## Run materialization

default:

```text
${TMPDIR:-/tmp}/documents-artifacts-agent-tests-<uid>/<scenario>/
├─ PROMPT.md
└─ repo/
   ├─ .git/
   ├─ documents/artifacts/
   └─ <fixture files>
```

`prepare-agent-test.sh` が:

1. fixtureをcopy;
2. temporary Git repositoryを初期化;
3. fixture baselineをcommit;
4. current Artifact v2 whole packをinstall;
5. artifact installをcommit;
6. agent用PROMPTをrun rootへcopy;
7. `artifact-test-baseline` tagを作成する。\n8. clean baselineを確認する。

evaluation fileはtarget repositoryへ入れない。さらにgenerated runをsource repositoryの外へ置き、agentが親directoryを辿っただけで `EXPECTATIONS.md` を発見できる配置を避ける。

`ARTIFACT_TEST_RUNS_ROOT` を明示すればrun rootを変更できる。self-testでは独立したtemporary directoryを使う。

## Agent protocol

execution agentには原則:

- working directory = generated `repo/`
- task = generated `PROMPT.md`
- repository外のharness / EXPECTATIONSは見せない

とする。

各PROMPTは、agentに:

1. target repositoryのlocal instructionsを確認;
2. `documents/artifacts/INDEX.md` から必要knowledgeだけをroute;
3. taskを実施;
4. verificationを実施;
5. 最終報告で**実際に読んだartifact file path**を列挙

させる。

この自己報告は完全なtelemetryではないが、routing behaviorの初期観測として利用する。

## Evaluation dimensions

### Outcome
requested behavior / design outcomeを満たしたか。

### Routing
- root INDEXから始めたか。
- taskに関係するleafへ到達したか。
- Artifact pack全体を「念のため」読むような動作をしていないか。
- conditional concernだけを必要時に追加したか。

### Semantic adoption
Artifactの規範が実際の判断へ反映されたか。

### Scope / safety
- fixture外へ変更を広げていないか。
- managed `documents/artifacts/` を改変していないか。
- destructive actionを勝手に行っていないか。

### Verification / report
- 実行したcheckと未実行checkを区別したか。
- 必要に応じてcontract conformanceとrequested outcomeを区別したか。

## Scenario design

scenarioは単一規則の暗記quizにしない。現実的なtaskで複数の妥当な実装を許しつつ、Artifactを読んだ場合に判断の質・scope・routingが観測可能に変わるものを優先する。

EXPECTATIONSはexact implementationではなくmust / must not / strong signal / acceptable variationを分ける。

## Initial fixtures

- `minimal`: project-local architectureがほぼない。Artifact defaultを見る。
- `brownfield`: 周囲に改善余地があってもrequested scopeを維持できるかを見る。
- `structured`: local `AGENTS.md` がgeneric Artifactをspecializeできるかを見る。

## Fixture immutability

test runは `tests/repositories/` を直接変更しない。generated runはsource repository外のtemporary rootへ置く。

## Growth

初期scenarioが安定した後、failure/async、performance、documentation、Work Identity、worktree、destructive operation、Docker/CI等をhigh-risk順に追加する。
