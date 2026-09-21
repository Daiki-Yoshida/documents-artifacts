# Environment Standards

```yaml
document_type: "environment_standards"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.4.1"
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

Every resource must be attributable to a project and, when its lifecycle is narrower, to a Work Identity.

```yaml
identity_components:
  required: ["workspace or project slug", "resource role"]
  conditional: ["environment", "component/repository", "work identity"]
properties:
  - "deterministic"
  - "human-readable"
  - "collision-resistant within the host"
  - "usable for scoped cleanup and diagnosis"
```

- Prefer meaningful Work Identity over random or execution-count identifiers.
- A subsystem may normalize the formatted string for Docker, filesystem, database, or provider constraints, but the mapping back to the Work Identity must be deterministic.
- Apply the Work Identity to containers, networks, mutable volumes, test state, logs, and generated work outputs when those resources are actually Work-scoped.

### Resource Scope

Classify state by lifecycle before deciding whether to duplicate it.

```yaml
project_scoped:
  meaning: "safe to share across Works and longer-lived than one Work"
  examples: ["shared images", "immutable dependency caches", "SDK/tool caches", "safely reusable read-only state"]
work_scoped:
  meaning: "owned by one Work Identity"
  examples: ["work branch", "optional worktree", "isolated mutable runtime", "test database/state", "logs", "Work Documents", "generated work outputs"]
run_scoped:
  meaning: "owned by one execution inside a Work"
  examples: ["one test process", "temporary file", "single command output"]
ownership_rule: "Run-scoped state remains subordinate to its Work Identity; execution count does not create a new Work."
```

### Resource Creation and Reuse

- A Work Identity, branch, or worktree does not by itself require a separate image, container, network, volume, database, or cache.
- Reuse project- or component-scoped images and safe caches when their inputs and mutation behavior make sharing correct.
- Create separate runtime resources only when concurrent execution, mutable-state isolation, differing configuration, or explicit project policy makes sharing unsafe or incorrect.
- Do not rebuild or retag an image merely because the selected Work, branch, checkout, or worktree changed; rebuild when image inputs or required toolchains changed.
- Allocate only the narrowest separate resource set required by the actual isolation need.

### Files, Ownership, and Mounts

- Container-created host files must be editable and removable by the host user.
- Map UID/GID or use an equivalent ownership strategy for bind-mounted outputs.
- Do not normalize permission failures by running the entire development container as root.
- Keep generated files out of source directories unless the project explicitly owns them there.
- Exclude caches and build outputs from Git.

### Caches and Volumes

- Share immutable or safely reusable dependency caches when this improves speed without cross-Work corruption.
- Isolate mutable state that can alter test or runtime results when multiple checkouts run concurrently.
- Name volumes so ownership and deletion scope are clear.
- Removing a worktree must not silently remove shared caches used by other Works.

### Ports and Networks

- Parallel checkouts must not claim the same fixed host ports without an allocation rule.
- Prefer internal container networking when host exposure is unnecessary.
- When host ports are required, derive or configure them explicitly per isolated Work.
- A cleanup command must affect only the selected project's or Work's network resources.

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

### Worktree Public Command Contract

Projects that expose Work Root Git worktrees must provide stable semantic operations equivalent to:

```yaml
worktree_create: "create or reuse one repository checkout for a confirmed Work Identity"
worktree_status: "inspect the resolved repository/branch/path/materialization without mutation"
worktree_remove: "remove only the selected Git worktree after safety checks"
```

When Make is the public router and no stronger project convention exists, prefer `worktree-create`, `worktree-status`, and `worktree-remove`.

Routine identity input is uniform across single- and multi-repository projects:

```yaml
required:
  WORK: "<work-type>/<work-name>"
  REPO: "<stable project repository selector>"
conditional:
  BASE: "required for new branch creation unless the project has a documented default base"
