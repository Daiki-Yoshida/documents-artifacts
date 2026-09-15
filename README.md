# documents-artifacts

Public canonical repository for reusable engineering guidance intended primarily for CLI coding agents.

The repository owns the authoritative artifact modules, their human-facing Japanese documentation, and the small distribution tool used to copy selected modules into development projects.

## Source-of-truth model

```text
GitHub: Daiki-Yoshida/documents-artifacts
        │
        ├─ artifacts/      authoritative AI-facing guidance
        ├─ docs-jp/        human-facing Japanese documentation
        └─ artifacts.sh    explicit install/update/remove tool
                │
                ▼
Target project
└─ documents/
   └─ artifacts/
      └─ <selected modules>/
```

Rules:

- This public GitHub repository is the canonical source.
- `artifacts/` contains the authoritative guidance consumed by coding agents.
- Artifact modules are independent adoption units. A project may use any subset.
- Copies placed in target projects are committed to the target project's Git repository.
- Updates are explicit. A target project does not track `main` automatically.
- Git owns history, rollback, comparison, and archival. This repository does not implement a parallel version-history or manifest system.
- Omitted modules are never removed implicitly. Removal is a separate explicit operation.

## Modules

Current modules:

| Module | Scope |
| --- | --- |
| `design-principles` | Code design, implementation quality, contracts, structure, and AI implementation workflow |
| `documentation-strategy` | Structure, routing, and maintenance of AI-facing project documentation |
| `development-environment-strategy` | Development workspace, Docker-first execution, repository operations, parallel-agent isolation, and environment lifecycle |

Each module lives under `artifacts/<module>/` and owns its own `INDEX.md` entry point.

Modules share one Git repository so cross-cutting changes can be reviewed together, but they remain independently distributable.

## Language policy

The authoritative AI-facing artifacts are currently written in English. This is a pragmatic convention for consistency with code, technical terminology, and common model training material; it is not a claim that English is universally superior for every model or task.

Human-facing Japanese material lives under `docs-jp/`. When the two differ, the files under `artifacts/` are authoritative.

## Repository layout

```text
.
├─ README.md
├─ artifacts.sh
├─ artifacts/
│  ├─ design-principles/
│  ├─ documentation-strategy/
│  └─ development-environment-strategy/
├─ docs-jp/
│  └─ <module>/
├─ documents/
│  └─ project/
└─ tests/
```

`documents/project/` documents this repository itself. It is not distributed to target projects.

## Distribution

### Interactive use

Clone or update this repository, then run:

```bash
./artifacts.sh
```

The script asks for the target project and which modules to install or update. It also offers a separate explicit removal selection.

### Non-interactive / agent use

```bash
./artifacts.sh \
  --target /path/to/project \
  --modules design-principles,documentation-strategy \
  --non-interactive
```

Install or update every available module:

```bash
./artifacts.sh \
  --target /path/to/project \
  --modules all \
  --non-interactive
```

List available modules:

```bash
./artifacts.sh --list
```

### Explicit removal

Removal is never inferred from an install/update selection.

```bash
./artifacts.sh \
  --target /path/to/project \
  --remove development-environment-strategy \
  --non-interactive
```

A project that already contains three modules and later runs `--modules design-principles` keeps the other two unchanged. To stop using one, remove it explicitly.

## Sync contract

For every selected install/update module:

- the corresponding `artifacts/<module>/` directory is copied to `documents/artifacts/<module>/` in the target project;
- the selected module directory is replaced as a unit, so files removed from the canonical module disappear from that copied module;
- modules not selected are untouched;
- symlinked destination module paths are rejected;
- no Git command is run in the target project.

After synchronization, review the normal Git diff in the target project and commit it there.

There is intentionally no generated manifest, independent artifact version file, rollback database, or archive directory. The target repository's Git history records exactly which artifact snapshot was used at each commit.

## Agent integration

This repository does not impose a universal `AGENTS.md`, `CLAUDE.md`, or equivalent configuration on target projects. Agent entry points vary by tool and workspace.

A target project may reference the installed `documents/artifacts/<module>/INDEX.md` files from its own agent-specific instructions. Keep those project-specific routing instructions small and local to the project.

## Validation

```bash
bash -n artifacts.sh
bash tests/test-artifacts.sh
```

The tests cover selective installation, exact module update, non-removal of omitted modules, explicit removal, invalid selections, conflicting operations, and symlink protection.
