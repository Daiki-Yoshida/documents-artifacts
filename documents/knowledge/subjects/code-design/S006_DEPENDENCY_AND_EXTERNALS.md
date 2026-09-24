# Dependency and External Boundaries

## Interface requirement

interface / protocol / trait等のcontract mechanismは、**実際のboundaryで価値を持つとき**に使う。

behavioral componentについて、次のいずれかならcontractを定義または再利用する。

- public / cross-module boundary
- DIされるdependency
- IO / DB / network / filesystem / clock / randomness等のvolatile dependency
- Domain/ApplicationをInfrastructureから守るboundary
- replaceable / test-substitutable / runtime-swappableなrole

private/internal helper、境界を形成しないsingle-implementation logic、短命なspikeへ機械的にinterfaceを作らない。

hardeningの時期・seam cost・maturityは `../encapsulation-horizon/` が主owner。

## Language idiom

contractの概念と各languageのsyntaxを分ける。

- C#の `I...` はC# idiom。
- Kotlin / TypeScript等ではそのecosystemの命名規則を優先する。
- interface syntaxがない場合もprotocol / trait / structural contract等へ写像できる。

## Dependency direction

依存はproject-owned abstractionへ向ける。

- Domainは外部implementationへ依存しない。
- ApplicationはDomainと自分が所有するportへ依存する。
- Infrastructureがそれらを実装する。
- composition rootがconcrete implementationを組み立てる。

## Dependency Injection

behavioral componentのvolatile dependencyはconstructor/property等、そのlanguageで明示的なdependency mechanismから与える。

- class内部でService Locatorを使わない。
- IO / Config / Random / Time等をbusiness component内で勝手に生成しない。
- Value Object / Entity / pure utilityのようなstable objectは通常生成してよい。

Domain Entity / Value ObjectへDI container的なservice dependencyをconstructor injectionすることは避ける。必要なcapabilityはdomain設計上の意味を確認し、method argument等の局所dependencyとして渡す。

## External dependency containment

外部library / SDK / framework / vendor typeはedgeへ閉じ込める。

wrap / adapter / project-owned DTOを作る強い理由:

- Domain/coreへvendor typeが入る
- 複数moduleへdependencyが広がる
- replacementが無関係な箇所へ波及する
- vendor terminologyがdomain vocabularyを支配する
- technical error / lifecycle / async / side effectがbusiness logicへ侵入する
- widely-depended-on moduleやcore domain conceptが依存する

UI固有frameworkをUI内で、SDK/clientをInfrastructure内で直接使うこと自体は問題ではない。**内向きに漏らさないこと**が重要。

## Inheritance

inheritanceはstrictなis-a contractやframework requirement等、意味がある場合に限定する。単なるcode reuseのためのinheritanceよりcompositionを優先する。

より基礎的なinheritanceの意味は `S003_INHERITANCE_BOUNDARY.md` を参照する。

## Sources

- `../../records/2026-01-31-initial-code-design-source/files/CODING_STANDARDS.md`
- `../../records/2026-01-31-initial-code-design-source/files/DESIGN_PHILOSOPHY.md`
- `../../records/2026-01-31-dependency-boundary-refinement-source/files/CODING_STANDARDS.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md`
