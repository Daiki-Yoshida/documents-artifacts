# Repository Structure

This repository separates reusable semantic knowledge, AI publication artifacts, human/rationale material, and repository-local documentation.

```yaml
canonical_knowledge:
  path: "documents/knowledge/"
  authority: "canonical reusable engineering meaning"
  audience: ["AI agents", "human maintainers"]
  distribution: "not copied directly as a target-project artifact by the current legacy sync tool"

artifact_projection:
  path: "artifacts/"
  authority: "derived from canonical knowledge"
  audience: "AI coding agents"
  distribution: "currently copied into target projects by artifacts.sh"
  migration_state: "legacy projection retained while publication/distribution is redesigned"

docs_jp:
  path: "docs-jp/"
  authority: "non-canonical human-facing companion, rationale, experiments, and source logs"
  audience: "Japanese-speaking maintainers and users"
  precedence: "canonical knowledge wins on semantic conflict"
  distribution: "not copied by artifacts.sh"

repository_docs:
  path: "documents/project/"
  authority: "repository-local"
  audience: "maintainers of documents-artifacts"
  distribution: "never copied to target projects"
```

## Canonical Knowledge Boundary

`documents/knowledge/` is the semantic source of truth.

Knowledge is organized by concept/lifecycle:

```text
ENGINEERING_OPERATING_MODEL.md
WORK_LIFECYCLE.md
CODE_DESIGN.md
DEVELOPMENT_EXECUTION.md
PROJECT_KNOWLEDGE.md
```

`TRACEABILITY.md` records how the previous artifact files map into those owners.

The old `design-principles / documentation-strategy / development-environment-strategy` module boundary is no longer a canonical knowledge boundary.

Likewise, WHY/HOW/WHERE/FLOW is no longer the primary file-partitioning rule.

## Artifact Boundary

`artifacts/` is a publication surface optimized for AI consumption.

A future artifact projection may:

- combine canonical concepts;
- split them into smaller task-specific references;
- add small routing/index files;
- publish playbooks or profiles;
- change read order;
- change filesystem layout;
- change distribution packaging.

It must preserve the canonical semantics or explicitly originate a canonical knowledge change first.

## Current Migration Boundary

The current `artifacts/` directories and `artifacts.sh --modules` behavior remain temporarily for compatibility.

They do not define future artifact architecture.

Do not:

- delete the current projection before replacement design is complete;
- add new reusable semantic rules only to legacy artifact files;
- infer that selectable legacy modules remain a product requirement.

## Distribution Boundary

The current legacy distribution tool owns paths under:

```text
<target>/documents/artifacts/
```

Its selective-module behavior is compatibility behavior during migration.

The future publication/distribution contract will be redesigned separately from the semantic knowledge source.

The distribution layer does not own Git history, commits, branches, tags, rollback, or archival. Those remain responsibilities of the target project's Git repository.

## Agent Entry Points

This repository does not distribute one universal agent configuration file.

Consumers should keep their project-specific `AGENTS.md`, `CLAUDE.md`, or equivalent small and route to project knowledge plus the relevant derived reusable guidance.

Canonical reusable knowledge itself is entered through:

```text
documents/knowledge/INDEX.md
```
