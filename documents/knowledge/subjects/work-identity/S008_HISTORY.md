# Work Identity — Historical Context

この文書は、現在のsubject構造へ再整理する際に、旧source logのauthority表現、旧artifactへの反映計画、当時の未検証事項などを失わないための履歴領域である。

ここにある内容は「現在も旧artifact構造を採用する」という意味ではない。作成当時に何が想定・計画されていたかを保持する。

## 旧source log metadata / preamble

### Work Identity design

# Work Identity 設計原本

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_source_log"
status: "artifactized_reference"
future_owner: "artifacts/development-environment-strategy/"
```

> この文書は、Work Identity を artifact 化する際の設計原本として作成された source/rationale log です。
> 現在の規範は `artifacts/` 側であり、この文書は背景・判断理由・圧縮前の文脈を保持する参照資料です。

---

### Git materialization experiment

# Work Identity Git Materialization 実験記録

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_experiment_record"
status: "artifactized_reference"
related_design: "WORK_IDENTITY_DESIGN_JP.md"
test_repository: "Daiki-Yoshida/test-git-track"
tested_environment:
  os: "Linux on WSL2"
  git: "2.43.0"
```

> Work Identity / Work Root 設計のうち、Project Repository が Work Documents を追跡しながら、
> 同じ `.worktrees/` 配下に Git worktree を安全に配置できるかを実機検証した記録。
> 検証条件・失敗経路・採用手順・制約を artifact より詳細に保存する。
> 現在有効な規範は `artifacts/development-environment-strategy/` が所有する。

### Worktree command contract

# Work Identity Worktree Command Contract 設計原本

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_source_log"
status: "artifactized_reference"
related_design: "WORK_IDENTITY_DESIGN_JP.md"
related_experiment: "WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md"
```

> Work Identity配下のGit worktree作成・診断・削除を、人間やAIが低レベルGit手順を直接組み立てずに扱えるようにするためのcommand contract設計原本。
> 実際のGit状態のsource of truthはGit自身であり、このcommandは新しい状態registryを作らない。

### Reference validation

# Work Identity Worktree Reference Implementation 検証記録

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_experiment_record"
status: "artifactized_reference"
related_contract: "WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md"
test_repository: "Daiki-Yoshida/test-git-track"
reference_merge_commit: "d584d3f110f8cc230b59af6c9f06860bd3e0b6fb"
tested_environment:
  os: "Linux on WSL2"
  git: "2.43.0"
  make: "GNU Make 4.3"
  bash: "5.2.21"
```

> Worktree public command contractを、project-owned参照実装として実装し、fresh cloneから実機検証した記録。
> 実装Shell/Makefile自体はartifact配布対象ではない。
> 正本artifactには、実装から得られた再利用可能なcontract/invariantだけを反映する。

---

## 既存 development-environment-strategy との関係

現在の artifact にある次の思想は維持する。

- host / data safety を最優先する
- Docker-first execution
- worktree は必要な場合だけ使用する
- shared cache / image を安全なら再利用する
- parallel writer は mutable state を分離する
- cleanup は deterministic / scoped にする
- destructive purge と通常cleanupを分離する
- Gitが履歴を所有する
- 単なる識別子の存在を理由に追加resourceを作らない

変更される中心概念は、従来複数箇所に分散していた作業単位・branch・worktree・runtime ownership を **Work Identity** へ統合することである。

artifact 化では、既存思想を壊さず、この共通軸を各文書の所有範囲へ分配する。

---

---

## artifact 化時の予定責務

このsource logをそのままartifactへコピーしない。

AIの認識・ルーティング・トークン効率を考慮し、既存文書のOwnershipへ再配置する。

想定:

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  future_content:
    - "Work Identity の WHY"
    - "Goal -> Work Identity -> environment ownership という基本モデル"
    - "Git は Work Identity の表現手段であり定義元ではない"
    - "Work Identity確定タイミングの原則"

