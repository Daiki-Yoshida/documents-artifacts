# Source record: 2026-08-02-task-resource-reconciliation-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/development-environment-strategy"
source_commit: "184f9092ca199633d3842e482564858f009c452c"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/commit/184f9092ca199633d3842e482564858f009c452c"
source_author_date: "2026-08-02T17:42:02Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
docs: task-scoped resourceの終了責任を明確化

* docs: task-scoped resourceの終了責任を明記

* docs: task-scoped resource終了責任の日本語版を同期
~~~~

## GitHub API patch snapshot

### `artifacts/ENVIRONMENT_WORKFLOW.md`

~~~~diff
@@ -192,13 +192,25 @@ This strategy does not decide pull-request approval or release policy.
 
 ## 5. Cleanup
 
+Creating task-scoped resources creates an obligation to reconcile them when the task ends.
+
+```yaml
+completion_state:
+  removed: "the resource is no longer needed and was removed through normal, scoped cleanup"
+  intentionally_retained: "the resource is still needed for a concrete follow-up; report the resource and reason"
+rule: "Unowned or unexplained residual resources are not an acceptable completion state."
+```
+
+Shared resources and persistent data are not task-cleanup targets merely because a task used them. Destructive cleanup remains governed by the purge rules below.
+
 ### No Worktree Was Created
 
 When the task used the current or Primary Checkout:
 
 - do not run worktree cleanup;
 - preserve the task branch according to project policy;
-- stop or remove only task-specific runtime resources that were actually created;
+- reconcile every task-scoped runtime resource that was actually created;
+- remove resources that are no longer needed, or report intentionally retained resources and why they remain;
 - return the checkout to the expected branch only when the project workflow requires it.
 
 ### Normal Worktree Removal
@@ -212,14 +224,17 @@ When a Task Worktree was created, normal removal must:
 5. stop and remove task-scoped runtime resources;
 6. remove the Git worktree without force;
 7. prune stale metadata only when appropriate;
-8. report what remains, including the branch.
+8. report what remains, including the branch;
+9. report any intentionally retained task-scoped resources and why they remain.
 
 ### Destructive Purge
 
 A purge may discard work or persistent state. It must be a separate explicit operation and must report its scope before or immediately after execution according to the project's confirmation policy.
 
 Never combine branch deletion, worktree force removal, database deletion, and shared-cache deletion into one vague cleanup operation.
 
+Cleanup is complete only when every task-scoped resource is removed or intentionally retained with a stated reason. Unexpected residual resources must be reported rather than ignored.
+
 ## 6. Diagnosis and Recovery
 
 When an environment operation fails, inspect in this order:
~~~~
