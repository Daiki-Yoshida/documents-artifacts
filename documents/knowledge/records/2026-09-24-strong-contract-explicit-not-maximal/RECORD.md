# Source record: 2026-09-24-strong-contract-explicit-not-maximal

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/37"
source_issue: 37
source_created_at: "2026-09-24T14:01:59Z"
source_updated_at: "2026-09-24T14:01:59Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。Issue本文は会話の原文そのものとは限らない"
関係: "contract-boundary execution-agent testの評価から生じたknowledge判断 (strong contract ≠ maximally restrictive contract) と execution-agent / evaluator cycle固定化の採用source"
関連source:
  - "tests/results/contract-boundary/2026-09-24-devin.md (raw execution result。本recordでは内容を転記せずpathのみ参照)"
  - "commit 6a2951d18c0f08e1c67a765fef15695ca5d46368 (execution result追加commit)"
  - "本Issueは採用済みtaskとして発行された"
```

## 取得本文（原文）

~~~~text
## 背景

Artifact v2の初回execution-agent behavior test `contract-boundary` が完了した。

Execution result:

```text
tests/results/contract-boundary/2026-09-24-devin.md
```

result commit:

```text
6a2951d18c0f08e1c67a765fef15695ca5d46368
```

Evaluator expectations:

```text
tests/scenarios/contract-boundary/EXPECTATIONS.md
```

Must / Must-not は満たしており、routingも概ね意図どおり機能した。

一方、実runで次の改善点が観測された。

## Finding 1 — strong contract を maximally restrictive contract と誤読し得る

Agentは要求されていないにもかかわらず、現在のBFS実装が持つ:

- shortest path
- deterministic path

をpublic contractとして保証した。

現在の要求で明示されていたのは:

- orthogonal movement
- `#` blocked
- reachable path includes start/goal
- unreachableとinvalid inputを区別

であり、shortestness / determinismはcurrent implementationの性質ではあるが、selected responsibility / load-bearing requirementから必ずしも導出されていない。

Artifact v2の:

> small surface, strong contract

は、

> 必要な意味を曖昧にしない

ことを意味し、

> current implementationが偶然持つobservable propertyを最大限public guaranteeへ昇格する

ことを意味しない。

### 採用するrule

概念として次をcanonical knowledgeへ追加する。

> **Strong contract is explicit, not maximally restrictive.**

または同義の日本語規範:

> **強いcontractとは、必要な意味・制約を明示的に閉じることであり、現在の実装が偶発的に持つ性質まで最大限に公開保証へ昇格することではない。**

判断基準:

- selected responsibilityから導出されるか
- user/product requirementとしてload-bearingか
- callerが安定保証として依存すべき性質か

のいずれにも該当しないimplementation propertyは、public guaranteeへ自動昇格させない。

特にalgorithm choiceから偶発的に生じる:

- shortestness
- deterministic tie-breaking
- ordering
- complexity
- caching behavior

等は、要求または責務上必要でない限りinternal freedomを狭めるcontractへしない。

ただし既にcaller-visible requirementとして必要なら、当然contract completenessとして明示する。

## Finding 2 — execution-agent cycleをrepository workflowとして固定する

今後、Artifact v2改善では次のcycleを標準とする。

```text
ChatGPT / evaluator
  ↓ design / evaluation / task definition
GitHub Issue
  ↓
Execution Agent
  ↓ implementation / verification
Branch + PR + repository-side result/report
  ↓
ChatGPT / evaluator
  ↓ GitHub上でreview
  ↓
merge or next Issue
```

ユーザーがexecution-agent reportをchatへcopy/pasteすることを前提にしない。

behavior testでは:

```text
tests/scenarios/<scenario>/
tests/results/<scenario>/
tests/evaluations/<scenario>/
```

を役割分離する。

- `PROMPT.md`: agent task
- `EXPECTATIONS.md`: blind evaluator criteria
- `tests/results/**`: execution agentのraw run report。後から期待値に合わせて改変しない
- `tests/evaluations/**`: evaluatorによるEXPECTATIONS照合・Artifact改善判断

