# Work Lifecycle and Resources

Read this when deciding when a Work is complete, what resources belong to it, or what must be reconciled/cleaned.

## Lifecycle

```text
goal established
  → design/discussion
  → Work Identity confirmed
  → Work Documents
  → branch/checkout/optional worktree
  → required work-scoped runtime
  → implementation
  → verification
  → integration
  → reconcile durable Work Documents into current Project Documentation
  → finalize lightweight Work Records
  → transfer Records to Project-owned historical archive and verify preservation
  → reconcile/clean remaining Work Documents and work-scoped resources
  → Work complete
```

A merged branch in one repository does not necessarily complete a multi-repository Work.

## Resource scopes

**Project-scoped** — safely shared and longer-lived than one Work, e.g. immutable caches/shared images where appropriate.

**Work-scoped** — owned by one Work, e.g. branch, optional worktree, isolated mutable runtime/database, required port allocation, logs, Work Documents, work outputs.

**Run-scoped** — one command/test execution. It is still ownership-wise under the Work; do not create a new Work Identity for every run.

## Do not clone everything per Work

Work Identity is not a reason to create:

- a new image for every Work;
- duplicate caches/networks/volumes without isolation need;
- a worktree for every task;
- a separate state database just for management.

Reuse safe Project-scoped state. Isolate only when mutable state, parallelism, configuration, or project rules require it.

When a subsystem needs Work-specific isolation, propagate a deterministic identity such as:

```text
project + optional component + Work Identity + resource role
```

to containers, mutable volumes, networks, ports, test databases, logs, or generated outputs as appropriate. Do not use random per-run identity when the resource belongs to the Work.

A Work-scoped resource is not identified only at creation time. The same resolved scope/identity/configuration must target that resource through:

```text
create/start
→ inspect/verify
→ stop
→ cleanup
```

A teardown that resolves a different identity — e.g. drops the scoped configuration and falls back to defaults — can act on the wrong resource set, even when the create path looked correct.

## Completion state for work-scoped resources

Every actually-created Work-scoped resource must end as one of:

```yaml
removed:
  meaning: "No longer needed and removed through scoped cleanup."

intentionally_retained:
  meaning: "Kept for a concrete follow-up use; resource and reason are reported."
```

An unexplained leftover with unknown owner/purpose is not a valid completion state.

Do not delete shared/persistent resources merely because the Work used them.

## Work Documents completion and historical Work Records

Reconcile confirmed durable design, constraints and decisions into their current Project Documentation owners. Work-only hypotheses, scratch and execution logs may be dropped when no longer needed.

Work Records (see `WORK_IDENTITY.md`) preserve the **development process** rather than define current project truth. At Work completion:

1. Verify the Work-wide requested outcome, integration, relevant checks and unresolved issues (including all participating repositories).
2. Reconcile durable current knowledge into the owning Project Documentation.
3. Close the Work Records with a brief outcome, remaining items and available Issue/PR/commit evidence.
4. Transfer the Records alone to `documents/archive/works/<work-type>/<work-name>/records/` under the Management Root Repository, preserving content, identity and relevant references.
5. Verify the destination and authorized Git preservation/publication, then safely reconcile and clean remaining Work Documents and Work-owned resources.

The archive is historical, normally excluded from everyday AI reading and **not** a current design authority. The rest of the Work Documents are not archived wholesale. Git remains the version-history mechanism; no extra history database or manual version registry is needed.

If the destination is already occupied — by unrelated content or earlier Records of the same Work Identity — investigate without overwriting. If symlink/ownership boundaries are unclear, or archival or authorized publication fails, keep the original Records and treat Work closeout as **pending**. Never overwrite existing archived history or delete the source before preservation is confirmed. Record the outcome and use the project's existing VCS and destructive-operation authorization gates.
