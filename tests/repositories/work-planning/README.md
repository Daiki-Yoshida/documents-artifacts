# Audit Fixture App

Small application fixture used for isolated feature work.

## Work environments

`scripts/materialize-work.sh <work-identity>` materializes an isolated work
environment for a given work identity:

- `.worktrees/<work-identity>/` — worktree/scratch state for the work item
- `.runtime/<work-identity>/` — runtime state for the work item

The script only creates fixture-local marker directories. It does not modify
anything outside this repository.
