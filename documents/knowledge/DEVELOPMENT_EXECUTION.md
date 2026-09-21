# Development Execution

```yaml
document_type: "canonical_knowledge"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
scope: "host/container boundary, commands, runtime resources, diagnostics, reproducibility, and CI"
artifact_projection: "derived"
```

This document owns the reusable execution-environment model. Active Work identity, Work Root, Work Documents, repository participation, worktree lifecycle, and Work completion are owned by `WORK_LIFECYCLE.md`.

## 1. Development Environment as a Contract

A development environment defines how work is entered, executed, verified, diagnosed, and safely cleaned.

Its contract includes topology, toolchain ownership, public command interface, runtime/resource lifecycle, isolation, safety, and recovery.

Internal scripts and tools may change while stable public development operations remain understandable.

## 2. Priority Order

```yaml
priority:
  1: "host and data safety"
  2: "reproducibility"
  3: "repository and resource isolation"
  4: "parallel-agent operability"
  5: "explicit operation semantics"
  6: "diagnosability and recoverability"
  7: "local and CI execution parity"
  8: "developer efficiency"
```

Safety should be encoded into short routine paths rather than repetitive manual ceremony.

## 3. Host Control Plane / Project Execution Plane

Default model:

```yaml
host_control_plane:
  owns:
    - "container runtime and Compose"
    - "Git/source control"
    - "command routing"
    - "authentication and remote access"
    - "interactive desktop tools when necessary"

project_execution_plane:
  usually_container_owned:
    - "language runtime"
    - "package manager"
    - "compiler/build toolchain"
    - "test runtime"
    - "database/migration CLI"
    - "project-specific provider/deployment CLI"
```

The host controls the project runtime; it is not the project runtime by default.

Do not install host runtimes merely because an agent finds a container command inconvenient.

A host exception should explain why container execution is unsuitable and how version drift is controlled.

Do not use elevated host privileges as a routine project operation.

## 4. Docker-First Execution

Where practical, project build/test/lint/format/migration/provider operations run through repository-owned Docker definitions.

Rules:

- source-control Dockerfiles and Compose definitions;
- respect package lock files;
- pin load-bearing runtime/tool versions;
- avoid floating `latest` for important tools;
- avoid undocumented dependence on host packages, networks, or manually prepared containers;
- make container-created host files editable/removable by the host user;
- use UID/GID or equivalent ownership strategies;
- do not normalize permission problems by running the whole environment as root.

Docker-first does not mean every control-plane Git/SSH/tmux operation belongs in Docker.

## 5. Runtime Resource Identity

Every environment resource should be attributable to a project and, when applicable, the Work that owns it.

```yaml
identity:
  required:
    - "project/workspace slug"
    - "resource role"
  conditional:
    - "environment"
    - "component/repository"
    - "Work Identity"
properties:
  - "deterministic"
  - "human-readable"
  - "collision-resistant on the host"
  - "usable for scoped diagnosis and cleanup"
```

Formatting may be normalized for Docker/provider/filesystem constraints, but mapping back to semantic ownership remains deterministic.

Resource scope semantics live in `WORK_LIFECYCLE.md`.

## 6. Resource Creation and Reuse

Do not duplicate images, containers, networks, databases, volumes, or caches merely because a branch/checkout changed.

Separate runtime resources only when required by concurrent execution, mutable-state isolation, configuration differences, independent disposal, or explicit project policy.

Share immutable/safely reusable caches when correct.

Rebuild an image when its inputs/toolchain requirements change, not merely because a new Work starts.

## 7. Files, Mounts, Caches, Ports, and Networks

### Files and mounts

- Generated host files should be owned by the normal host user.
- Keep caches/build outputs out of Git.
- Keep generated source-adjacent files only when the project intentionally owns them there.
- Do not fix permission problems by making broad root-owned project state the norm.

### Caches and volumes

- Share immutable or safely reusable dependency/tool caches when correct.
- Isolate mutable state that can alter test/runtime results during concurrent execution.
- Name volumes so ownership and deletion scope are clear.
- Removing one Work surface must not delete shared caches used by others.

### Ports and networks

- Parallel isolated checkouts cannot silently compete for the same fixed host ports.
- Prefer internal container networking when host exposure is unnecessary.
- Allocate/configure host ports explicitly when parallel isolated runtime is supported.
- Cleanup must be scoped to the selected project/Work resources.

## 8. Secrets

- Never bake secrets into images or commit real secret values.
- Keep examples/templates separate from real values.
- Do not echo secrets into logs, diagnostics, command output, or CI traces.
- Use lifecycle-appropriate secret mechanisms.
- Ordinary build/test work should not require an AI agent to read secret values.

## 9. Public Command Interface

Projects should expose stable, discoverable operations for routine work.

Preferred layering:

```yaml
Makefile_or_equivalent:
  role: "public operation names, help, parameters, simple dependencies"
wrapper:
  role: "optional normalized project/work/repository selection"
scripts:
  role: "complex validation, branching, orchestration, cleanup, provider behavior"
```

Use `<scope>-<action>` when the target/effect would otherwise be unclear.

