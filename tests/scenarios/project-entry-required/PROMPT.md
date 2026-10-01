# Task

Record the following HTTP retry policy as durable project knowledge so
that it is discoverable later:

- GET requests may be retried at most twice on 502/503 responses, with
  exponential backoff.
- POST requests are never retried automatically.
- The request timeout remains the project's stated value.

Use the project's own documentation conventions.

In the final report, include the files you actually consulted, what you
changed and why, and the verification you actually ran.
