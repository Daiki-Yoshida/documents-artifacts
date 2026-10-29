# Project rules

This is the Management Root Repository. `game/` is a separate Component
Repository with its own Git history; the two repositories participate in the
same `feat/combat-revision` Work.

The Management Root `main` branch is the project coordination baseline.
Active Work Documents at `.worktrees/<type>/<name>/documents/` are tracked
there. For this test, one **local commit directly to Management `main`**
recording the requested Work Documents coordination checkpoint is authorized.
No push, PR merge, or other remote mutation is authorized.

The Component's `feat/combat-revision` implementation branch stays independent
and unchanged. A separate Management branch is needed for changes to this
Management Root's own tooling/behavior/contracts requiring isolation or review,
not for this ordinary Work Documents checkpoint.

Start from `documents/INDEX.md`, route to the installed Artifact index, and
read only relevant guidance. Follow the project's `make verify` gate.
