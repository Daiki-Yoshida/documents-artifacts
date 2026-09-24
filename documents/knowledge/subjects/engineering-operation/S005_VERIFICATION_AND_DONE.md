# Verification and Done

## Contract conformanceとrequested outcome

verificationでは少なくとも次を分離する。

1. implementationがcontractへ適合するか。
2. userが必要としたobservable outcomeが成立するか。

contract・implementation・testが相互に整合していても、要求理解が誤っていればtaskは成功していない。

この区別のcode-level semanticsは `../code-design/S010_COMPATIBILITY_AND_VERIFICATION.md` が主所有する。

## Test discipline

実装後、doneを宣言する前に変更へ比例したverificationを行う。

- narrowest relevant suiteから始める。
- boundaryへ触れた場合は必要に応じて範囲を広げる。
- test failureがある場合、failureを報告し、PASSしていないものをdoneと表現しない。
- 実行できなかったverificationは未実施として明示する。

具体的なunit / integration / contract / E2Eの役割は `../code-design/S009_TESTING_AND_RUNTIME.md`、実行command / CI parityは `../development-execution/S003_COMMAND_INTERFACE_AND_CI.md` を参照する。

## Doneの最小条件

task固有の追加条件がなければ、少なくとも次を区別して報告できること。

- changed: 何を変えたか
- verified: 何を実際に検証したか
- not_verified: 実行できなかった検証
- remaining: task scope内に残るもの
- impact: public contract / data / operationへの影響

## Sources

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
