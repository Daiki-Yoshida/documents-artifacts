# Documentation Principles and Routing

Read this when creating or restructuring project documentation.

## Priority

```yaml
1: "Information accuracy and completeness"
2: "Correct routing to the needed information"
3: "Token efficiency"
```

If accuracy and token cost conflict, accuracy wins. Solve token cost primarily with **file structure and routing**, not by deleting conditions or detail that changes meaning.

## Canonical project documentation root

Use:

```text
<project-root>/documents/
```

as the canonical Project Documentation root.

Its internal shape is project-specific. `documents/project/` and `documents/reference/` are useful examples, not mandatory directories.

Static placement/Git ownership belongs to project/workspace guidance; this file governs routing and document roles.

## INDEX is the routing hub

`documents/INDEX.md` is required and should route by task/concern.

It should provide:

- inventory of documentation and purpose;
- task → document routing;
- useful cross-references.

An AI should not need to read all documentation to find one answer.

## Agent entry files

Files such as `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` may contain:

- project-local constraints;
- agent role;
- emergency/ambiguity behavior;
- current focus;
- routing to `documents/INDEX.md`.

Do not make them duplicate authorities for detailed project knowledge. Create only entry files for tools actually used.

## README

Keep the root `README.md` as a concise human-facing introduction and pointer to deeper knowledge. Do not turn README into a duplicate authority for Project Documentation.

## One primary concern per file

Prefer a clear primary authority for each concern.

Local restatement for comprehension is fine; do not independently redefine the same rule in multiple documents.

Split by routing value, not by a rigid universal folder taxonomy.

Create a topic directory when it forms a real routed unit (for example several cohesive files that are useful together). Do not create a directory merely to host one small file, and do not treat a numeric file-count threshold as a hard law.

## Progressive disclosure

Typical chain:

```text
agent entry
  → documents/INDEX.md
  → task-relevant project/reference/topic document
  → deeper detail only if needed
```

Use relative links from the referring document.

## Hierarchical projects

A child project may own an independent `documents/` tree and INDEX.

Parent documentation may describe children at a high level, but should not duplicate each child's detailed authority.

Each child should remain self-contained through its own `documents/INDEX.md`; do not make child documentation depend on the parent's internal documentation as an implicit authority. Cross-project context should be an explicit external reference.
