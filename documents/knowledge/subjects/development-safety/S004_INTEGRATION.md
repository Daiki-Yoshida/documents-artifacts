# 開発安全性 — 統合

repository ownershipを守りながら変更を統合し、統合後HEADで再検証する原則を扱う。

## 4. 統合

統合方式はproject固有ですが、repository境界を守ります。

- merge、rebase、PRはbranchを所有するrepositoryで行う。
- Component Repositoryの変更をWorkspace Repositoryへcommitしない。
- 統合後HEADで必要な検証を再実行する。
- Workspace toolが変わった場合、意図したWorkspace refでComponentを検証する。
- 必要ならPrimary Checkoutをproject規則の安定状態へ戻す。

このstrategyはPR承認やrelease方針を決めません。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
