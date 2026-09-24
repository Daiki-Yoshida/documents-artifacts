# State Ownership and Consistency

boundaryを分けても、mutable business stateとbusiness outcomeのownershipが曖昧になってはならない。

## Mutable state owner

mutable stateは1つのclear ownerを持つ。

他boundaryは、そのstateをownerのcontract越しに扱う。

## Cross-boundary business outcome

1つのbusiness outcomeが複数state ownerをまたぐ場合、参加者の内部stateを奪わずに、**coordinationとfailure policyを所有するboundary**を明確にする。

orchestratorが複数participantを呼ぶことと、participant内部のbusiness decisionやstateをorchestratorが所有することは同じではない。

## Consistency strategy

topologyに応じ、必要なconsistency modelを明示する。

sourceで採用された選択肢:

- atomic transaction（利用可能な場合）
- retry
- idempotency
- compensation
- explicit intermediate state

これらから何を選ぶかは、対象systemのtopologyと要求するconsistencyに依存する。

## Cross-boundary invariantは自動merge条件ではない

複数boundaryにまたがるinvariantがあるだけでmoduleを自動的にmergeしない。

一方で、次が繰り返し発生するならboundary split自体を再検討する。

- seamがchattyになる
- mutable stateを実質共有する
- 両側を毎回同時変更する

hardening / split判断そのものは `../encapsulation-horizon/` が主所有する。この文書は、split後のstate / outcome / failure ownershipを扱う。

## Sources

- `../../records/2026-09-06-design-principles-proposals/RECORD.md` 提案5
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md` 採用5