WORKSPACE_STRUCTURE.md:
  future_content:
    - ".worktrees/<type>/<name>/ を Work Root とする構造"
    - "単一 / 複数 repository の統一形状"
    - "Work Documents と repository worktree の配置"
    - "Base Work Identity と repository派生identity"
    - "Project Root / ownership boundary"

ENVIRONMENT_STANDARDS.md:
  future_content:
    - "Work-scoped resource identity"
    - "Project / Work / Run scope"
    - "resource reuse / creation rules"
    - "Git / filesystem safe normalization"

ENVIRONMENT_WORKFLOW.md:
  future_content:
    - "Work Identity確認からcompletionまでのlifecycle"
    - "Work Documents creation / update / reconciliation"
    - "branch / worktree / runtime preparation"
    - "multi-repository completion semantics"
    - "cleanup / retained state"

INDEX.md:
  future_content:
    - "Work Identity routing"
    - "Work Root / Work Documentsへの入口"
```

この分割は artifact 化工程で再レビューする。

---

---

## artifact 化前に検証すべき事項

概念設計は確定しているが、少なくとも次は実装・artifact化前に技術検証する。

1. Project Repository が `.worktrees/**/documents/**` をtrackしながら、兄弟repository worktreeを安全にignoreできるGit設定。
2. 同一Project Repositoryのnested worktree内で、Project-level `.worktrees/` を再materializeしない方法。
3. sparse checkout を採用する場合、通常のbuild/test/editor操作への副作用。
4. `.worktrees/<type>/<name>/<repository>/` へのGit worktree生成・削除・pruneの安全な手順。
5. Work Documentsの削除とProject Documentsへのreconciliationを、Git履歴を壊さず行えること。

これらの結果によって実装手段は変わり得るが、Work Identity、Work Root、Work Documents、Project Repository ownershipという概念モデルは維持する。

---

## artifact反映対象

`WORKSPACE_STRUCTURE.md`:
- recursive materialization invariantを実装済みcontractへ昇格
- tracking ownershipとmaterializationの区別
- non-cone `/*` + `!/.worktrees/`
- creation/recreationごとのworktree-local sparse policy

`ENVIRONMENT_WORKFLOW.md`:
- worktree creationをatomic project-owned operationとして扱う
- `--no-checkout → sparse-checkout set → reset --hard HEAD`
- create後のPrimary/Nested invariant check
- recreateでも同じprocedure
- raw `git worktree add` を標準Work Root作成手順にしない

`ENVIRONMENT_STANDARDS.md`:
- supported Git versionでworktree-local sparse checkoutを保証
- low-level multi-step setupをproject-owned helperでencapsulate
- diagnosticsでmaterialization状態を確認可能にする

---

## artifact反映方針

```yaml
ENVIRONMENT_STANDARDS.md:
  - "public worktree-create/status/remove semantic contract"
  - "required inputs and deterministic resolution"
  - "idempotency, fail-closed, no custom state registry"
WORKSPACE_STRUCTURE.md:
  - "REPO selector maps to Work Root child directory/repository"
  - "path/branch derivation relationship"
ENVIRONMENT_WORKFLOW.md:
  - "create preflight -> create -> postcondition -> rollback"
  - "remove lifecycle boundary"
  - "routine caller does not execute low-level Git sequence"
INDEX.md:
  - "routing for worktree command contract"
```

---

## artifactへ反映する知見

### ENVIRONMENT_STANDARDS.md

- base refとupstreamは別contract
- missing Work branchをbaseから作るだけならbase branchを自動upstreamにしない
- same-name remote Work branchのtrackingは明示的policyとして別扱い
- project-level helperはProject Rootをstable/explicitに解決し、linked worktreeを偶然Project Rootとして扱わない

### ENVIRONMENT_WORKFLOW.md

- missing branch作成時にbase resolution後、upstream policyも明示的に決める
- Primary checkout限定、または同等に安全なexplicit Project Root resolutionを要求
- create postconditionにbranch/upstream semanticsを含める場合はproject policyに従う

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md`