```

- Require `REPO` even for a single-repository project so the public contract does not change when project topology changes.
- Derive the Work Root path, repository root, and repository-specific branch from project-owned deterministic policy.
- Do not require routine callers to provide an arbitrary filesystem path, sparse-checkout decision, or branch name.
- Never use the currently checked-out HEAD as an accidental base for a missing Work branch; use explicit `BASE` or a documented project default.
- Treat a branch **base/start ref** and its **upstream tracking ref** as separate decisions. Creating a new Work branch from `main`/another base MUST NOT automatically make that base branch the Work branch's upstream.
- A same-name remote Work branch may be configured as upstream when project policy explicitly selects it; that is distinct from using a base ref only as the starting commit.
- Keep Git/filesystem/runtime systems as their own state sources of truth. Do not create a duplicate registry of current worktrees or runtime state merely to support the command.
- Keep complex resolution, validation, and Git orchestration behind a project-owned script/wrapper rather than inline Make shell.
- Project-level worktree lifecycle commands must resolve the Project Root from a stable, explicit anchor. If invocation from a linked worktree would make that resolution ambiguous, fail closed or require invocation from the Project Repository Primary checkout rather than treating the linked checkout as a new Project Root.

#### Create semantics

`worktree-create` (or equivalent) must be fail-closed and idempotent:

```yaml
exact_existing_valid_worktree: "no-op success; report the resolved existing state"
conflicting_worktree_or_branch: "fail; do not steal or rewrite another writable checkout"
unrelated_target_path_content: "fail; do not delete or overwrite it"
partial_creation_failure: "roll back only state created by this invocation when normal non-force cleanup is safe; otherwise report residual state"
```

Branch deletion is not part of normal create rollback.

#### Status semantics

`worktree-status` is non-mutating and should expose at least:

- Work Identity and repository selector;
- resolved repository root, Work branch, and worktree path;
- registered/not-registered state;
- current branch/HEAD and clean/dirty state when present;
- whether the Worktree Materialization Contract applies;
- sparse/materialization state when applicable;
- whether nested Project-level `.worktrees/` is absent/present;
- Work Documents visibility/tracking when relevant.

#### Remove semantics

`worktree-remove` removes only the selected repository worktree.

- Refuse dirty worktrees in the normal path.
- Verify commit preservation according to project policy.
- Use normal non-force worktree removal.
- Do not delete the Work branch, Work Documents, Work Root, or sibling repository worktrees.
- Work completion and Work Root removal remain higher-level lifecycle operations.

## 4. Git Operation Safety

- Establish and explicitly confirm the Work Identity before implementation begins.
- When Git is available, ordinary implementation should use a branch that deterministically represents the Work Identity according to project naming conventions.
- Keep the default branch stable for implementation code; Work Documents are the deliberate exception described by the Work Root model.
- A Work branch does not require a Git worktree. Use the current or Primary Checkout when one writing Work is active and no separate isolation is needed.
- Create a Git worktree only for concurrent writing, a required stable secondary checkout, an independently disposable runtime, or another documented isolation need.
- Do not create a worktree merely because `.worktrees/` exists or helper commands are available.
- One writable checkout maps to one writing agent at a time.
- Verify the selected repository, Work Identity, branch, and checkout before mutation; verify the worktree path as well when one is used.
- Do not operate on repositories outside the declared project/workspace scope.
- Normal worktree removal must refuse dirty worktrees.
- Check for unpushed or otherwise unpreserved commits before removal when the workflow can determine this reliably.
- Force removal belongs to an explicitly destructive command; never hide `--force` behind the normal remove operation.
- Worktree cleanup and branch deletion are separate decisions.
- Pruning stale Git metadata must not be treated as permission to delete live directories.
- Push, force-push, branch deletion, and history rewriting remain explicit operations.

### Work Root Worktree Materialization Support

Projects that create repository worktrees under Work Roots must:

- encode Work Root worktree creation in a project-owned helper/command rather than requiring operators to remember low-level Git setup;
- detect/know whether the selected repository branch contains tracked Project-level `.worktrees/**` coordination state;
- when it does, support and verify a Git version whose linked worktrees can use worktree-local sparse checkout without changing Primary Checkout materialization;
- for that case, create with `--no-checkout`, apply the Project-level `.worktrees/` exclusion, then materialize the branch;
- reapply that materialization setup whenever such a linked worktree is recreated;
- expose diagnosis sufficient to verify the selected branch, worktree Git dir/common dir, sparse configuration, and absence of nested Project-level `.worktrees/`.

Do not apply Project-level `.worktrees/` sparse exclusion to an independent repository merely because its worktree happens to live under the Work Root. A plain `git worktree add` is specifically insufficient when the selected repository branch itself tracks the Project-level Work Documents/coordination tree.

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
- A project cleanup command must select resources by deterministic project/Work Identity.
- Database reset, volume removal, worktree force removal, and remote deployment destruction must not share a vague `clean` target.

## 6. Diagnostics and Validation

A project environment should expose operations equivalent to:

```yaml
discovery: "list available operations and required parameters"
diagnosis: "report tool versions, selected repository/checkout, containers, ports, mounts, and common configuration failures"
status: "show current project/Work resources without mutation"
validation: "run the canonical completion gate"
```

- Diagnostics must not print secrets.
- Diagnostic output should identify the selected checkout and, when applicable, the worktree and container namespace. For Work Root worktrees, it should also make sparse/materialization state inspectable.
- Validation should start with the narrowest useful checks during implementation and finish with the canonical gate before completion is reported.
- Do not claim completion when the canonical gate fails or was not runnable; report the limitation and evidence.

## 7. Local and CI Parity

- CI should invoke project-owned commands rather than reimplementing build/test logic in workflow YAML.
- Local and CI execution may differ in provisioning, but should converge on the same validation scripts.
- Provider-specific setup remains at the CI edge; project behavior remains in repository-owned commands.
- If a Component Repository consumes a separate Workspace Repository in CI, the selected workspace version/ref must be explicit.
- CI must not depend on an unversioned external workspace by accident.
