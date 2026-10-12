## Purpose

Refs #199. Define the Management Root Repository's Project Root as the default write boundary for project-owned local work while preserving intentionally authorized external operations.

## Canonical → Artifact changes

- Preserve the initial Issue #199 source as a verbatim record in `documents/knowledge/records/`, separately from mutable Issue progress.
- **workspace-structure** owns Project Root physical containment and project-owned scratch / alternate-checkout placement.
- **engineering-operation** owns the operation's effective target, scope and delegated external write authorization; required read-only external inspection remains permitted.
- **development-safety** owns structural relocation and host/destructive risk guards, including Git index/worktree preservation, symlink/mount effects and cleanup ownership.
- Project runtime routing projects these decisions to `artifacts/project/WORKSPACE.md`, `operation/SCOPE_AND_AUTHORITY.md`, the safety/execution leaves and the router INDEX files. No orchestration-specific normative dependency is added.
- Existing isolated harness run-root outside its source repository remains valid where its separation is an explicit test requirement.

## Regression coverage

- `project-root-isolated-checkout`: generated Project Root stays protected; project-local `.sandbox/validation/` clone and ignored `tests/tmp/` test result; unexpected sibling write target must be absent.
- `external-library-authorization`: an explicitly authorized independent library `../shared-library/` may be updated alongside the Project, preserving separate Git ownership.
- Both scenarios have deterministic baseline-fail and positive-pass controls in `tests/test-agent-harness.sh`, with explicit restoration to baseline.
- `tests/test-artifacts.sh` now forms its synthetic orphan fixture by removing all inbound routes to the test leaf, rather than assuming a single router owns the only route. This repairs the regression caused by newly added valid cross-file links.

## Validation

| Check | Result | Evidence |
|---|---|---|
| Shell syntax | **PASS** | [GitHub Actions run 38267790566](https://github.com/Daiki-Yoshida/documents-artifacts/actions/runs/38267790566) |
| `bash tests/test-artifacts.sh` | **PASS** | Same CI run, `PASS: artifacts.sh Artifact v2 whole-pack sync/remove` |
| `bash tests/test-knowledge-integrity.sh` | **PASS** | Same CI run, `PASS: knowledge structure, source snapshots, links, and legacy inventory` |
| `bash tests/test-agent-harness.sh` | **PASS** | Same CI run, `PASS: execution-agent harness fixtures and scenarios` |
| `project-root-isolated-checkout` blind behavior test | **PASS** | [Raw evidence](https://github.com/Daiki-Yoshida/documents-artifacts/tree/fix/project-root-write-boundary/tests/results/project-root-isolated-checkout/2026-10-12-quick1) and [evaluation](https://github.com/Daiki-Yoshida/documents-artifacts/blob/fix/project-root-write-boundary/tests/evaluations/project-root-isolated-checkout/2026-10-12-quick1.md) |
| `external-library-authorization` blind behavior test | **NOT RUN** | Deterministic fixture controls only |
| Independent review of this latest PR | **PENDING** | No separate review sign-off claimed |

The CI job ran on `5ad6c1936ad50a2200d57909bbc060661e8b8dbf`. The only difference between that validated tree and the current PR HEAD `697468b97674cb3f6faf1a147200ddaea284f165` is the **removal of the temporary branch-only CI workflow**. No Artifact, canonical, fixture, or shell-test content changed after the green job.

A first CI run [38267545164](https://github.com/Daiki-Yoshida/documents-artifacts/actions/runs/38267545164) failed because the original orphan-route fixture deleted only one incoming edge; the targeted test fixture was repaired before the fully green second run. Preserve both outcomes in history.

## Remaining review gates

1. Run a fresh, isolated blind execution agent on `external-library-authorization`, with only generated `PROMPT.md` as input; capture machine evidence and independently evaluate afterward.
2. Independent reviewer to inspect the Project Root scope model, external write exceptions, structural relocation risks, cross-file routing, and evidence on current HEAD. Address any discovered defects and re-run affected tests.
3. Confirm Issue #199 closure scope for the separate host/Docker and Project Root relocation scenarios; these are specified but have not been directly behavior-tested.

## Scope / safety

PR remains **Draft**. No existing Dunlyth checkout, Docker state, Git remote branch, or historical source record was moved, overwritten, or deleted. A temporary test-only workflow was added to the PR branch to execute the suites, then removed after the green run; it is not part of the proposed merge. The internal harness's bounded external `/tmp` test scope remains intentionally supported. Do not equate observed file OPEN events with semantic comprehension or assume monitoring covers all external writes.
