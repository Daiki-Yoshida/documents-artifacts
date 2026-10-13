# Work Records Protocol — integration and archive checkpoint

Work: `feat/work-records-protocol`
Recorded date: 2026-10-14
Scope: [Issue #204](https://github.com/Daiki-Yoshida/documents-artifacts/issues/204)
Status at writing: implementation integrated; GitHub Archive migration in progress; WSL resource cleanup not yet independently confirmed

## Completed integration

- [PR #205](https://github.com/Daiki-Yoshida/documents-artifacts/pull/205) preserved the original proposal and was merged by merge commit `83f42fb56b10633dbb8941f615e1fa266e2ec3b8`. Parent ancestry includes the source branch head `a0c2c72`.
- [PR #206](https://github.com/Daiki-Yoshida/documents-artifacts/pull/206) implemented the lightweight journal, historical Work Records Archive, source-to-subject-to-Artifact projection, and dedicated positive/negative fixture. It was retargeted onto `main` after PR #205 integration, then merged by merge commit `3b8504304cf65f467da096c40369375de900a9d5`.
- The resulting `main` tree SHA equals the PR #206 head tree SHA: `3f5edb5d04bc25357ada0a281eeee33b539a86c0`. No merge-only content changes occurred.
- Work history remained in the Management Root Repository; only the two preexisting Work Records are relocated into this Archive without changing their Git blob SHAs. This new record documents the subsequent integration.

## Verification and evidence boundaries

- The independent WSL Devin verification session executed both Bash syntax checks and `test-knowledge-integrity.sh`, `test-artifacts.sh`, and `test-agent-harness.sh` successfully on `38ce2283d509aa76251562dd834acc8ed588cc40`, covering all 34 scenario fixtures.
- An independent blind agent completed `work-records-closeout`; its machine evidence, observed reads, retained source transcript, verification outputs, and separate evaluator result are at `tests/results/work-records-closeout/2026-10-13-devin-run1/` and `tests/evaluations/work-records-closeout/2026-10-13-devin-run1.md`. Evaluation: PASS.
- The subsequent `391616d` commit added only 16 results/evaluation files, leaving Artifact/code/test implementation unchanged. Source PR and implementation PR were merged without altering their respective head trees.
- Full shell suites **were not rerun** in this ChatGPT environment at the combined `main` merge HEAD or this Archive cleanup HEAD. Do not substitute Git tree equality for an executed test.
- A `.serena/` untracked artifact appeared in the blind run's captured patch but not its commit; raw evidence is preserved unmodified. Optional fixture ignore is deferred to a separate change.

## Closeout boundaries

- This Archive is historical and does not supersede the current Project Documentation.
- No target-project sync, GitHub Actions, external CI, or paid runner was launched by this GitHub integration workflow.
- The independently verified WSL checkout `.worktrees/feat/work-records-protocol/main` existed before merging. Its current local registration, cleanliness, removal and any other Work-scoped resources must be checked in that WSL environment. Until then Work-level resource reconciliation remains **pending**; do not assert a complete cleanup or Issue Close solely from remote Archive publication.
