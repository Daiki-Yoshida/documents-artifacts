# History

## 旧AI_WORKFLOWからの分離

旧 `design-principles/AI_WORKFLOW.md` はFLOWとして、code design判断とengineering operationを同じfileへ含めていた。

現行では主語を分ける。

- boundary hardening → encapsulation-horizon
- code realization / testing semantics → code-design
- change process / scope / verification / VCS / reporting → engineering-operation
- command/runtime → development-execution
- destructive risk → development-safety
- Work lifecycle → work-identity

## Source recovery

2026-09-24の監査で、以前不足と判断していたOperational Disciplineの導入sourceを特定した。

2026-06-13 `b92af54` commitはAI_WORKFLOWへ次を追加している。

- reporting
- test-before-done / failure reporting
- commit / push authority
- default branch guard
- commit confirmation
- clarification stop rule

2026-07-01 commitはbrownfield policyを追加した。

初期2026-01-31 AI_WORKFLOWにはchange processとapproach questionが存在する。2026-07-02 snapshotは旧repository側のfinal substantive stateを保持する。

これにより、責務境界だけでなく主要normative coreもversioned sourceへ追跡できるため、engineering-operationを正式subjectへ昇格した。

## 後続訂正

旧workflowにあった「Contract Tests PASS = completion」の強い読み方は、その後のdesign-principles提案・採用で修正された。

現在はcontract conformanceとrequested outcome verificationを分ける。

旧固定reporting languageも現在の普遍規範にはしない。

## Sources

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../../project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md`
