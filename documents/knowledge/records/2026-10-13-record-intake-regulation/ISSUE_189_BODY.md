## 背景

`documents/knowledge/records/` は現時点で原文・snapshot保存層として機能しているが、record数の増加に伴い、保存形状やmetadataの表現がやや雑多になってきている。

一方で、recordsは第0情報源を可能な限り改変せず保存する根拠層であり、既存recordを大規模に整理・再配置すると、immutable history / traceability / provenanceを不必要に揺らす可能性がある。

そのため、既存recordsを大きく変更するのではなく、**今後追加するrecordのintake / organization regulationを策定し、これ以上のformat driftを防ぐ**方向を検討する。

## 現状観測

- `documents/knowledge/records/` はflatな `YYYY-MM-DD-<short-title>/` 構造を採用している。
- 現在のrecord directoryは、単一source event、Git commit、PR、decision、implementation、conversation、chat transcript、repository snapshot等を同一階層で保持している。
- directory namingと `RECORD.md` / `MANIFEST.md` の存在は既存testで検証されている。
- 一方で、metadata key・source fidelity・source scope・複数source eventを束ねる場合の表現などは統一されていない。
- 最近のchat transcript recordでも、「原文」「収録範囲」「formatting normalization」の境界を後から明確化する必要が生じた。

## 方針

このIssueでは、既存recordsの大規模migration / rename / directory再配置を前提としない。

優先する方向:

- 既存recordは原則grandfatheringし、履歴・provenanceを保持する。
- `records/` のflatな時系列構造は維持する。
- semantic classificationは `subjects/` の責務とし、records側へtopic taxonomyを持ち込まない。
- 今後追加するrecordに対して、最小限のintake contract / metadata regulationを定義する。
- raw sourceの保存忠実度と収録scopeを、曖昧な「原文」という表現だけに依存せず説明可能にする。
- 複数source eventを1 directoryへまとめる場合、そのbundle構造とsource inventoryを明示できるようにする。
- current / superseded / rejected等のeffective statusは引き続きDecision Lineage / subjects側で扱い、immutable recordへ固定しない。
- 必要なら `documents/knowledge/records/INDEX.md` を追加し、recordsの役割と追加規則への入口だけを提供する。
- validation追加時は既存85件を一括変換させるのではなく、新規規格へincrementalに適用できる方式を優先する。

## 検討項目

- record shapeの最小taxonomy
  - 単一event
  - 複数source event bundle
  - snapshot
- metadata keyの最小共通schema
- source date / capture date / directory dateの意味
- source locator / provenanceの必須度
- source fidelity / transcription / normalization / selection scopeの表現
- bundle内payload file namingとinventory
- `RECORD.md` と `MANIFEST.md` の責務境界
- `records/INDEX.md` の必要性と責務
- `tests/test-knowledge-integrity.sh` でどこまで機械検証するか
- legacy recordへの適用範囲

## 非目標

- 既存recordsの一括rename
- recordsをtopic別directoryへ再分類すること
- 過去record本文の再編集
- records側でsemantic current statusを管理すること
- subjects / artifactsの責務をrecordsへ移すこと

## 完了条件

- recordsの保存責務を壊さず、今後の追加時にformatを毎回発明しなくて済むregulationが定義されている。
- 既存recordへの影響範囲が明示されている。
- RECORD_MODEL / KNOWLEDGE_UPDATE_WORKFLOW / validationへの反映要否が整理されている。
- implementationを行う場合も、既存recordの履歴・provenanceを不要に変更しない方針が維持されている。
