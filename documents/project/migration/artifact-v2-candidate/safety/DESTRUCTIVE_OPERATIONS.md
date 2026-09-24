# Destructive Operations

Read this before delete/reset/purge/force operations or anything that may lose source changes, commits, persistent data, caches, remote state, or host configuration.

## Separate routine from destructive behavior

A destructive operation must have:

- an explicit name;
- narrow deterministic scope;
- precondition checks;
- a clear report of what will/was removed.

Do not hide DB reset, volume deletion, forced worktree removal, remote teardown, or host-wide cleanup behind an ambiguous routine `clean`.

Avoid global operations such as host-wide Docker prune in normal project lifecycle.

## Safety level

```yaml
SAFETY_L0_observe:
  examples: ["help", "status", "diagnostics", "non-mutating version check"]
  action: "Proceed."

SAFETY_L1_safe_local:
  examples: ["non-destructive target", "reversible local runtime materialization"]
  action: "Proceed and report."

SAFETY_L2_structural:
  examples: ["repository-root move", "worktree path contract change", "standard command rename", "CI ref policy change"]
  action: "Perform when clearly required by the request; report explicitly."

SAFETY_L3_destructive_or_host:
  examples: ["discard dirty worktree", "delete branch/persistent volume/DB", "host-wide cleanup", "host runtime install/remove", "history rewrite"]
  action: "Do not perform unless the destructive effect is explicitly requested/authorized."
```

A harmless-looking command name does not reduce the real safety level.

## Ownership matters

Project/Work/Run identity defines what may be targeted; it does not automatically authorize deletion.

Never delete shared/persistent state merely because one Work used it.