raw resultとevaluationを同じfileへ混ぜない。

## 実装scope

### A. Source / canonical knowledge

この判断のsourceをrecord化する。

入力として最低限:

- `tests/results/contract-boundary/2026-09-24-devin.md`
- 本Issue本文
- 本Issueが採用済みtaskとして発行された事実

をtrace可能にする。

既存recordを上書きせず、新しいrecordを追加する。

そのうえで主authority:

```text
documents/knowledge/subjects/encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md
```

へ「strong contract ≠ maximally restrictive contract」を追加する。

必要ならINDEX / operational guardへ短いrouting/guardを追加してよいが、duplicate authorityを作らない。

### B. Artifact projection

canonical knowledge更新後に:

```text
artifacts/design/CONTRACTS.md
```

へconcise Englishでprojectionする。

例の趣旨:

```text
A strong contract is explicit about required semantics; it is not maximally restrictive.

Do not promote incidental properties of the current implementation into public guarantees unless the selected responsibility or a load-bearing requirement actually requires them.
```

そのままの文面である必要はない。
normative strength / conditionを保持すること。

`ARTIFACT_PROJECTION_MAP_V2.md` が現状のmappingを正しく表すなら無意味に変更しない。

### C. Test evaluation record

新規:

```text
tests/evaluations/contract-boundary/2026-09-24-devin.md
```

を作成し、今回のevaluator結果を記録する。

最低限:

- Must: PASS
- Must-not: PASS
- routing: PASS
- managed Artifact integrity: PASS
- verification reporting: PASS
- observed improvement: strong contract overconstraint risk
- optional observation: README更新時のdocumentation routing境界は今後の観察対象
- overall: initial behavior test successful, with one Artifact improvement

を記録する。

execution result本文を書き換えない。

### D. Harness workflow docs

更新候補:

```text
documents/project/AGENT_ARTIFACT_TEST_HARNESS.md
tests/INDEX.md
```

今後のcycleを明示する。

特に:

1. agent run
2. raw resultを `tests/results/` へ保存
3. push / PR等でGitHubから取得可能にする
4. evaluatorがEXPECTATIONSと照合
5. evaluationを `tests/evaluations/` へ保存
6. Artifact改善が必要ならIssue化
7. execution agentが改善を実装
8. evaluator review

を記述する。

現在 `AGENT_ARTIFACT_TEST_HARNESS.md` に:

```text
7. artifact-test-baseline tag...
8. clean baseline...
```

の間へliteral `\n` が混入しているため、合わせて通常の改行へ修正する。

### E. VCS / reporting

今回以降、execution agentは原則:

- mainへ直接commitしない
- main最新からwork branchを作る
- commit
- push
- PR作成
- IssueをPR本文で参照
- final reportはPR bodyまたはIssue commentへ残す

とする。

ただしrepositoryにより明示的な別local ruleがある場合はそちらを優先する。

## Validation

最低限:

```bash
bash tests/test-agent-harness.sh
bash tests/test-knowledge-integrity.sh
```

可能ならArtifact関連testも:

```bash
bash tests/test-artifacts.sh
```

を実行する。

実行できなかったcheckをPASSと報告しない。

## Scope guard

今回やらない:

- Artifact v2全体の再設計
- contract-boundary scenarioのtask requirement変更
- execution resultの後編集
- unrelated subject cleanup
- shortest path / determinismを一般に禁止すること

ポイントは「保証すべき場合は保証する。しかしcurrent implementation propertyであるだけでは保証へ昇格しない」。

## Completion

- new record → subject → artifact の順で変更されている
- raw resultとevaluationが分離されている
- execution-agent / evaluator cycleがrepository docsに残る
- testsが可能な範囲でPASS
- work branchをpushしPRを作成
- PR/Issue上に、変更・verification・未実行checkを記録する

~~~~
