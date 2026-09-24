# History

## 旧design-principlesとの関係

旧 `artifacts/design-principles/` はWHY / HOW / WHERE / FLOWの4文書＋INDEXで配布されていた。

現在はそのpackagingをsubject authorityとして復活させない。

`code-design` は、旧artifactのうちcode realizationに関係する知識を**source-backedな範囲だけ**再整理するために新設した。

## 初期subject化で採用したsource-backed範囲

- foundational programming paradigm
- internal implementation freedom
- side-effect containment
- inheritanceの意味と不適切利用
- state ownership / cross-boundary consistency
- compatibilityのconsumer/provider両面確認
- contract conformanceとrequested outcome verificationの分離
- load-bearing performance requirementとinteraction-shape redesign gate
- design priority

## 未移行のlegacy detail

次は旧artifactには存在するが、初期subject化時点でsource / adoption traceabilityが不足しているためcanonicalへ昇格していない。

- detailed layering rules
- constructor DI / Service Locator policy
- external SDK wrap/allow/prohibitの全条件
- Result/Either bootstrapとlibrary selection
- error boundary translationの全条件
- concurrency / async / cancellation / thread-safetyの全条件
- Rich / Lightweight Domain Modelの選択
- DTO / Mapper / Converter / Adapter placement
- shared kernel T0–T3
- runtime topology / composition rootの全条件
- unit / integration / E2E / test placementの全詳細
- Composition Over Inheritanceという強い一般化（source原本はinheritanceの契約的意味までは定義するが、常にcompositionを選ぶ規範までは直接定義しない）

これらは `documents/project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md` で調査を継続する。

## Source recovery

2026-09-24に、旧repositoryの非配布reference `PROGRAMMING_PARADIGM.md` と `AI_DOC_STRATEGY.md` をGit blob SHA付きsnapshotとして `records/2026-06-13-design-principles-reference-snapshot/` へ保存した。

これにより旧artifactだけに依存せず、foundational code-design knowledgeの一部を第0情報源から再構成できるようになった。
