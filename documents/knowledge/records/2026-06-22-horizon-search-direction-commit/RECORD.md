# Source record: 2026-06-22-horizon-search-direction-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "f6c890c477f810392212006f701327ec97587b30"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/f6c890c477f810392212006f701327ec97587b30"
source_author_date: "2026-06-22T11:17:37Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata"
changed_files:
  - "artifacts/AI_WORKFLOW.md"
  - "artifacts/DESIGN_PHILOSOPHY.md"
  - "artifacts/INDEX.md"
```

## Commit message原文

~~~~text
artifacts に探索方向・既定硬化・初期地平線(module=prior)を反映

原本 §6.5 の運用版を配布物へ符号化した。

- DESIGN_PHILOSOPHY.md: Encapsulation Horizon に search_direction(macro→micro/既定harden)
  ・why_top_down(blast radius+訂正コスト非対称)・initial_horizon(module=prior, floor でない)
  ・early_stage(未成熟域は module 以深へ降りない=過剰硬化回避) を追加
- AI_WORKFLOW.md: Pre-Implementation Scan #1 に macro→micro/既定harden/module 以深は柔軟既定/
  未成熟域は深追いしない を配線
- INDEX.md: Ownership Map の Encapsulation Horizon 記述を同期

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
~~~~
