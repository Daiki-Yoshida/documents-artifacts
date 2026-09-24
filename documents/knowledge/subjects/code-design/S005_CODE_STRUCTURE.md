# Code Structure

## Feature / module first

code structureは、technical layerをtop-levelにするより、**feature / moduleを主要境界として、その内部に必要なlayerを置く**ことを基本とする。

```text
<feature>/
  domain/
  application/
  infrastructure/
  ui/
```

小さいmoduleはflatでもよい。directory数ではなく、責務と依存方向が守られていることを優先する。

## Layer responsibility

### Domain

- business concept / invariant / domain policyを所有する。
- UI / Infrastructure / vendor SDKへ依存しない。
- business contract / domain errorを所有できる。

### Application

- use case / orchestrationを所有する。
- Domainへ依存する。
- use-case固有のportを所有する。
- authorization / transaction / port call / DTO mapping等を調停できる。
- technical detailやDomain invariantそのものを所有しない。

**coordinate ≠ own**。Applicationは複数責務を協調させてよいが、それぞれの内部判断を取り込まない。

### Infrastructure

- DB / HTTP / filesystem / queue等のtechnical implementationを所有する。
- Domain contractまたはApplication portを実装する。
- technical type / exceptionを内向きへ漏らさない。

### UI

- presentation / view state / input formattingを所有する。
- Applicationへ依存する。
- presentation typeをDomain / Applicationへ逆流させない。

## Contract placement

contractは**存在理由を所有するboundary**へ置く。

```yaml
Domain_contract:
  owner: "Domain"
Application_port:
  owner: "Application"
Infrastructure_implementation:
  owner: "Infrastructure"
```

すべてのinterfaceをDomainへ集めない。

## Module public surface

hardeningされたmodule/unitは、原則として1つのprimary public surfaceを持ち、その他をinternalにする。

- cross-module accessはpublic surface経由。
- deep importでinternalへ依存しない。
- Infrastructure adapterは通常public surfaceへ出さない。
- use case / contract / boundary DTO / factory等だけを必要最小限に公開する。

追加public surfaceは、audience・stability scope・evolution ruleが名前付きで明示される場合に限って許容できる。

## Shared placement

単一の巨大shared dumping groundを作らない。旧sourceではT0 kernel / T1 cross-cutting ports / T2 shared contracts / T3 shared domain VOsへ分けていた。

共有への昇格は、複数consumerの需要と意味の安定性を確認してから行う。Concept Altitudeとsemantic identityは `../encapsulation-horizon/S004_CONCEPT_ALTITUDE.md` が主owner。

## Sources

- `../../records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/PROJECT_STRUCTURE.md`
- `../../records/2026-06-21-project-structure-origin-commit/RECORD.md`
- `../../records/2026-06-22-design-review-guard-commit/RECORD.md`