Unscoped names such as `help`, `test`, `check`, or `validate` are acceptable when project-wide meaning is singular. Ambiguous lifecycle words such as `up`, `down`, `reset`, `clean`, `deploy`, or `logs` usually need scope.

Command documentation should state the target, observable effect, destructive scope, and important parameters.

A command must not silently become destructive while retaining a harmless name.

Separate stop, normal remove, persistent-state deletion, and destructive purge.

Failed commands return non-zero and preserve actionable diagnostics.

Worktree-specific public semantics are owned by `WORK_LIFECYCLE.md`.

## 10. Git Operation Safety

For environment tooling:

- resolve the intended repository/worktree before mutation;
- inspect dirty state before switch/remove/rebase-like operations;
- do not force-delete uncommitted work;
- keep branch deletion separate from worktree removal;
- keep branch base/start and upstream semantics explicit;
- preserve repository boundaries in multi-repository projects;
- do not commit Component Repository content into a Workspace/Project Repository accidentally.

Git history rewriting and force operations belong to explicit high-risk paths.


## 11. Destructive Operations

Destructive commands must:

- have an explicit name;
- have a narrow target;
- state irreversible/persistent effects;
- require confirmation or explicit user request at the appropriate risk level;
- avoid hidden global scope.

Do not use global Docker prune, broad filesystem deletion, database destruction, or host-runtime removal as a normal first diagnostic action.

## 12. Diagnostics

Provide easy read-only diagnostics for routine failures.

Useful diagnostics include:

- selected project/Work/repository/checkout;
- supported tool versions;
- runtime/container/network/volume state;
- ports and mounts;
- file ownership;
- public command parameters;
- Git branch/worktree state;
- CI/provider configuration differences.

When the Worktree Materialization Contract applies, diagnostics should expose enough state to verify it without hard-coding Git's internal administrative-directory naming.

## 13. Canonical Validation

Every project should provide a canonical final-validation operation or documented equivalent.

Partial checks are useful during implementation but do not replace the final gate.

Local validation and CI should invoke the same public operation or underlying script where practical.

Validation depth follows `ENGINEERING_OPERATING_MODEL.md`.

## 14. Local / CI Parity

Aim for shared project-owned execution paths.

Differences that remain should be explicit:

- provider authentication;
- environment/service availability;
- secret injection;
- workspace/ref selection;
- platform-specific interactive tooling.

Do not maintain completely separate local and CI logic when one repository-owned path can serve both.

## 15. Reproducibility

Repository state should control enough of the environment to recreate its behavior.

- pin or constrain meaningful tool versions;
- honor dependency locks;
- declare external tooling version selection;
- eliminate undocumented host dependencies;
- make environment-definition changes intentional and reviewable.

Reproducibility does not mean "never update". It means environment changes are attributable.

## 16. New Project Bootstrap

When setting up an environment:

1. choose only the repository topology the project needs;
2. define the host vs project execution boundary;
3. expose public commands before many ad-hoc scripts accumulate;
4. define deterministic resource naming;
5. define Work Root/repository mappings through the Work model when Work management is used;
6. verify build/test/diagnostics from a clean bootstrap.

## 17. Brownfield Adoption

For an existing project:

1. audit host dependencies, Docker definitions, scripts, commands, resources, Git practices, and CI;
2. identify safety/reproducibility problems;
3. add stable public operations around existing behavior before large rewrites;
4. migrate high-risk host/project-runtime leakage first;
5. preserve project-specific constraints;
6. avoid an all-at-once environment rewrite unless the requested outcome requires it.

General brownfield scope rules live in `ENGINEERING_OPERATING_MODEL.md`.

## 18. Diagnosis and Recovery Order

When execution fails, inspect:

```yaml
1_selection: "project, Work, repository, checkout/worktree"
2_host_boundary: "required control-plane tools and permissions"
3_versions: "runtime/tool versions and lock files"
4_runtime: "containers, ports, mounts, volumes, ownership"
5_commands: "public parameters and exit status"
6_git: "dirty state, branch/worktree metadata, remote refs"
7_ci_difference: "provider/setup/workspace-ref differences"
```

Prefer scoped recreation over global cleanup.

Preserve source changes before rebuilding/deleting state.

Do not claim repair until the failing operation is rerun successfully.

## 19. Environment Change Risk

Use the shared confirmation model in `ENGINEERING_OPERATING_MODEL.md`.

Typical specialization:

```yaml
L0:
  examples: ["help", "status", "read-only diagnostics"]
L1:
  examples: ["new non-destructive target", "new diagnostic script", "contained Work-scoped runtime configuration"]
L2:
  examples: ["new repository topology", "moving roots", "changing canonical public command names", "changing CI workspace/ref policy"]
L3:
  examples: ["discarding dirty work", "deleting persistent volumes/databases", "global cleanup", "installing/removing host runtimes", "history rewriting"]
```

A command implementation must not downgrade the effective risk by hiding a destructive effect behind a harmless name.

## 20. Common Misreadings

- Docker-first does not ban host control-plane tools.
- reproducibility does not require immutable toolchains forever.
- safe caches do not need per-Work duplication.
- one Work does not imply one unique Docker image.
- a public command interface does not mean every shell operation becomes a Make target.
- safety does not justify hiding destructive effects behind generic names.
