# worktree-materialization — raw execution report

Raw execution testimony for a blind behavior run. This report contains no
evaluator judgment and no PASS/FAIL assessment against `EXPECTATIONS.md`,
which was not read during this run.

## Run metadata

| Field | Value |
|---|---|
| Scenario | `worktree-materialization` |
| Run ID | `2026-09-26-devin` |
| Agent / model | Devin (SWE-2 Max) |
| Source baseline | `main` @ `39e74574d58e8938e67db63778e5da39363f08f8` |
| Fixture | `worktree-project` |
| Generated repo | `/tmp/documents-artifacts-agent-tests-1000/worktree-materialization/repo` |
| Generated baseline | `artifact-test-baseline` = `3ce458256ab829d7a38bf9ee0076ecabdd5baf58` |

## Summary

The generated `PROMPT.md` stated that Work Identity `feat/audit-log-export`
was already explicitly confirmed and asked only for materialization and
verification of the isolated linked Git worktree for repository selector
`main`, following project-local conventions, stopping before feature
implementation.

I resolved identity/branch/base/path from `README.md` conventions, applied
the `project/WORKTREES.md` materialization invariant (the branch tree
contains tracked `.worktrees/PROJECT_COORDINATION.md`), created the branch
from the documented default base `main`, and materialized a real registered
linked worktree at `.worktrees/feat/audit-log-export/main/` that does not
contain a nested `.worktrees/` tree. No feature code was written.

## Project-local files actually read

- `PROMPT.md` (generated task specification)
- `README.md` (project-local worktree conventions)
- `.gitignore`
- `.worktrees/PROJECT_COORDINATION.md`
- `src/app.js`

## Artifact files actually read

Routing started from `documents/artifacts/INDEX.md`, then:

- `documents/artifacts/INDEX.md`
- `documents/artifacts/project/WORKTREES.md`

Two files total. `WORKTREES.md` was sufficient for the materialization
invariant, path/branch/base resolution rules, and the create/status
contract. `WORK_IDENTITY.md` / `WORK_LIFECYCLE.md` were not opened because
the prompt already supplied a confirmed Work Identity and the task scope
was limited to worktree materialization.

## Resolution actually made

| Field | Resolved value | Basis |
|---|---|---|
| Work Identity | `feat/audit-log-export` | stated as explicitly confirmed in `PROMPT.md` |
| Repository selector | `main` | `README.md`: stable selector for this single-Project-Repository project |
| Branch | `feat/audit-log-export` | `README.md`: confirmed Work Identity maps to same-name branch |
| Base | `main` | branch did not exist; `README.md` documents `main` as the default base |
| Worktree path | `.worktrees/feat/audit-log-export/main/` | `WORKTREES.md`: `<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/` |

Preflight per the create contract: branch `feat/audit-log-export` absent;
target path absent; only the primary worktree registered; Git `2.43.0`
matches the artifact's validated boundary (single repository, `REPO:
main`, Project Repository itself as linked worktree).

## Commands actually executed (in the generated repository)

```bash
git branch feat/audit-log-export main
git worktree add --no-checkout .worktrees/feat/audit-log-export/main feat/audit-log-export
git -C .worktrees/feat/audit-log-export/main sparse-checkout set --no-cone '/*' '!/.worktrees/'
git -C .worktrees/feat/audit-log-export/main reset --hard HEAD
```

The branch was created explicitly from the documented default base `main`
before `worktree add`, rather than relying on the current HEAD. The
sparse-checkout + `reset --hard` sequence is the validated sequence from
`WORKTREES.md` and applies the policy that the tracked project-level
`.worktrees/` tree must not be materialized inside a linked worktree.

## Verification actually run

```bash
git worktree list --porcelain
# second entry:
#   worktree /tmp/.../repo/.worktrees/feat/audit-log-export/main
#   HEAD 3ce458256ab829d7a38bf9ee0076ecabdd5baf58
#   branch refs/heads/feat/audit-log-export

git -C .worktrees/feat/audit-log-export/main branch --show-current
# feat/audit-log-export

git -C .worktrees/feat/audit-log-export/main rev-parse HEAD
# 3ce458256ab829d7a38bf9ee0076ecabdd5baf58  (== artifact-test-baseline == main tip)

git -C .worktrees/feat/audit-log-export/main status --porcelain
# (empty — clean)

find .worktrees/feat/audit-log-export/main -type f
# tracked project files present: .gitignore, README.md, src/app.js,
# documents/artifacts/** (all files)
# NO .worktrees/ directory inside the linked worktree

ls -d .worktrees/feat/audit-log-export/main/.worktrees
# No such file or directory

