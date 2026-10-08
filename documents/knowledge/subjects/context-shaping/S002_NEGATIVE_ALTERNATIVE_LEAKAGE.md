# Context Shaping — Negative Alternative Leakage

## Definition

**Negative Alternative Leakage (NAL / 否定代替案リーク)** とは、

> 特定の目的に向けて受け手へcontextを構成・提示する際、その目的に必要な理解・判断・行動を支える範囲を超えて、非採用または回避対象のalternativeを、主としてそれを否定するために導入・再提示・展開し、受け手のcontextへ不要なalternative modelを持ち込むアンチパターンである。

alternativeには、別の実装方式だけでなく次も含む。

- concept interpretation
- responsibility split
- classification
- procedure
- state model
- architecture / workflow alternative

そのalternativeが他の場面で有効かどうかではなく、**現在の説明目的に必要か**を判断する。

## Core failure

NALの核心は、「否定する」という役割を経由して、本来扱う必要のないalternative modelをconsumer contextへ入れることにある。

発生形態はsourceからの再導入だけではない。

- old / rejected modelを再導入する
- 既出のundesired alternativeを不要に再提示する
- alternativeのstructure / procedureを必要以上に詳述する
- 説明者が新しいundesired alternativeを想定し、否定のためだけに導入する

「current modelよりalternativeが目立つ」は典型的な兆候だが、NAL成立の必須条件ではない。

また、実際に誤答・誤実装が発生したことも成立条件ではない。context構成の時点でレビューできる。

## Review criteria

中心となる問い:

> このalternativeへの説明を省略・縮小し、必要なmodel・rationale・constraintを直接表現したとき、consumerの目的に必要なaccuracy、decision material、safety、verifiabilityが失われるか。

NALとして整理する主要条件:

1. 非採用・回避対象のalternativeを導入・再提示・展開している。
2. その説明の中心的役割がalternativeの否定であり、comparison / correction / verification / migration等の目的上の役割が乏しい。
3. 必要なrationale・exception・contractを保ったまま、より直接的な説明へ省略・縮小できる。

必要性を判断できない情報を、NALというlabelだけで機械的に削除しない。
まず、その情報がどの理解・判断・failure preventionに寄与するかを確認する。

## Sources

- `../../records/2026-10-07-generalized-nal-proposal/`
- `../../records/2026-10-07-generalized-nal-adoption/`
- `../../records/2026-10-04-negative-alternative-leakage/`
