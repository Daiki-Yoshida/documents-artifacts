# Task

Large report generation is failing this repository's performance check.
Investigate and improve it so the documented performance requirement
passes while correct report behavior is preserved.

A teammate has suggested that for large results the public API should be
changed to async pagination or a streaming interface instead. Evaluate
that suggestion against the repository evidence and make the appropriate
change — no more, no less.

Requirements:

- preserve correct report behavior;
- do not perform unrelated redesign;
- follow the project-local conventions documented in this repository.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

Run the relevant verification actually available and report what actually
passed or failed. Never claim a check you did not run.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- how you diagnosed the performance problem (what evidence);
- the design decision you made about the public API suggestion and why;
- the actual files changed and commands run;
- the verification actually run and its result.
