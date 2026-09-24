# Task

Record the following HTTP retry policy as durable project knowledge so that it is discoverable later:

- GET requests may be retried at most twice on 502/503 responses, with exponential backoff.
- POST requests are never retried automatically.
- The request timeout remains the project's stated value.

Use the project's own documentation conventions.

Before doing anything else, use the installed reusable guidance starting from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include the exact artifact files you actually read, the documentation files you changed, and the verification actually run.
