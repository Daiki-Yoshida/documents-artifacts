# 開発安全性 — 統合

repository ownershipを守りながら変更を統合し、統合後HEADで再検証する原則を扱う。

Work lifecycle上でintegrationがいつ行われ、Work全体をいつcompletedとするかは `../work-identity/S004_LIFECYCLE_AND_RESOURCES.md` が所有する。この文書は、そのintegration operationを安全に実行する規則を所有する。

## 統合

統合方式はproject固有だが、repository boundaryを守る。

- merge / rebase / PRはbranchを所有するrepositoryで行う。
- Component Repositoryの変更をProject / Workspace Repositoryの通常fileとしてcommitしない。
- integration後HEADで必要なvalidationを再実行する。
- Workspace toolが変わった場合は意図したWorkspace refでComponentを検証する。
- static repository resolutionにPrimary Checkoutを使うprojectでは、必要に応じてproject規則のstable stateへ戻す。

一つのrepository branchがmergeされたことだけをWork全体のcompletionとみなさない。multi-repository Workのcompletion / Work Documents reconciliation / resource cleanupはWork Identity側で判定する。

このsubjectはPR承認policyやrelease governanceを決めない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
