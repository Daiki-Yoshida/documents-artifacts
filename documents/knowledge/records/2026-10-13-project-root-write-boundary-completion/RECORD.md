# Record — Project Root write boundary: user decisions and implementation completion

```yaml
record_type: "multi-source-event completion record"
recorded_date: "2026-10-13"
source_period: "2026-10-12 to 2026-10-13 JST"
scope: "Issue #199 Project Root write boundary: original user corrections, implementation, validation, review, merge and closure"
source_issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/199"
implementation_pr: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/200"
previous_record: "../2026-10-12-project-root-write-boundary/"
merge_commit: "dc182c6f5737f1ecf67fe82e4fddb188d38c47f5"
fidelity: "USER_MESSAGES.md contains chat-message bodies verbatim inside separate fences; GitHub bodies/comments/review stored verbatim as fetched."
```

## Source inventory

Source events are preserved separately without rewriting the earlier Issue #199 snapshot.

- `USER_MESSAGES.md` — verbatim user decisions and instructions visible in the ChatGPT conversation, including the Project Root-internal alternative, the agent-generated-plan correction, test-scope adjustment, review, merge, Close, and this record-completion instruction. Headings and fences are provenance wrappers only.
- `ISSUE_199_FINAL_BODY.md` — Issue #199 body as retrieved after closure; source: https://github.com/Daiki-Yoshida/documents-artifacts/issues/199
- `ISSUE_199_COMMENT_6127390776.md` — post-merge verification comment (verbatim); source: https://github.com/Daiki-Yoshida/documents-artifacts/issues/199#issuecomment-6127390776
- `ISSUE_199_COMMENT_6127539417.md` — explicit completion and scope decision (verbatim); source: https://github.com/Daiki-Yoshida/documents-artifacts/issues/199#issuecomment-6127539417
- `PR_200_FINAL_BODY.md` — PR #200 body as retrieved after merge; source: https://github.com/Daiki-Yoshida/documents-artifacts/pull/200
- `PR_200_COMMENT_6126784823.md` — quick blind behavior evaluation comment (verbatim); source: https://github.com/Daiki-Yoshida/documents-artifacts/pull/200#issuecomment-6126784823
- `PR_200_COMMENT_6127041494.md` — deterministic suite and route-checker-fix results comment (verbatim); source: https://github.com/Daiki-Yoshida/documents-artifacts/pull/200#issuecomment-6127041494
- `PR_200_FINAL_REVIEW.md` — final review body (verbatim); source: https://github.com/Daiki-Yoshida/documents-artifacts/pull/200#pullrequestreview-5492810793

## Linked original evidence (not copied)

- Previous source import: `../2026-10-12-project-root-write-boundary/`. Its original `ISSUE_199_BODY.md` remains unchanged.
- Executable deterministic tests and results: `../../../../tests/test-artifacts.sh`, `../../../../tests/test-knowledge-integrity.sh`, `../../../../tests/test-agent-harness.sh`.
- GitHub Actions: https://github.com/Daiki-Yoshida/documents-artifacts/actions/runs/38267545164 (initial failure) and https://github.com/Daiki-Yoshida/documents-artifacts/actions/runs/38267790566 (all relevant suites PASS on `5ad6c1936ad50a2200d57909bbc060661e8b8dbf`).
- Quick blind execution raw evidence: `../../../../tests/results/project-root-isolated-checkout/2026-10-12-quick1/`; independent outcome evaluation: `../../../../tests/evaluations/project-root-isolated-checkout/2026-10-12-quick1.md`.
- PR #200 was merged to `main` through merge commit `dc182c6f5737f1ecf67fe82e4fddb188d38c47f5`; Issue #199 is closed as completed.

## Decision and evidence boundary

Current reusable rules already reside in `../../subjects/workspace-structure/`, `../../subjects/engineering-operation/` and `../../subjects/development-safety/`, and are projected into `artifacts/`. This record adds source fidelity and completion traceability, not a competing normative authority.

The stored Issue and PR bodies include then-current pending states and test plans. Preserve these historical source statements without treating them as the final state: later merge/closure comments and their GitHub resource states resolve completion. The quick blind run and deterministic suites passed within their observed scope; an external-library fresh blind run, actual root relocation and host/Docker behavior trials were not performed and were judged not mandatory for this Issue's completion.

The source Dunlyth incident remains a user-provided report; this archive does not independently verify the October 4 local filesystem or the full historical agent session.
