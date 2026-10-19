# Generic DIR command routing — integration and archive handoff

Work Identity: `refactor/generic-dir-command-routing`  
Recorded date: 2026-10-19  
Related: [Issue #209](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209), [PR #210](https://github.com/Daiki-Yoshida/documents-artifacts/pull/210), [PR #211](https://github.com/Daiki-Yoshida/documents-artifacts/pull/211), [PR #212](https://github.com/Daiki-Yoshida/documents-artifacts/pull/212)  
Status at writing: implementation and integrated-HEAD verification complete; historical Work Records archive proposed; Work resource reconciliation and Issue close **pending**

## Outcome and current owners

- **Source preservation:** PR #210 merged with `a548669b2cee12362567e4753dab00ac94d6cf17`; the original rationale and adoption records remain under `documents/knowledge/records/`. They are historical inputs, not a second current authority.
- **Canonical contract:** PR #211 merged with `d7396d514781678750296245dc4908070dee80d6`. The current `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md` and `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md` own the reusable contract. Public `DIR=<directory-path>` is a path locator; each operation validates/interprets the target and derives Work/Repository/Runtime identity internally as needed. Git/worktree ownership and destructive-safety constraints remain in force.
- **Artifact projection:** `artifacts/execution/COMMANDS_AND_CI.md` and `artifacts/project/WORKTREES.md` express that contract. The run2-verified `COMMANDS_AND_CI.md` blob is `7f1fccb5ba8a8586a4af47cd541387cf0974de5f`. This closeout adds no new normative Artifact or Knowledge rules.
- **Behavioral test:** PR #212 merged with `d82773f7e98f99aefd49cec34993a902c2bbb124`. `generic-dir-work-runtime` run1 (`2026-10-15-run1`) was INVALID / NOT_EVALUATED because its prepared fixture had the old Artifact. Run2 (`2026-10-15-run2`) used the correct Artifact and received an independent **PASS**: all eight primary dimensions passed, including the directory-valued public selector and internal Work identity derivation. The raw evidence, original REPORT, and evaluator result remain under `tests/results/generic-dir-work-runtime/` and `tests/evaluations/generic-dir-work-runtime/2026-10-15-run2.md`.
- **Merged-head verification:** On `main` `d82773f7e98f99aefd49cec34993a902c2bbb124`, WSL Devin reported all three actual shell suites PASS (exit 0): `tests/test-knowledge-integrity.sh`, `tests/test-artifacts.sh` (live GitHub bootstrap verified, no SKIP), and `tests/test-agent-harness.sh`. The result is recorded in [Issue #209 comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209#issuecomment-6257906239). These are reported WSL execution results, not shell commands rerun in the GitHub API session.

## Historical Work Records transfer

The prior checkpoint `2026-10-14-implementation.md` belongs to this Work but describes an earlier state (when integration was still pending). Preserve that file **byte-for-byte** under:

`documents/archive/works/refactor/generic-dir-command-routing/records/2026-10-14-implementation.md`

Its Git blob must remain `82cdc3c33e51c21f7024db5f76fe0bc3e98cdfb3`, exactly matching the former tracked path:

`.worktrees/refactor/generic-dir-command-routing/documents/records/2026-10-14-implementation.md`

This new handoff record documents subsequent integration and validation; neither record is current normative guidance. The archive becomes Project-baseline-published only once its dedicated PR merges and the resulting tree is verified.

## Boundaries and remaining closeout work

- **Archive publication:** This record is written for the dedicated archive PR. Until merge, do not treat the remote `main` Archive migration as complete.
- **Work resource inventory:** Confirm the actual local Git worktree registrations and any Work-owned branch, checkout, temporary run directory or Docker resource from an authorized WSL Project Root. The original Work was authored through GitHub API and that record did **not** materialize a Work-specific WSL checkout; do not infer current absence or presence without inspection.
- **Other scenario/shared resources:** The previous run2 report identified `work-runtime-resources-net` as a possible residual network. Treat it as test-scenario state, not automatically as this Work's resource; check live ownership and attachments before any cleanup. Do not delete Project-shared images, caches, volumes, unrelated Work resources, or other projects' Docker state.
- **Post-merge gate:** Verify the archive preserves the original blob, that old active Records no longer appear on integrated `main`, and that the three repository Bash suites still pass on the actual integrated HEAD. Record failures/limits accurately.
- **Issue/work completion:** Issue #209 remains **OPEN** through this archive PR. Only after archive publication, verification and resource reconciliation should Work completion, optional local cleanup and Issue Close be considered.
- **Out of scope here:** No target-project Artifact sync, new blind run, hosted CI/GitHub Actions, Docker mutation, branch/worktree deletion or Issue close.
