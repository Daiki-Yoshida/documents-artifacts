# RPG Project Workspace

This repository is the **Management Root Repository**. Start project development from this root so project documentation, command routing, repository ownership, and final verification remain visible.

The game implementation lives in an independent Component Repository at:

```text
components/game
```

The current Project-required pathfinding node limit is owned by:

```text
config/pathfinding-required.txt
```

Do not change that Project target merely to make a component check pass.

## Development commands

Routine component development operations are exposed by the Project Root Makefile.

```bash
make help
make DIR=components/game dev-install
make DIR=components/game test
make DIR=components/game verify
```

`DIR` is the target directory path itself, resolved from this Project Root. The interface does not append a repository-role suffix or infer a Work Identity.

A Component Repository may have a local self-check, but Project completion is established by the Project-level verification path.
