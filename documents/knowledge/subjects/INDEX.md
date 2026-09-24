# Subjects

`subjects/` は、recordsを根拠に整理された日本語knowledgeの入口である。

このINDEXはsubjectのinventory/routingを担当する。個々のsubjectの意味をここで再定義しない。

## Subjects

| Subject | 主な責務 |
|---|---|
| [work-identity](work-identity/INDEX.md) | Work Identity、Work lifecycle、Work Root、Work Documents、Git/worktree、resource ownership |
| [encapsulation-horizon](encapsulation-horizon/INDEX.md) | 境界をどのscaleで硬化するか、責務・module・内部自由・contractの関係 |
| [code-design](code-design/INDEX.md) | 選択済みsoftware boundaryをcode structureへ実現し、state/compatibility/verification/performance等を設計する |
| [engineering-operation](engineering-operation/INDEX.md) | engineering changeのauthority、scope、scan、confirmation routing、verification、VCS、reporting |
| [workspace-structure](workspace-structure/INDEX.md) | project全体のrepository/filesystem構造、Git所有境界、複数repository構成 |
| [development-execution](development-execution/INDEX.md) | host/container境界、Docker-first、公開command、local/CI、実行環境の再現性 |
| [development-safety](development-safety/INDEX.md) | 破壊操作、診断、復旧、統合、確認境界など開発操作の安全性 |
| [documentation](documentation/INDEX.md) | project documentationの正確性、routing、structure、workflow、maintenance、Git履歴 |

subjectはrecordsの分類folderではない。1つのrecordが複数subjectの根拠になることを許容する。
