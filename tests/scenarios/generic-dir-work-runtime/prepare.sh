#!/usr/bin/env bash
# Prepare hook for generic-dir-work-runtime.
# Runs after the Artifact install commit with $TARGET pointing at the
# generated repository. Materializes the two confirmed Works' Work Roots
# — tracked Work Documents plus a registered `main` repository checkout
# each — and adds the Project Root entry documents. The entry documents
# describe project topology and routing only: they name no command-line
# parameter and no Make target for the Work runtime, so the public
# interface shape stays the blind variable (Issue #209).
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated repository" >&2
  exit 1
}

# Ignore boundary: linked checkouts under the Work Roots are independent
# Git state and are never tracked; Work Documents and the coordination
# file remain tracked by this repository.
cat > "$TARGET/.gitignore" <<'EOF'
# Work worktree checkouts are independent Git state — never tracked here.
# Tracked Work Documents and the coordination file are not ignored.
.worktrees/*/*/*
!.worktrees/*/*/documents/
!.worktrees/*/*/documents/**
EOF

mkdir -p "$TARGET/.worktrees/feat/schema-preview/documents" \
         "$TARGET/.worktrees/feat/other-work/documents" \
         "$TARGET/documents/project"

cat > "$TARGET/.worktrees/PROJECT_COORDINATION.md" <<'EOF'
# Project Coordination

Tracked project-level coordination state for `.worktrees/`. This file is
shared project state owned by the primary repository. It must not be
materialized recursively inside a linked Work worktree.
EOF

cat > "$TARGET/.worktrees/feat/schema-preview/documents/WORK.md" <<'EOF'
# feat/schema-preview

Confirmed Work identity for a DB schema/preview-data experiment on this
service.

## Intent

- Run the project in parallel with the default runtime.
- Mutable DB state used by the experiment must not be shared with the
  default runtime.
- The host port must not collide with the default runtime's port.

## Status

- Work Identity confirmed by the user.
- Parallel runtime support not implemented yet.
EOF

cat > "$TARGET/.worktrees/feat/other-work/documents/WORK.md" <<'EOF'
# feat/other-work

Confirmed Work identity for follow-up feature work on this service.

## Intent

- Same parallel-runtime need as the other confirmed Work: an isolated
  runtime that can run alongside the default runtime without sharing
  mutable state or colliding on the host port.

## Status

- Work Identity confirmed by the user.
- Parallel runtime support not implemented yet.
EOF

cat > "$TARGET/AGENTS.md" <<'EOF'
# Project-local instructions

- This repository root is the Management Root Repository and the
  development entry point for this Project. Keep sessions rooted here.
- Read `documents/INDEX.md` before project engineering changes.
- Confirmed Works keep a Work Root under `.worktrees/` owned by this
  repository: tracked `documents/` plus the Work's checkout of this
  repository.
EOF

cat > "$TARGET/documents/INDEX.md" <<'EOF'
# Documentation Index

Routes durable project knowledge to its owning document.

| Question | Owner |
|---|---|
| Development entry point, environment boundary, Work topology | `project/DEVELOPMENT.md` |

For reusable guidance, begin at `artifacts/INDEX.md` and read only the
documents relevant to the task.
EOF

cat > "$TARGET/documents/project/DEVELOPMENT.md" <<'EOF'
# Development and Runtime Topology

The repository root is the Project Root and the AI development session
root. Routine operations are exposed through the root `Makefile`; keep
complex logic in project-owned scripts rather than recipes.

## Environment boundary

- Host provides Git, Docker/Compose, and Make only.
- Node, npm, and project commands run inside the managed `app`
  container. Host Node/npm is not part of this project's execution
  model.

## Repositories and Works

- This repository is the single Management Root Repository; the stable
  repository selector is `main`.
- A confirmed Work Identity maps to a branch of the same name.
- Each confirmed Work has a Work Root at
  `.worktrees/<work-type>/<work-name>/` containing its tracked
  `documents/` and the Work's `main` checkout of this repository.
- Currently confirmed Works: `feat/schema-preview`, `feat/other-work`.

## Runtime operations

The public command surface covers the default runtime only (see
`README.md`). Parallel per-Work runtimes are not implemented yet; how a
caller designates the target Work is an open interface decision.

Runtime resource facts and the project-owned resource policy module are
described in `README.md` and `scripts/resource-identity.js`.
EOF

git -C "$TARGET" add -A
git -C "$TARGET" commit -qm \
  "test: confirmed Work Roots, Work Documents, and entry documents"

# Registered `main` checkouts for the confirmed Works, materialized
# through the documented canonical sequence (no-checkout + worktree-local
# sparse exclusion + reset) so nested `.worktrees/` stays absent.
for work in schema-preview other-work; do
  git -C "$TARGET" branch "feat/$work"
  git -C "$TARGET" worktree add --no-checkout -q \
    "$TARGET/.worktrees/feat/$work/main" "feat/$work"
  git -C "$TARGET/.worktrees/feat/$work/main" \
    sparse-checkout set --no-cone '/*' '!/.worktrees/' >/dev/null
  git -C "$TARGET/.worktrees/feat/$work/main" reset -q --hard HEAD
done
