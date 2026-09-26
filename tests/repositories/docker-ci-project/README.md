# Docker CI Project Sample

Small Docker-first Node service fixture.

## Execution environment

- This project is **Docker-first**: Node and npm live inside the
  repository-managed container, not on the host.
- Host prerequisites are only: Git, Docker (with Compose), Make.
- The `app` service in `compose.yml` is the project's managed execution
  environment; application code and project CLIs run inside it.
- Do not install Node.js, npm, or packages on the host for project work.

## Final verification

- `make verify` is the single canonical **final verification** entry point
  for humans, AI agents, and CI alike.
- Individual package scripts (`npm test`, `npm run contract-check`) are
  partial checks that run inside the managed environment; they are not the
  final gate.
- CI must reuse the same project-owned final verification entry point as
  local development.
