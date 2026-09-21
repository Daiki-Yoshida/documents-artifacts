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

Interactive desktop tools may remain host-owned when containerization would remove essential interaction; keep their CLI/build counterpart container-owned where practical.

Typical host control-plane examples include Docker, Git, GitHub CLI, Make, shell, SSH, and tmux. This is a responsibility model, not a universal package allowlist.

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

Public routers such as Make should:

- express stable intent rather than copied raw command lines;
- provide help that lists operations, parameters, and destructive effects;
- keep complex shell logic in owned scripts;
- use explicit variables for structured parameters instead of one ambiguous catch-all argument;
- let local development and CI call the same target or underlying script where practical.

Compatibility aliases may exist temporarily, but the canonical target name must remain documented.

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

## 12. Diagnostics and Validation

A project environment should expose operations equivalent to:

```yaml
discovery: "list available operations and required parameters"
diagnosis: "report tool versions, selected repository/checkout, containers, ports, mounts, and common configuration failures"
status: "show current project/Work resources without mutation"
validation: "run the canonical completion gate"
```

Diagnostics must not print secrets.

Diagnostic/status output should identify the selected checkout and, when applicable:

- Work Identity and repository;
- worktree path/branch;
- container namespace;
- runtime/network/volume state;
- ports and mounts;
- file ownership;
- public command parameters;
- sparse/materialization state when the Worktree Materialization Contract applies;
- common configuration failures.

Validation starts with the narrowest useful checks during implementation and finishes with the canonical final gate before completion is reported.

Do not claim completion when the canonical gate fails or cannot run; report the limitation and evidence instead.

Diagnostics should expose enough state to verify worktree materialization without hard-coding Git's internal administrative-directory naming.

## 13. Canonical Validation

Every project should provide a canonical final-validation operation or documented equivalent.

Partial checks are useful during implementation but do not replace the final gate.

Local validation and CI should invoke the same public operation or underlying script where practical.

Validation depth follows `ENGINEERING_OPERATING_MODEL.md`.

## 14. Local / CI Parity

CI should invoke project-owned commands rather than reimplementing build/test logic in workflow YAML.

Local and CI provisioning may differ, but they should converge on the same repository-owned validation scripts/operations.

Provider-specific setup stays at the CI edge; project behavior stays in repository-owned commands.

Differences that remain should be explicit:

- provider authentication;
- environment/service availability;
- secret injection;
- workspace/ref selection;
- platform-specific interactive tooling.

If a Component Repository consumes a separate Workspace Repository in CI, the selected workspace version/ref must be explicit. CI must not accidentally depend on an unversioned external workspace.

Do not maintain completely separate local and CI logic when one repository-owned path can serve both.

## 15. Reproducibility

Repository state should control enough of the environment to recreate its behavior.

- pin or constrain meaningful tool versions;
- honor dependency locks;
- declare external tooling version selection;
- eliminate undocumented host dependencies;
- make environment-definition changes intentional and reviewable.

Reproducibility does not mean "never update". It means environment changes are attributable.

### External workspace/tool dependency

When a Component Repository consumes tooling from a separate Workspace Repository, select that dependency explicitly.

```yaml
moving_ref:
  meaning: "documented branch/current workspace checkout"
  tradeoff: "easy updates, weaker historical reproducibility"

fixed_ref:
  meaning: "tag or commit"
  tradeoff: "strong historical reproducibility, deliberate update required"
```

Local convenience may use a moving/current workspace checkout. Formal CI/release validation must not accidentally consume an unspecified workspace version/ref.

## 16. New Project Bootstrap

When setting up an environment:

1. choose only the repository topology the project needs;
2. define the host vs project execution boundary;
3. expose public commands before many ad-hoc scripts accumulate;
4. define deterministic resource naming;
5. define Work Root/repository mappings through the Work model when Work management is used;
6. verify build/test/diagnostics from a clean bootstrap.

## 17. Brownfield Adoption

Do not turn environment adoption into an unrelated repository or code rewrite.

Audit:

```yaml
host_dependencies: "installed runtimes, package managers, SDKs, and CLIs"
entry_commands: "documented and undocumented build/test/deploy commands"
container_state: "images, Compose files, names, ports, volumes, permissions"
git_topology: "repository roots, embedded repositories, branches, optional worktrees"
ci_behavior: "logic duplicated or diverging from local scripts"
destructive_paths: "cleanup, reset, force removal, and data deletion"
```

Migration order:

1. establish a stable public command interface over current behavior;
2. move project-specific execution into controlled containers;
3. introduce Work Identity and normalize resource ownership;
4. establish uniform Work Root and Work Documents ownership;
5. add diagnosis and canonical validation;
6. add/normalize Git worktree support only when parallel development or explicit isolation requires it;
7. align CI with project-owned commands.

Preserve working behavior while changing one environment boundary at a time.

Guards:

- explicit project conventions outrank generic reusable guidance when they conflict; report the conflict;
- do not silently move repositories or delete environment state;
- do not introduce separate Workspace/Component repositories unless the requested change requires that topology;
- do not introduce Git worktrees when the current checkout already satisfies one active Work;
- report out-of-scope violations instead of opportunistically rewriting them.

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

## 20. Re-read Triggers

```yaml
must_re_read:
  - "first contact with a project using this execution model"
  - "creating or changing Workspace/Component repository topology"
  - "adding or redesigning worktree support"
  - "changing the host/container boundary"
  - "adding destructive environment operations"

should_re_read:
  - "changing Docker resource naming or isolation"
  - "changing Makefile/public command structure"
  - "aligning local and CI execution"
  - "changing Workspace-tool version selection"

no_re_read_needed:
  - "routine use of established commands"
  - "choosing the current checkout for an ordinary single-writer Work"
  - "ordinary Git worktree creation after a real isolation trigger is established"
  - "small internal script fix behind an unchanged public command contract"
```

## 21. Common Misreadings

- Docker-first does not ban host control-plane tools.
- reproducibility does not require immutable toolchains forever.
- safe caches do not need per-Work duplication.
- one Work does not imply one unique Docker image.
- a public command interface does not mean every shell operation becomes a Make target.
- safety does not justify hiding destructive effects behind generic names.
