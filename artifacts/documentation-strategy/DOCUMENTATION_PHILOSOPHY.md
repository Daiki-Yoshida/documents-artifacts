# Documentation Philosophy

```yaml
document_type: "documentation_philosophy"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.4.0"
```

## Core Principle: Information Accuracy First

The purpose of documentation is to give AI agents accurate, complete information
at the right time. Token efficiency matters, but **never at the cost of
information degradation**.

```yaml
priority_order:
  1: "Information accuracy — the document must be correct and complete"
  2: "Proper routing — the agent reads only what it needs, when it needs it"
  3: "Token efficiency — minimize waste, but never truncate information to save tokens"
```

When accuracy and token efficiency conflict, accuracy wins. The solution to
token cost is **better file structure and routing**, not thinner documents.

```yaml
wrong_approach: "Shrink a document to fit a token budget, losing critical detail."
right_approach: "Split the document by concern so the agent loads only the relevant part."
```

---

## Scope: What This Strategy Governs

```yaml
governs:
  - "Project-owned documentation under documents/ — content, structure, routing, and maintenance"
  - "documents/INDEX.md — routing hub and version registry for project-owned documents"
  - "documents/artifacts/ ownership boundary — installed guidance is distributor-managed, not project-owned documentation"
  - "docs-jp/ directory — human-facing documentation placement and separation"
  - "Agent entry files (CLAUDE.md, AGENTS.md, GEMINI.md) — role, routing, and convention template"
  - "README.md — role as human-facing entry point"
  - "Git commit message conventions for documentation changes"
  - "Project-document versioning — tracking which commit a project-owned document reflects"

does_not_govern:
  - "Source code design, architecture, or patterns"
  - "The contents or internal version metadata of installed artifact modules under documents/artifacts/"
  - "Git commit timing — when to commit is a code-side concern"
  - "Git branching strategy — that is a development workflow concern"
  - "Code review process — that is a development process concern"
```

This strategy is about **recording and documentation**, not about code. Git is
partially governed because it is the recording tool: how to label a documentation
commit (message conventions) and how to track which code state a project-owned
document describes (version + commit hash). When to commit, whether to branch,
and how to review are code-side decisions.

### Ownership Inside `documents/`

`documents/` is an AI-facing root, but not every subtree has the same owner.

```yaml
project_owned_documentation:
  examples: ["documents/INDEX.md", "documents/project/", "documents/reference/", "documents/<topic>/"]
  owner: "the target project"
  maintenance: "governed by this strategy, including project document version/hash tracking"

managed_artifact_guidance:
  path: "documents/artifacts/<module>/"
  owner: "the artifact's canonical source + the distribution/sync mechanism used by the target project"
  maintenance: "sync/update/remove through that owning mechanism; do not directly rewrite installed files as project documentation"
  registry_rule: "Do not register managed artifact files in the target project's documents/INDEX.md version registry. Each installed module routes internally through its own INDEX.md."
```

A managed guidance subtree may be committed in the target project's Git history, but
that does not make its individual files project-owned documents. Git records the copied
snapshot; the canonical artifact source still owns the guidance content.

---

## AI-Facing by Default

```yaml
principle: "Everything under documents/ is written for AI agents."
rationale: |
  Users instruct AI agents with "@documents/ — understand this and develop."
  If documents/ contained human-facing prose, the agent would waste tokens
  parsing non-actionable content. Therefore documents/ is entirely AI-facing.

ownership_note: |
  AI-facing does not imply project-owned. documents/artifacts/ is also AI-facing,
  but its installed guidance is managed by the artifact distribution source rather
  than by the target project's documentation workflow.

human_facing:
  location: "docs-jp/ (separate top-level directory)"
  language: "Japanese"
  purpose: "Project background, setup tutorials, design rationale for humans"
  rule: "Human-facing content does NOT live under documents/"
```

---

## Routing Over Truncation

```yaml
principle: "Split files by concern; route the agent to the right file. Do not compress information."
mechanisms:
  project_index: "documents/INDEX.md lists and routes project-owned documents."
  managed_guidance: "Each installed documents/artifacts/<module>/INDEX.md routes within that managed artifact module; the project INDEX may link to the module entry point but does not inventory every managed file."
  cross_references: "Each document links to related documents instead of duplicating content."
  concern_separation: "One file = one concern. A change to one concern should require reading one file."
  gradual_disclosure: "INDEX → overview → detail. The agent follows the chain only as far as needed."
```

The agent should never read everything to find one answer. The file structure
itself is the routing system.

---

## Git as a Recording Tool

