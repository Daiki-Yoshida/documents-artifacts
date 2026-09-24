# Environment Standards

```yaml
document_type: "environment_standards"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.1.1"
scope: "host boundary, Docker, command interface, Git safety, validation, and CI parity"
```

## 1. Host Dependency Boundary

Classify tools by responsibility rather than maintaining a universal package allowlist.

```yaml
host_default:
  allowed_roles:
    - "container runtime and Compose"
    - "source control"
    - "command router"
    - "authentication and remote access"
  examples: ["Docker", "Git", "GitHub CLI", "Make", "shell", "SSH", "tmux"]
container_default:
  owned_roles:
    - "language runtime"
    - "package manager"
    - "compiler and build toolchain"
    - "test runtime"
    - "database and migration CLI"
    - "project-specific cloud or deployment CLI"
```

Rules:

- Do not require project runtimes on the host when repository-controlled container execution is practical.
- Do not install host packages merely because one agent finds a container command inconvenient.
- A host exception must state why container execution is unsuitable and how version drift is controlled.
- Interactive desktop tools may remain host-owned when containerization would remove essential interaction; keep their CLI/build counterpart container-owned where practical.
- Never use elevated host privileges as a routine project operation.

## 2. Docker Standards

### Docker-First Execution

- Project build, test, lint, format, migration, and project-specific CLI operations should run through repository-owned Docker definitions.
- Dockerfiles and Compose files are source-controlled environment definitions, not personal setup notes.
- Avoid hidden dependencies on pre-existing host networks, globally installed packages, or manually prepared containers.
- Pin meaningful runtime/tool versions. Avoid floating `latest` tags for load-bearing tools.
- Respect package lock files inside the container.

### Resource Identity

Every resource must be attributable to a project and, when relevant, a task or worktree.

```yaml
identity_components:
  required: ["workspace or project slug", "resource role"]
  conditional: ["environment", "component", "task/worktree identity"]
properties:
  - "deterministic"
  - "human-readable"
  - "collision-resistant within the host"
  - "usable for scoped cleanup and diagnosis"
```

- Avoid generic names that reveal only a role, such as an unscoped `web`, `api`, or `database`.
- Avoid random names when a stable project/task identity is available.
- Use a task-specific Compose project name only when parallel or explicitly isolated checkouts may run simultaneously.
- Apply the same identity to containers, networks, mutable volumes, logs, and temporary output locations where practical.

### Resource Creation and Reuse

- A task, branch, or worktree identity does not by itself require a separate image, container, network, or volume.
- Reuse project- or component-scoped images and safe caches when their build inputs are equivalent.
- Create separate runtime resources only when concurrent execution, mutable-state isolation, differing configuration, or explicit project policy makes sharing unsafe or incorrect.
- Do not rebuild or retag an image only because the selected checkout, branch, task, or worktree changed; rebuild when image build inputs or the required toolchain changed.
- Allocate only the narrowest separate resource set required by the actual isolation need.

### Files, Ownership, and Mounts

- Container-created host files must be editable and removable by the host user.
- Map UID/GID or use an equivalent ownership strategy for bind-mounted outputs.
- Do not normalize permission failures by running the entire development container as root.
- Keep generated files out of source directories unless the project explicitly owns them there.
- Exclude caches and build outputs from Git.

### Caches and Volumes

- Share immutable or safely reusable dependency caches when this improves speed without cross-task corruption.
- Isolate mutable state that can alter test or runtime results when multiple checkouts run concurrently.
- Name volumes so ownership and deletion scope are clear.
- Removing a task worktree must not silently remove shared caches used by other tasks.

### Ports and Networks

- Parallel checkouts must not claim the same fixed host ports without an allocation rule.
- Prefer internal container networking when host exposure is unnecessary.
- When host ports are required, derive or configure them explicitly per isolated task.
- A cleanup command must affect only the selected project's or task's network resources.

### Secrets

- Do not bake secrets into images or commit them to the repository.
- Separate examples/templates from real values.
- Do not echo secrets in command output, logs, diagnostics, or CI traces.
- Build-time and runtime secrets must be passed through mechanisms appropriate to their lifecycle.
- AI agents should not need to read secret values to perform ordinary build and test work.

## 3. Command Interface

The project must provide a discoverable public command interface for routine operations.

