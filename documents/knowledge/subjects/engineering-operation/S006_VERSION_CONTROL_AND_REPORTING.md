# Version Control and Reporting

## Commit / push authority

旧sourceで明示されたdefault:

```yaml
commit_push: "userが求めるまで行わない"
default_branch: "implementation source changeのcommitが必要なら、project-local workflowの例外がない限りdefault/baseline branch上で直接実装commitせずWork branch等を用意する"
confirmation: "変更・verification・reporting後、必要ならcommitするか確認する"
```

この規則はengineering changeのversion-control authorityを扱う。Git repositoryの静的ownershipは `../workspace-structure/`、Work-specific branch/worktree lifecycleは `../work-identity/` が主所有する。

project-local workflowがより具体的にcommit authorityを定める場合は、その明示規則を優先する。

## Work Documents baseline publicationとの境界

`../work-identity/S003_WORK_DOCUMENTS.md` が定める「Work DocumentsをProject baselineから確認可能にする」ことはlifecycle上のdesired stateであり、この文書のcommit / push / merge authorityを上書きしない。

- Work Identityの確認だけでbaseline branchへのcommit権限が生じるわけではない。
- project-local workflowがcoordination/documentation commitやPR/merge経路を明示している場合は、その経路でbaseline-visible stateを成立させてよい。
- authorityが無い場合は、Work Documentsを許可されたProject Repository working state等へ保持し、baseline publicationがpendingであることをreportする。
- 未commit / 未mergeなのに「Project baselineへ反映済み」と報告しない。

これにより、Work IdentityはWork Documentsのownership/lifecycleを所有し、engineering-operationはそのGit publication authorityを所有する。

## Reporting

final reportは、少なくともtask判断に必要な事実を伝える。

- 何を変更したか
- なぜ変更したか
- public contract等への影響
- verification結果
- 未実施・失敗した確認
- 意図的に残したtask/work resourceや残課題

旧sourceの固定的なthinking/interim languageはcurrent product/sessionへ一般化しない。final responseはuser/contextに適した言語を使う。

## Sources

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
