# Inheritance Boundary

Inheritanceを**単なるcode reuse mechanism**として選ばない。

旧reference原本では、inheritanceはbehavior / lifecycle / framework-level assumptionを強く拘束するcontract-enforcement mechanismとして位置づけられている。

## 適用できる場合

- parentがstrict behavioral specificationを定義する
- childがそのspecificationへ従う必要がある
- framework / lifecycle contractを継承によって強制する必要がある

## 避ける場合

- casual reuse
- convenienceだけのDRY
- semantic guaranteeを持たないstructural sharing

「共通codeがある」という事実だけではinheritanceの根拠にならない。

この文書は「常にcompositionを使う」という別規範までは追加しない。sourceが直接定義しているのは、inheritanceを選ぶ意味と不適切な利用範囲である。

## Sources

- `../../records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md` §6