```yaml
preferred_shape:
  makefile: "public operation names, help, parameters, and simple dependencies"
  wrapper: "optional shared CLI entry that normalizes target selection and environment setup"
  scripts: "complex branching, validation, orchestration, cleanup, and provider-specific behavior"
```

### Makefile Rules

- Makefile targets express stable intent, not copied raw command lines.
- Keep complex shell logic in `scripts/` or an equivalent owned location.
- Provide a help target that lists operations, parameters, and destructive effects.
- Use explicit variables for structured parameters; avoid a single catch-all argument when it causes quoting or interpretation ambiguity.
- Local development and CI should call the same target or underlying script where practical.

### Target Naming

Use `<scope>-<action>` when the target or side effect would otherwise be unclear.

```yaml
clear_scopes: ["docker", "git", "worktree", "db", "test", "deploy", "provider"]
allowed_unscoped_names: "operations whose project-wide meaning is singular and documented"
prohibited_pattern: "an ambiguous short name whose target or destructive effect cannot be known before execution"
```

- Do not mechanically prefix every target.
- `help`, `check`, `test`, or `validate` may remain unscoped if each has one canonical project meaning.
- Lifecycle words such as `up`, `down`, `reset`, `clean`, `deploy`, or `logs` normally require a scope.
- Compatibility aliases may exist temporarily, but the canonical target must be documented.

### Operation Semantics

- Command documentation must state the target, observable effect, and destructive scope.
- A non-destructive command must not silently become destructive while keeping the same name.
- Separate stop, remove, volume deletion, and full purge when their data effects differ.
- A canonical final-validation operation must exist.
- Partial validation commands are diagnostic or implementation-time tools; they do not replace the final gate.
- Failed commands must return a non-zero exit status and preserve actionable output.

## 4. Git Operation Safety

- Keep the default branch stable. Ordinary feature implementation should occur on a task branch.
- A task branch does not require a Task Worktree. Use the currently assigned checkout when only one writing task is active and no separate isolation is needed.
- Create a Task Worktree only for concurrent writing, an explicitly requested stable secondary checkout, or another documented isolation need.
- Do not create a worktree merely because `.worktrees/` exists or worktree commands are available.
- One writable checkout maps to one writing agent at a time.
- Verify the selected repository and checkout before mutation; verify the worktree as well when one is used.
- Do not operate on repositories outside the declared workspace scope.
- Normal worktree removal must refuse dirty worktrees.
- Check for unpushed or otherwise unpreserved commits before removal when the workflow can determine this reliably.
- Force removal belongs to an explicitly destructive command; never hide `--force` behind the normal remove operation.
- Worktree cleanup and branch deletion are separate decisions.
- Pruning stale Git metadata must not be treated as permission to delete live directories.
- Push, force-push, branch deletion, and history rewriting remain explicit operations.

## 5. Destructive Operations

```yaml
normal:
  behavior: "preserve source changes and persistent data"
  confirmation: "not normally required"
destructive:
  behavior: "may discard source changes, commits, volumes, databases, caches, or remote state"
  requirements:
    - "explicit name"
    - "narrow resource scope"
    - "precondition checks"
    - "clear report of what was removed"
```

- Do not place broad host commands such as global Docker pruning in the ordinary project lifecycle.
- A project cleanup command must select resources by deterministic project/task identity.
- Database reset, volume removal, worktree force removal, and remote deployment destruction must not share a vague `clean` target.

## 6. Diagnostics and Validation

A project environment should expose operations equivalent to:

```yaml
discovery: "list available operations and required parameters"
diagnosis: "report tool versions, selected repository/checkout, containers, ports, mounts, and common configuration failures"
status: "show current project/task resources without mutation"
validation: "run the canonical completion gate"
```

- Diagnostics must not print secrets.
- Diagnostic output should identify the selected checkout and, when applicable, the task worktree and container namespace.
- Validation should start with the narrowest useful checks during implementation and finish with the canonical gate before completion is reported.
- Do not claim completion when the canonical gate fails or was not runnable; report the limitation and evidence.

## 7. Local and CI Parity

- CI should invoke project-owned commands rather than reimplementing build/test logic in workflow YAML.
- Local and CI execution may differ in provisioning, but should converge on the same validation scripts.
- Provider-specific setup remains at the CI edge; project behavior remains in repository-owned commands.
- If a Component Repository consumes a separate Workspace Repository in CI, the selected workspace version/ref must be explicit.
- CI must not depend on an unversioned external workspace by accident.
