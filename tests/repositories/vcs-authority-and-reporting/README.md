# VCS Authority and Reporting

Small Node project with a project-local VCS authority policy for
automation. The authority rules live in `AGENTS.md`.

## Verification

- `make verify` — the complete **local** gate: unit tests plus the
  version-control authority check.
- `make external-check` — external compatibility check. It requires a
  maintainer-owned input (`PARTNER_CONTRACT_FIXTURE`); without that
  input the check cannot run. When it cannot run, the change may still
  reach a local review-ready state — but it is **not** fully externally
  verified.
