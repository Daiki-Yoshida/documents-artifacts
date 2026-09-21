# Workspace構造 — 履歴

旧development-environment artifact群の中で、workspace/repository構造の責務境界を説明していた歴史的情報を保持する。

現在はWorkspace構造そのものをこのsubjectが所有し、Work Root / Work Documents / repository-specific worktreeは `../work-identity/` が所有する。

## Original preamble

# ワークスペース構造

```yaml
document_type: "workspace_structure_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/WORKSPACE_STRUCTURE.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

---

## 10. 他artifactとの境界

```yaml
development_environment_strategy:
  担当: "repository、checkout、worktree配置と開発環境top-level directory"
design_principles:
  担当: "application module、public code surface、依存方向、test architecture"
documentation_strategy:
  担当: "documents/ 内部構造、案内、保守"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
