# Documentation Format and Git

Read this for documentation file format and documentation-specific Git presentation.

## Git is the history mechanism

Use Git history to track document creation, movement, modification, and deletion.

Do not require a document-specific `last_updated_commit` registry merely to duplicate Git history.

This file does **not** decide when commits/pushes are authorized; that belongs to the engineering workflow/project policy.

## Commit messages

Prefer the project's existing convention.

If none exists, a Conventional-Commits-style prefix with a concise description is a reasonable default, for example:

```text
docs: update project overview
fix: correct API endpoint in documentation
refactor: reorganize documentation routing
chore: update documentation tooling
```

Do not let documentation-specific naming override a project-wide VCS policy.

## File formats

Use formats appropriate to the information:

- Markdown for explanation/procedure;
- YAML for structured lists/metadata;
- JSON/YAML/OpenAPI for machine-readable specifications;
- Markdown + YAML blocks when both context and structure are useful.

Follow project-local naming conventions. If none exist, prefer simple lowercase/hyphenated document names for project documentation.

## Ownership boundary

- commit/push authority → engineering workflow;
- work-specific branch/worktree identity → project/work guidance;
- destructive Git operations → safety guidance;
- documentation content/format/routing → documentation guidance.
