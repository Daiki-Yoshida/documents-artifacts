# Workspace構造 — Git所有境界と複数Repository

Workspace Repository / Component Repository間のGit所有境界、複数component、workspace tool dependencyを扱う。

## 6. Git管理境界

### Workspace Repository側でignoreするもの

- 独立Git履歴を持つComponent Repositoryのcheckout
- worktree対応がある場合の `.worktrees/`
- local secret
- build・export生成物
- runtime cache
- 共有しないeditor・OS file

embedded repositoryをignoreするだけでなく、そのpathが独立repositoryであることをAGENTSやproject文書へ書きます。

### Component Repository側

product cache、build output、generated file、tool固有状態はComponent Repository自身のignore規則で管理します。

Workspace RepositoryがComponent内の生成物を誤って所有しないようにします。

---

## 7. 複数component

一つのWorkspace Repositoryで複数Component Repositoryを管理できます。

```yaml
要件:
  - "各componentに安定したPrimary Checkout pathがある"
  - "workspace全体操作でない場合は対象componentを明示する"
  - "worktree利用時はcomponent別にnamespaceを分ける"
  - "衝突可能性があるresource名へcomponentを含める"
  - "component横断検証は独立した明示操作にする"
```

無関係なrepositoryを同じfolderへ置くだけのためにWorkspace Repositoryを作ってはいけません。共有toolや実際の調整責務が必要です。

---

## 9. Workspace toolへの依存

Component Repositoryが別Workspace Repository内のtoolへ依存する場合、使用versionを明示します。

```yaml
moving_ref:
  意味: "document化されたbranchまたは現在のworkspace checkoutを使う"
  特徴: "更新は簡単だが、過去再現性は弱い"
fixed_ref:
  意味: "tagまたはcommitを使う"
  特徴: "再現性は高いが、更新作業が必要"
```

CIやrelease検証が、指定されていないworkspace最新版へ偶然依存してはいけません。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
