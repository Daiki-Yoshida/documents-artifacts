# Realization Model

Code Designは、softwareをclass taxonomyとしてではなく、**bounded unitがexplicit contractを介して相互作用する構造**として捉える。

ただしboundaryをどこに置くか自体は `../encapsulation-horizon/` の責務である。この文書は、選択済みboundaryをcodeへ落とすときの前提を扱う。

## Contract-first

実装より先にcaller-visible contractを設計対象として扱う。

contractから少なくとも次を理解できる状態を保つ。

- 何ができるか
- どのinputを受けるか
- どのoutputを返すか
- どのside effectが起こり得るか
- 何を保証しないか

implementation detailは、contractを保持する限り交換可能である。

Contractの完全性・leakage channelのsemantic ownerは `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` を参照する。

## Encapsulationはclassではなくboundary

encapsulationはclassに限定しない。

対象になり得るunit:

- class
- module
- subsystem
- library
- application

class / interface / objectはboundaryを表現するmechanismであり、それ自体が設計目的ではない。

code designの目的は、implementation detailを隠し、accidental couplingを減らし、変更影響を局所化することである。

## Object-Orientedの解釈

このknowledgeでObject-Orientedという語を使う場合、次を優先して解釈する。

- message-based interaction
- contract-driven boundary
- black-box encapsulation

次をidentityとはしない。

- class-centric modeling
- world-as-objects modeling
- inheritance-heavy design

この解釈は「classを使わない」という意味ではない。class / interface / objectは必要に応じて選ぶtoolであり、boundary / contractより上位の目的ではない。

## Sources

- `../../records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md` §1–3, §7
- `../encapsulation-horizon/S001_CORE_PRINCIPLE.md`
- `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md`