```yaml
principle: "Git records what changed and when. Documentation uses this record to stay accountable."
governed_aspects:
  commit_message_format: "Conventional Commits prefix (docs:, feat:, fix:) + Japanese description. See FILE_AND_STRUCTURE.md."
  version_tracking: "Each project-owned document records its version and the git commit/state it was last reviewed or updated against. See FILE_AND_STRUCTURE.md."
not_governed:
  - "When to commit (code-side decision)"
  - "Whether to branch (code-side decision)"
  - "Review process (code-side decision)"
  - "Independent metadata inside distributor-managed documents/artifacts/ modules"
```

Documentation commits should be identifiable in git history. A project-owned
document that describes code should record which commit/state it reflects, so the
reader can verify the document still matches the code.

---

## Single Source of Truth

```yaml
principle: "Each piece of information lives in exactly one owning document or artifact source."
rules:
  - "If a concept appears in two project-owned files, one owns it and the other links."
  - "Restatement is allowed as at most one sentence + a link to the owner."
  - "On conflict between project-owned documents, the owning document is authoritative."
  - "Splitting a topic into 'why' and 'how' is allowed; join them with cross-references."
  - "Installed artifact guidance remains authoritative according to its own module/source; do not copy its rules into project-owned docs merely to mirror it."
```

---

## Universality

```yaml
principle: "The strategy works for any project that uses AI agents."
scope:
  single_project: "One repository, one project-owned documents/ tree, one documents/INDEX.md, plus optional managed guidance subtrees."
  hierarchical_project: "Parent + child projects, each with independent project-owned documents/ trees."
  scale_independence: "From a single-script repo to a multi-service monorepo."
```

> **Single source of truth**: hierarchical structure rules live in
> `FILE_AND_STRUCTURE.md` → "Hierarchical Projects".

---

## Relationship to design-principles

This strategy has a sibling: `design-principles`. They are independent artifact
sets with different domains, but a target project typically uses both.

### Domain Boundary

```yaml
this_artifact_set:
  name: "documentation-strategy"
  domain: "project documentation ownership/routing/versioning plus docs-jp and agent-entry placement"
  owns: "HOW to structure, route, version, and maintain project-owned documentation for AI agents, while keeping managed artifact guidance separate"

sibling_artifact_set:
  name: "design-principles"
  domain: "code (src/, tests/, packages/, etc.)"
  owns: "HOW to design and write code that AI agents produce"
```

### Usage Patterns

```yaml
pattern_1_independent:
  description: "User references one set for a domain-specific task."
  examples:
    - "Fix a code bug → reference design-principles/"
    - "Update project documents → reference documentation-strategy/"

pattern_2_combined:
  description: "User references both sets at once for a full-project task."
  examples:
    - "'Develop this project following @<strategy_artifacts_path>/' (path varies per project — e.g., documents/artifacts/, artifacts/, or a submodule path)"
    - "Project AGENTS.md lists both artifact sets as references"
  implication: "The AI agent holds both contexts simultaneously."
```

### When Both Are Read Simultaneously

```yaml
guidance:
  domain_routing: "If the task touches code (src/, tests/), follow design-principles. If the task touches project-owned documents or documentation routing, follow documentation-strategy."
  managed_guidance: "If the task is to update installed files under documents/artifacts/, use the artifact's owning sync/update mechanism rather than treating those files as ordinary project documentation."
  mixed_tasks: "If a task touches both code and documents, apply each set to its respective domain. Do not mix rules across domains."
  shared_concepts: "SSOT, brownfield policy, confirmation gate, and proportionality exist in both sets. Each is applied per-domain, not merged."
```

---

## Common Misreadings

```yaml
misreadings:
  - "'accuracy > tokens' != ignore token cost (structure files well so the agent reads efficiently; just never delete information to save tokens)"
  - "'documents/ is AI-facing' != every file under documents/ is project-owned (documents/artifacts/ may be distributor-managed guidance)"
  - "'documents/ is AI-facing' != humans cannot read it (they can; it is optimized for AI, not restricted from humans)"
  - "'routing over truncation' != make infinite tiny files (one file = one concern; split when a file covers multiple concerns, not when it hits a token count)"
  - "'git as recording' != we control git workflow (we control documentation commit format and project-document version tracking; timing and branching are code-side)"
  - "'docs-jp/ for humans' != documents/ cannot have Japanese (it can if the AI agent needs Japanese context; the default is English for processing efficiency)"
  - "'single source of truth' != never mention a concept twice (one-sentence restatement + link is allowed)"
  - "'universality' != one rigid template (the strategy adapts to single and hierarchical projects)"
  - "this strategy != a documentation generator (it defines structure and routing; the AI agent writes content following these rules)"
  - "installed artifact files committed in the target repo != project-owned editable docs (commit the snapshot, but update the guidance through its canonical distribution path)"
```
