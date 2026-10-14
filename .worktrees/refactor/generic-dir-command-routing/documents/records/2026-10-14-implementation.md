# Generic DIR command routing — implementation checkpoint

Work: `refactor/generic-dir-command-routing`
Record date: 2026-10-14
Actor: ChatGPT / GitHub repository API
Related: [Issue #209](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209), [source PR #210](https://github.com/Daiki-Yoshida/documents-artifacts/pull/210)
Phase: Work active; implementation prepared for review, not integrated to `main`

## Context / decision

The user delegated Work Identity selection and authorized proceeding. Chosen identity: `refactor/generic-dir-command-routing`. A dedicated bounded Knowledge source Bundle records the selection and its antecedent review under `documents/knowledge/records/2026-10-14-generic-dir-implementation-adoption/`; prior source events remain unchanged.

Adopt the two-layer command design: user-facing `DIR` is a path locator, and each public operation validates and interprets the directory as its intended target. An operation may derive internal Work Identity and stable Repository Selector without making them mandatory public inputs. Keep worktree/Git/authority guards and the same Work-scoped Docker Resource Identity across up/status/down/cleanup.

## Changes authored

- `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md`: generic `DIR`, command-owned target semantics, path normalization, creation-vs-existing target conditions, helper resolution, scope and shell completion motivation.
- `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md`: validated canonical worktree path as public locator, internal Work/REPO resolution, Worktree create/status/remove safety and single/multi-repository ambiguity.
- `artifacts/execution/COMMANDS_AND_CI.md`, `artifacts/project/WORKTREES.md`: corresponding concise runtime projection, same existing router paths.
- `tests/test-generic-dir-targeting.sh`: deterministic, self-contained simulation of `docker-up/status/down` Work scoping, repository-specific test, existing/nonexisting generation targets, and missing-worktree-target preflight. Includes refusal for traversal, external paths, symlinks, unknown Work, repository mismatch and ambiguous targets. Does not launch Docker or create real Git worktrees.
- `tests/test-agent-harness.sh`: run the new deterministic test as a focused preliminary gate.
- `tests/INDEX.md`: register the new test.

## Verification observed

- GitHub returned the same blob hash for `tests/test-generic-dir-targeting.sh` as the exact local copy: `66b709dd22b60ed729c4710e671bd1a4e146ec2f`.
- Local `bash -n` on this exact test script: PASS.
- Local `bash tests/test-generic-dir-targeting.sh` against its self-contained sandbox: **PASS** (output: `PASS: generic DIR command routing, creation targets, and scoped identities (simulated)`).
- GitHub readback / tree scan: all seven inline Markdown Artifact refs in the changed runtime leaves resolve; no broken routes among those inspected.
- Static source compare against source PR #210: expected changes limited to the new implementation source Bundle, two Knowledge subjects, two Artifact leaves, and test files.

## Limits / next gates

- No complete source checkout with the repository's historical tests exists in this GitHub-API session. The full `bash tests/test-knowledge-integrity.sh`, `bash tests/test-artifacts.sh`, and `bash tests/test-agent-harness.sh` suites were **NOT RUN**. The new script's local isolated test is not an equivalent replacement for those suites.
- No actual Docker daemon operations, live Git worktree create/status/remove, or fresh independent agent behavior evaluation were performed. The fixture verifies path routing decisions in a simulation and planned candidate preflight only.
- GitHub Actions, external CI / paid runners, target-project synchronization, and `main` merge were not executed.
- Work-scoped real WSL worktree was not materialized by this API-only session; the Work has no created Docker/WSL runtime state requiring teardown. GitHub branch and Work Documents are intentionally retained for review.
- Before integration: independent review of changed canonical semantics / projection; full local repository suites on authorized checkout; review PR #210 source preservation and stack order; validate actual Git worktree handling when a real implementation adopts this public interface.
