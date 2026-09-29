# Task

Inside the checkout module there is a pure currency-amount concept, but
it is named as if it were a checkout concept itself. The tax/discount
side of the code is also getting harder to read.

Please tidy up the model while keeping the current checkout behavior.

- Checkout is currently the only consumer.
- No future-only extension machinery is needed.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

Run the strongest relevant verification actually available in this
environment, and report results accurately.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- how you separated the concerns before changing code;
- the files you changed and why;
- the verification commands you ran and their actual results;
- managed `documents/artifacts/` integrity.
