# Brownfield and Approach Questions

## Brownfield

既存projectへ共通規範を適用するとき、taskが触れるcodeと周辺legacyを区別する。

```yaml
new_or_modified_code: "明示的local conventionと矛盾しない範囲でcurrent ruleへ合わせる"
surrounding_violation: "見つけただけでは黙って修正しない"
scope_guard: "violation huntでtask scopeを拡大しない"
local_convention: "明示project ruleが共通知識と衝突する場合、conflictを認識した上でlocal ruleを優先"
```

既存違反のcleanup自体が必要なら、それを独立したchangeとしてimpactを評価する。

## Approach question

userが「どう進めるべきか」とapproach比較を求めている段階では、質問自体をimplementation requestへ勝手に変換しない。

sourceの基本形:

1. 複数の現実的approachを示す。
2. complexity / performance / maintainability等のtrade-offを比較する。
3. current project constraintsに基づいて推奨理由を示す。

実装開始のauthorityはuser requestとtask contextから判断する。

## Sources

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
