# Repository Structure

This repository has three distinct document scopes.

```yaml
artifacts:
  path: "artifacts/<module>/"
  authority: "canonical"
  audience: "CLI coding agents"
  distribution: "copied selectively into target projects"

docs_jp:
  path: "docs-jp/<module>/"
  authority: "human-facing companion"
  audience: "Japanese-speaking maintainers and users"
  distribution: "not copied by artifacts.sh"

repository_docs:
  path: "documents/project/"
  authority: "repository-local"
  audience: "maintainers of documents-artifacts"
  distribution: "never copied to target projects"
```

## Module boundary

A module is an independently adoptable guidance set. Modules share this Git repository so cross-module consistency changes can be reviewed atomically, but target projects choose modules independently.

Current module names are directory names under `artifacts/`. `artifacts.sh` discovers these directories rather than maintaining a separate module registry.

## Distribution boundary

The distribution tool owns only a selected target directory:

```text
<target>/documents/artifacts/<module>/
```

Installing or updating a module replaces that module directory as a unit. It must not remove or modify unselected module directories. Removing a module requires a separate explicit removal request.

The distribution tool does not own Git history, commits, branches, tags, rollback, or archival. Those remain responsibilities of the target project's Git repository.

## Agent entry points

This repository does not distribute a universal agent configuration file. Consumers may reference installed module `INDEX.md` files from `AGENTS.md`, `CLAUDE.md`, or another tool-specific entry point appropriate to the target project.
