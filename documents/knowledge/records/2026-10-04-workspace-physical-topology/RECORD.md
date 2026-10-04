# Record — Workspace physical topology correction

```yaml
record_type: "github_issue_snapshot"
source: "GitHub Issue #191"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/191"
recorded_date: "2026-10-04"
scope: "Multi-repository physical topology, worktree routing, and Artifact NAL correction"
fidelity: "Issue body copied verbatim into ISSUE_191_BODY.md"
```

## Source inventory

- `ISSUE_191_BODY.md`: Issue #191 body as captured for this workspace topology correction.

## Decision captured

Observed agent failure on a multi-repository Project:

- Management Root Repository and Component Repository primary checkouts were placed as siblings of the Project Root, at the same external filesystem level.
- Work-specific checkouts were created as ad-hoc `<repo>-<branch>` directories beside the Project Root instead of the Work Root contract.
- Static workspace topology and the dynamic Worktree contract were not connected inside one task.

Clarified semantics:

- Component Repository primary checkout default = a descendant of the Project Root. The exact relative path is project-local deterministic mapping; explicit project-local specialization is allowed.
- Filesystem containment and Git ownership / authority / dependency are separate axes. Issue #167 abolished the parent/child *role and documentation* hierarchy; it did not abolish physical containment under the Project Root.
- Work-specific repository checkouts resolve to `<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/` only; Project Root sibling ad-hoc checkouts are not justified by current guidance.
- Artifact runtime carries the current positive topology directly per the #190 Negative Alternative Leakage rule; old-model explanations stay in subjects/history.

Note: `ISSUE_191_BODY.md` predates Issue #192 and uses the historical `Project Repository` name; the current canonical role is `Management Root Repository` (管理ルートリポジトリ).
