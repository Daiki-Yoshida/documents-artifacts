# Documentation Workflow and Maintenance

Read this for new-project setup, brownfield documentation migration, ongoing updates, structural review, or Work Documents reconciliation.

## New project

1. Create only the AI entry files for tools the project actually uses.
2. Create `documents/`.
3. Create `documents/INDEX.md` as the routing hub.
4. Add project-level context needed now.
5. Add reference/topic documents as demand appears; do not pre-create empty taxonomy.

## Brownfield adoption

Before reorganizing:

1. inventory existing documentation;
2. classify current/canonical, audience-specific, duplicate, and obsolete material;
3. preserve deliberate project-local conventions unless the task intends to change them;
4. move/merge gradually while keeping routing valid.

Do not use documentation cleanup as an excuse for unrelated project restructuring.

## Ongoing updates

When implementation or a decision changes durable project knowledge, update the owning document and routing references in the same change when practical.

Do not maintain parallel manual version registries when Git history already tracks document evolution.

## Work Documents reconciliation

Work-specific investigation/design lives with the Work while it is active.

At completion, reconcile rather than copy everything:

```text
Work Documents
   ↓ review
durable confirmed knowledge → Project Documentation
temporary hypotheses/logs    → discard when no longer needed
```

Do not preserve raw work notes as permanent project authority merely because they existed.

## Delete safely

Before deleting or moving a document:

- search the documentation tree for references;
- update/remove incoming links;
- update `documents/INDEX.md`;
- preserve the reason in Git history.

Do not leave broken routing.

## Documentation change level

```yaml
DOC_L0_content:
  action: "Existing-file content edit; proceed."

DOC_L1_additive:
  action: "Add a file inside established routing; proceed and report."

DOC_L2_structural:
  examples: ["move", "rename", "routing path change", "delete"]
  action: "Proceed only when clearly implied by the task; report explicitly."

DOC_L3_model_change:
  examples: ["replace the authority/routing model", "rebuild the whole documents tree"]
  action: "Do not perform without an explicit request."
```

Documentation risk is separate from code-contract and destructive-operation risk.
