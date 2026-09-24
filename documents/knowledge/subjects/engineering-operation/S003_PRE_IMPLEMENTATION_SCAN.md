# Pre-Implementation Scan

実装前scanは、変更に必要な判断を漏らさず、同時に小変更を過剰設計しないために行う。

## Proportionality

scanの深さをblast radiusへ合わせる。

軽微な例:

- typo / comment / document-only fix
- test-only change
- stable boundaryの背後にあるprivate helper

この場合、quick sanity checkへ縮退できる。

一方、次へ触れる場合はscanを広げる。

- public contract
- module / responsibility boundary
- external dependency
- persistent data
- caller-visible performance / resource guarantee
- cross-boundary state / failure

## Scanの問い

必要に応じて次を確認する。

1. **Outcome** — userが観測したい結果は何か。
2. **Responsibility / boundary** — どのunitが意味を所有するか。
3. **Concept / state** — semantic identityやstate ownershipへ影響するか。
4. **Dependency spread** — external dependencyがcore vocabularyへ侵入するか。
5. **Mapping / translation** — boundary crossingを誰が所有するか。
6. **Compatibility / risk** — existing consumer/providerやoperation safetyへ影響するか。
7. **Verification path** — 何を確認すれば要求達成を観測できるか。

各問いの答えそのものをこのsubjectで再定義しない。Encapsulation Horizon / Code Design / Development Safety等のownerへrouteする。

## Sources

- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
