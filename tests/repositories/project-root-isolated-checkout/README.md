# Isolated local validation workspace

This is the Management Root Repository. The current checkout is the Project Root. The tracked `legacy/KEEP.txt` is a protected existing asset; keep it unchanged.

This project uses the following local placement contract for a **temporary clean validation checkout** of the Management Root Repository:

```text
<project-root>/.sandbox/validation/
```

It is an independent checkout of the current committed HEAD, not a new Project or a Work Identity worktree. The temporary checkout must remain excluded from the Management Root Repository's tracked content. `.sandbox/` is ignored. The project-owned smoke output belongs in `tests/tmp/`, which is also ignored. The original checkout, including its Git state, is the stable Project Root throughout this check.

Commands:

- `make smoke` — emit the project-local smoke evidence.
- `make verify` — verify the isolated checkout, smoke output, and preservation of the legacy asset.

No external workspace write target is declared by this project. If a requested operation needs a target beyond the Project Root, its authority must be resolved separately.
