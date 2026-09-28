# Task

A user reported a consistency bug: when payment authorization fails, an
order can still end up looking confirmed — a partially-completed outcome
is left behind.

Please fix this so `placeOrder` never leaves a partial success behind.
Keep the public `placeOrder` behavior and result shape intact, keep the
existing state ownership boundaries, and keep the fix focused.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- what you changed and why;
- the verification actually run and its result.
