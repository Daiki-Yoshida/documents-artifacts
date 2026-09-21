# Documents Index

```yaml
document_type: "index"
target_audience: ["ai_agents", "human_maintainers"]
role: "routing hub for repository-local and canonical reusable knowledge"
```

This repository separates reusable engineering meaning from the AI-facing artifact projection derived from it.

## Routing

```yaml
"reusable engineering knowledge / artifact semantic source":
  target: "knowledge/INDEX.md"

"how this repository is structured":
  target: "project/REPOSITORY_STRUCTURE.md"

"current artifact projection":
  target: "../artifacts/"
  note: "derived legacy projection during migration; not the canonical semantic owner"

"Japanese rationale / experiments / source logs":
  target: "../docs-jp/"
  note: "non-canonical evidence and human-facing material"
```

## Canonical Reusable Knowledge

Start at:

```text
knowledge/INDEX.md
```

Load only the relevant semantic owner for the task.

## Migration Rule

During the artifact redesign:

1. preserve/update meaning in `documents/knowledge/`;
2. use `knowledge/TRACEABILITY.md` to check legacy coverage;
3. redesign `artifacts/` only as a derived AI publication layer;
4. do not treat the old selectable-module layout as the future knowledge architecture.
