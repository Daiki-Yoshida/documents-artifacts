# Development Safety Principles

Read this for the default safety posture of development operations.

## Priority

Prefer, in order:

1. host and data safety;
2. reproducibility;
3. repository/resource isolation;
4. safe parallel AI/developer operation;
5. explicit targets and side effects;
6. diagnosability/recovery;
7. local/CI path consistency;
8. convenience.

Safety should not make routine work unnecessarily cumbersome.

> Make the safe operation the easiest/default operation.

## Default design

- routine commands are non-destructive by default;
- destructive effects have explicit names and narrow scope;
- diagnostics/status are easy to discover;
- cleanup targets only the selected Project/Work-owned resources;
- one standard final verification path exists.

Put safety into command/resource design instead of relying on repeated manual caution.
