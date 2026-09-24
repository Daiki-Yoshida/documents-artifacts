# Domain and Data Boundaries

## Domain modeling

modelのrichnessはsubdomainのcomplexityへ合わせる。

### Rich Domain Model

複雑なinvariant、meaningfulなstate transition、business ruleがentity自身の状態と強く結び付く場合に適する。domain ruleをmodel内部で保持し、不正状態を外へ押し出さない。

### Lightweight model

CRUD中心、data holderとしての性質が強く、domain ruleが少ない場合はlightweightでよい。

「lightweight」はbusiness ruleをUI / Infrastructureへ散らす意味ではない。意味のあるdomain ruleはDomainが所有する。

## Entity state

通常のidentity-preservingな更新ではmutable rich modelを使える。

state変化によって可能なoperation自体が変わるcritical flowでは、type-driven state transitionを使える。

どちらを選ぶ場合もentity lifecycle内で一貫させる。

## Domain purity

技術mechanismとdomain conceptを分ける。

通常Domainへ入れない:

- DB / HTTP / filesystem IO
- external API DTO
- framework annotation
- vendor SDK type
- UI framework type

time / color / text等でもbusiness上の意味そのものならDomain conceptになり得る。

判断軸は「その値が存在するのはUI/technologyの都合か、domain自身の意味か」。

## State ownership

mutable business stateは1つの明確なowner boundaryを持つ。

複数state ownerにまたがるbusiness outcomeでは、orchestration boundaryがcoordinationとfailure policyを所有できるが、participantの内部stateを奪わない。

詳細は `S004_STATE_OWNERSHIP_AND_CONSISTENCY.md`。

## DTO and mapping

Domain Entity / Value Objectは外部representationへのconversionを所有しない。

placement:

- Application: Domain ↔ UseCase Request/Response
- Infrastructure: DB/API/filesystem model ↔ Domain
- UI: Application response ↔ ViewModel

小さいone-off mappingはowner boundary内でinlineでもよい。再利用・複雑・意味のあるmappingはextractする。

```yaml
Mapper: "structural DTO ↔ Domain"
Converter: "value/type conversion"
Assembler: "multiple sourcesからresponseを構築"
Adapter: "external API/SDKをproject-owned contractへ適合"
Translator: "vendor/external conceptをdomain conceptへ翻訳"
```

## Sources

- `../../records/2026-01-31-domain-model-refinement-source/files/CODING_STANDARDS.md`
- `../../records/2026-01-31-domain-model-refinement-source/files/DESIGN_PHILOSOPHY.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
