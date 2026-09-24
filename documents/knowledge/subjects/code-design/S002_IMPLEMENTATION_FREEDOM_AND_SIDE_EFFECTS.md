# Implementation Freedom and Side Effects

## 内部paradigmはcontractに従う限り自由

boundaryの外から観測されるcontractを保持できるなら、内部実装は特定paradigmへ固定しない。

sourceで例示される内部手法:

- Functional
- Data-oriented
- Procedural
- Low-level optimized code

内部構造は変更可能であり、外からはstableなunitとして扱える状態を目指す。

この自由は、contractを無視してよいという意味ではない。caller-visible behaviorやside effectが変わるなら、単なるinternal refactorではない。

## State / side effectは消去ではなくcontainment

state、I/O、time、external systemsは現実のprogramで避けられない。

目的はside effectの全面排除ではなく、次である。

- isolateする
- explicitにする
- clear boundary内へconfineする

適切なboundaryとcontractにより、side effectをtraceable / predictable / non-contagiousにする。

## Encapsulation Horizonとの接続

Encapsulation Horizonは「どこまでを一つの内部として自由にするか」を決める。

Code Designは、その内部自由を利用するときも、外部へside effect / state semanticsが漏れる場合はcontractへ現れるという前提で実装する。

failure / resource / determinism / persisted data等のleakage channelは `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` が主所有する。

## Sources

- `../../records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md` §4–5
- `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md`