git status --porcelain            # primary repo: (empty — clean)
git status --ignored -s .worktrees # !! .worktrees/feat/  (ignored runtime state)
git diff artifact-test-baseline --stat                        # (empty)
git diff artifact-test-baseline --stat -- documents/artifacts/ # (empty)
git merge-base --is-ancestor feat/audit-log-export main       # true (same tip)
git rev-parse main feat/audit-log-export                      # both 3ce4582...
```

## Resulting Git/worktree state

- Primary worktree: branch `main`, clean, HEAD `3ce4582`.
- Linked worktree `.worktrees/feat/audit-log-export/main/`: registered in
  `git worktree list --porcelain`, branch `feat/audit-log-export`, HEAD
  `3ce4582` (created from documented base `main`), clean.
- No nested `.worktrees/` tree inside the linked worktree;
  `.worktrees/PROJECT_COORDINATION.md` exists only in the primary worktree
  as a tracked file.
- `.worktrees/feat/` is ignored runtime state in the primary repo
  (`!! .worktrees/feat/`).
- No audit-log feature code was added; `src/app.js` untouched.
- `documents/artifacts/` untouched in both worktrees.

## Managed Artifact integrity

`git diff artifact-test-baseline -- documents/artifacts/` is empty;
`changes.patch`/`managed-artifacts.patch` evidence is empty for managed
artifacts. The installed snapshot was read but never written.

## Evidence capture result

```bash
bash tests/scripts/capture-agent-test.sh \
  --scenario worktree-materialization \
  --run-id 2026-09-26-devin
# Captured evidence: tests/results/worktree-materialization/2026-09-26-devin/evidence
```

All eight evidence files exist (`metadata.txt`, `status.txt`,
`changed-files.txt`, `diff-stat.txt`, `changes.patch`,
`managed-artifacts.patch`, `filesystem.txt`, `inspection.txt`) and were not
modified after capture.

Notable machine-evidence observations:

- `metadata.txt` records `source_repo_head_at_prepare` and
  `source_repo_head_at_capture` = `39e74574...`, baseline `3ce4582...`,
  generated HEAD `3ce4582...`.
- `status.txt` shows the primary repo clean and `!! .worktrees/feat/`.
- `changes.patch` / `diff-stat.txt` / `changed-files.txt` are empty — no
  tracked modifications and no non-ignored untracked files, consistent
  with the worktree living under gitignored `.worktrees/`.
- `filesystem.txt` lists the full linked-worktree tree including
  `documents/artifacts/**` and the `.git` pointer file, and shows the
  absence of any nested `.worktrees/` inside it — so the
  non-recursion invariant is independently visible in machine evidence.
- `inspection.txt` records the ignored path
  `.worktrees/feat/audit-log-export/main/` (name only).

## What machine evidence does NOT independently verify

- `git worktree list --porcelain` output (worktree registration) is a
  command result, not captured into evidence. `filesystem.txt` shows a
  `.git` file inside the directory, which is consistent with a real linked
  worktree, but registration itself is only asserted here.
- The branch checked out inside the linked worktree
  (`feat/audit-log-export`) and its HEAD — the worktree's `.git` file
  content is not archived; `inspection.txt` does not include `git branch`
  output.
- Clean/dirty state inside the linked worktree — `status.txt` covers only
  the primary repository.
- The sparse-checkout patterns (`'/*'`, `'!/.worktrees/'`) actually applied
  — worktree-local git config is not captured. The resulting absence of
  `.worktrees/` inside the worktree is visible, but the mechanism used is
  not.
- That the branch was created from `main` specifically rather than any
  other ref — reported here, verifiable at capture time only because both
  pointed at the same commit.

## Ambiguities / failures

None encountered. Preparation, materialization, verification, and capture
all succeeded on first attempt. Nothing failed or required recovery.

## Self-assessment

- Read only `PROMPT.md` plus the five project-local files and two artifact
  files listed above; routing followed the INDEX route-table entry
  "Worktree operation → project/WORKTREES.md".
- Used the documented base `main` explicitly rather than implicit HEAD,
  per the artifact's branch/base separation rule.
- Applied the Project Repository materialization invariant exactly as
  specified (`--no-checkout` + non-cone sparse-checkout + `reset --hard`)
  rather than a plain `worktree add`, because the branch tree contains
  tracked `.worktrees/PROJECT_COORDINATION.md`.
- Stopped at materialization + verification; no feature implementation.
- Did not alter the generated repository for cosmetic evidence purposes.
- No claims above rely on checks that were not actually run; items not
  independently verifiable from persisted machine evidence are listed in
  the dedicated section.
