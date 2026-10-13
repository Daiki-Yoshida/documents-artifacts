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
- authorityが無い場合は、Work Documentsを許可されたManagement Root Repository working state等へ保持し、baseline publicationがpendingであることをreportする。
- 未commit / 未mergeなのに「Project baselineへ反映済み」と報告しない。

これにより、Work IdentityはWork Documentsのownership/lifecycleを所有し、engineering-operationはそのGit publication authorityを所有する。

## 長時間Workにおける記録の保存と公開

Work Identityを持つ作業では、重要な発見・判断・問題解決・検証・引継ぎや中断の区切りで、`../work-identity/S003_WORK_DOCUMENTS.md` の軽量なWork Recordsを適宜更新する。実装が長く続く場合にも、最終報告だけに頼らず途中の判断や未解決事項を短く保存する。

記録は自由なMarkdownでよく、作業内容、必要な判断理由、重要な問題と対応、確認済みの結果・残課題を中心とする。詳細な操作ログ・全文会話・固定長の証拠表を一般義務にしない。他の作業主体の報告、推測、直接確認した事実を混同しない。

**file write / commit / remote push / Project baseline publication は独立した段階**であり、記録義務やWork Identity確定はVCS権限を付与しない。保存先の所有者はManagement Root Repositoryである。権限内で保存できる情報を保全し、Gitに保存・公開できない場合はpendingとして正確に報告する。

Work Recordsの配置・Archiveの意味は`../work-identity/`、最終正本へのreconciliationは`../documentation/`が所有する。特定のエージェント構成や外部実行サービスはこの規約の前提としない。

---

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

- `../../records/2026-10-13-work-records-implementation-adoption/`

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
