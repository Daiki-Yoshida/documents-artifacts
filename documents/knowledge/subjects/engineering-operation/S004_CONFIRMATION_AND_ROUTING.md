# Confirmation and Routing

engineering-operationは一つの巨大なconfirmation levelを定義しない。

変更の性質ごとにsemantic ownerへrouteする。

## Routing

| 変更 | 主owner |
|---|---|
| code boundary / public contract impact | `encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` |
| documentation structure / authority model | `documentation/S004_MAINTENANCE_AND_REVIEW.md` |
| destructive / host / recovery operation | `development-safety/S005_CONFIRMATION_AND_REREAD.md` |
| Work identity / resource lifecycle | `work-identity/` + destructive部分はdevelopment-safety |
| code realization detail | `code-design/` |

## 原則

- internal implementation-only changeをpublic breaking changeと同じ重さで扱わない。
- signatureがadditiveでも既存implementerを壊す場合はcompatibleと推定しない。
- documentation content editとrouting model変更を同一視しない。
- cleanupがresource lifecycle上必要でも、destructive actionの安全条件を省略しない。

workflowは**いつrouteするか**を所有し、各levelの意味はowner subjectが所有する。

## Sources

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md`
- `../documentation/S004_MAINTENANCE_AND_REVIEW.md`
- `../development-safety/S005_CONFIRMATION_AND_REREAD.md`
