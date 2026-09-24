# Version Control and Reporting

Read this when deciding whether to commit/push or how to report a completed engineering change.

## Commit/push authority

Default reusable rule:

```yaml
commit_push: "Do not commit or push unless the user/project workflow authorizes it."
default_branch: "When a commit is needed, do not directly commit on the default branch unless the project explicitly uses that workflow."
project_rule: "A more specific project-local VCS policy overrides this reusable default."
```

Static repository ownership belongs to project structure guidance. Work-specific branch/worktree lifecycle belongs to project/work guidance.

## Reporting

Report facts needed to understand the result:

- what changed;
- why;
- public/data/operation impact;
- actual verification results;
- checks not run or failed;
- intentionally retained work resources or remaining issues when relevant.

Do not hide failed/unperformed verification behind a generic "done."

Use the language/form appropriate for the user and context; do not impose legacy fixed reporting language.
