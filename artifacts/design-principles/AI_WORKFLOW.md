# AI Agent Workflow - Operational Guidelines

```yaml
document_type: "daily_workflow"
target_audience: "ai_agents"
optimization: "process_consistency"
language: "english"
```

## Core Thinking Process

Before writing any code, the AI must establish a mental model of the solution.

```yaml
process_flow:
  1_analysis: "Understand Boundaries & User Intent"
  2_design: "Define Bounded Contracts (The 'What')"
  3_risk_gate: "Decide whether contract confirmation is required"
  4_implementation: "Implement Internals (The 'How')"
  5_verification: "Validate against Contracts"
```

> The numbered Steps below group these phases: **Step 1** covers phases 1–3, **Step 2** covers phase 4, **Step 3** covers phase 5.

---

## Step 1: Define Boundaries & Contracts

**Rule**: Never start implementing logic until the Bounded Contract is defined.

**Distinguish the Component Type**:
*   **Case A: Behavioral Component** (Services, Repositories, Managers, Adapters, Ports)
    *   **MUST define or reuse a project-owned contract at a real boundary** — the define/omit thresholds live in `CODING_STANDARDS.md` → "Interface Requirement Threshold".
    *   **focus**: The "Contract" is the interaction boundary.
*   **Case B: Domain Model** (Entities, Value Objects)
    *   **Do NOT** define an `interface` by default (only when the domain requires polymorphism — see `CODING_STANDARDS.md` → "Entity & ValueObject Exception").
    *   **focus**: The "Contract" is the Class State invariant & public Behavior.

### Pre-Implementation Scan
Before drafting contracts, run these checks (criteria are owned elsewhere — link, don't re-derive).

**Proportionality**: scale the scan to the blast radius. For L0-scope edits (typo, comment/doc fix, test-only change, private helper behind a stable shell) the scan collapses to a quick sanity check — do NOT produce a full boundary analysis for a one-line fix. Run it in FULL whenever a contract, module boundary, external dependency, or persistent data is touched.
1.  **Module Shell & Horizon**: Which "module" is meant (semantic responsibility / code package / deployable / current hardening-horizon)? What is its outer contract, who calls it, and what must NOT leak out? Descend **macro → micro, hardening public surfaces by default**; below the module stay flexible unless the responsibility is **stable** and the seam **cheap**; in an immature domain do not descend below the module. (Doctrine: `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon + Module Shell vs Internal Implementation.)
2.  **Responsibility**: One-sentence job? Judged by reason-to-change & caller-visible capability? Mixing Functional/Technical/Orchestration? Becoming a *god service*? Using DTOs as Domain models? UI/Infra logic flowing inward? (See `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design + Anti-Patterns.)
3.  **Concept Altitude**: Is the concept more general than the feature requesting it (its one-sentence responsibility needs no feature name)? Then model it consumer-neutral — neutral name, no feature-type imports, feature-specific policy behind the concept's contract; physical extraction may wait. Do NOT invoke YAGNI to feature-couple a general concept. (See `DESIGN_PHILOSOPHY.md` → Concept Altitude; rules: `CODING_STANDARDS.md` → Concept Generality.)
4.  **Dependency Spread**: Introduce/spread an external dependency? Local, or will many modules depend on it? Does it touch Domain/Core language? Wrap with port/adapter/anti-corruption? Acceptable because it stays in UI/Infrastructure? (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
5.  **Mapping**: Is a conversion crossing a boundary? Which boundary owns it? Is Domain being made aware of an outer DTO/ViewModel/DB model? Inline or extract? (See `CODING_STANDARDS.md` → Mapping & Conversion Policy.)
6.  **Accuracy vs Speed**: Module shell / foundation → prioritize correctness. Private/internal behind a stable shell → prioritize simplicity & speed. (See `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal Implementation.)

> Weigh findings by **Mistake Prevention Priority** (`DESIGN_PHILOSOPHY.md`): responsibility mixing, contract breakage, and dependency spread outrank over-engineering.

### Process
1.  **Draft Contracts**:
    *   **Behavioral**: Define `interface` + Semantics (What happens? Side effects?).
    *   **Domain**: Define `class` + Invariants (What state is valid? How does it transition?).
2.  **Check Boundary Stability**: Is this boundary clear? Does it leak implementation details?
3.  **Apply the Contract Confirmation Gate** (severity levels — stay autonomous for safe work):
    *   **L0 internal** (private helper, internal refactor, tests, doc clarification) → **proceed**.
    *   **L1 local contract** (module-local interface, internal port, non-public DTO, test fake) → **proceed and report**.
    *   **L2 public additive** (new public method, new optional DTO field, endpoint required by the requested feature) → **proceed only if clearly implied by the task; report explicitly**.
    *   **L3 breaking / side-effect** (breaking DTO change, changed public semantics, new destructive op, new external side effect, persistent-data migration) → **MUST confirm before implementation**.
    *   **Self-Correction**: "Is this contract stable enough to hide future implementation changes?"
    *   **If unclear**: stop and ask for clarification before implementation.

---

## Step 2: Implementation (The Shell & The Core Logic)

**Mental Model (Behavioral Components)**: The Class is the **Shell** (OOP) containing the **Core Logic** (Internal).
**Mental Model (Domain Models)**: The Class **IS** the logic and state definition.

1.  **Build the Shell** (For Behavioral Components):
    *   Define the class implementing the interface.
    *   Inject dependencies via constructor (The "Plugs" of the shell).
2.  **Build the Core Logic**:
    *   Implement the logic *inside* the shell.
    *   Select Internal Paradigm: Functional, Procedural, Data-Oriented.
    *   **Constraint**: The Core Logic must satisfy the Shell's Contract (Signature + Semantics).

---

## Step 3: Verification

1.  **Contract Compliance**:
    *   Does the implementation strictly adhere to the Contract?
    *   Does it pass the Contract Tests?
2.  **Paradigm Check**:
    *   Did I accidentally expose an internal detail (e.g., returning a mutable internal list)?
    *   Did I maintain the boundary stability?

---

## Operational Discipline

Concrete operating rules applied to every task.

```yaml
reporting:
  thinking_and_interim: "english"
  final_report: "the user's language — reply in the language the user writes in"
  content: "state what changed, why, and any impact on a public contract"
testing:
  when: "Run tests after implementation, before declaring done."
  gate: "Contract Tests MUST pass before reporting completion. If tests fail, report the failure with output; never claim done."
  scope: "Run the narrowest relevant suite first; widen it if a contract boundary was touched."
version_control:
  commit: "Do NOT commit or push unless the user asks."
  branch: "If on the default branch, create a branch before committing."
  confirmation: "After changes and the final report, ask the user whether to commit."
clarification:
  rule: "If intent or the contract is unclear, STOP and ask before implementing."
```

---

## Brownfield Policy (existing code that violates these standards)

Target projects contain legacy code. These standards govern the code you **write**; they are NOT a mandate to rewrite what you find.

```yaml
brownfield_policy:
  new_code: "Code you add or modify follows these standards, even inside a non-conforming area."
  local_convention: "Explicit target-project conventions (project instructions, lint config, house style) OUTRANK these artifacts where they conflict; report the conflict once, then follow the local rule."
  on_violation_found: "Do NOT silently 'fix' surrounding violations. Note them in the report; leave the code as-is unless the task requires touching it."
  fixing_is_a_change: "Cleaning up an existing violation is its own change — classify it through the Contract Confirmation Gate (internal refactor = L0/L1; anything touching a published contract = L2/L3)."
  scope_guard: "Never let a violation hunt expand the task. Opportunistic refactors of unrelated code need explicit user approval."
```

---

## Special Instructions

### Handling "How to Approach" Questions
When the user asks "How should I do this?", do NOT jump to code.
1.  Explain multiple approaches (Option A vs Option B).
2.  Compare trade-offs (Complexity vs Performance vs Maintainability).
3.  Recommend one based on `DESIGN_PHILOSOPHY`.

---

## Worked Example (End-to-End)

Task: *"Add stairs to the dungeon so the player can move between floors."* (RPG project; a `dungeon` feature module exists.)

1.  **Proportionality**: new caller-visible capability on a module → run the full scan.
2.  **Scan**:
    *   *Module resolution*: "dungeon" here = the semantic feature module; the task introduces a new concept, not an edit to an existing contract.
    *   *Responsibility*: "move an actor between two connected locations when activated" — one sentence, no peer-level AND.
    *   *Concept altitude*: that sentence needs no "dungeon" → stairs is a **general concept**; the dungeon is its first consumer, not its owner. Model it consumer-neutral (`Transition` / `Stairs` — NOT `DungeonStairs`, no dungeon-type imports); dungeon-specific rules (spawn floor, locked-until-boss) stay dungeon-owned.
    *   *Dependency spread / mapping*: no external SDK; nothing crosses the module surface except the new contract.
    *   *Accuracy vs speed*: the activation contract is caller-visible → accuracy; movement/animation internals → speed.
3.  **Contract draft** (concept-owned, feature-neutral — may physically live in the dungeon module until a second consumer appears):

    ```pseudocode
    interface Transition {
      /// Moves the actor to the linked destination.
      /// Constraint: returns TransitionBlocked (Result error) if traversal is denied; no partial move.
      /// Side effect: relocates the actor; emits ActorMoved.
      activate(actor: ActorId) -> Result<Destination, TransitionError>
    }
    class BossGateTransition implements Transition { ... }   // dungeon-owned policy: denies until the boss is defeated
    ```
4.  **Gate**: a new public capability on the module surface, clearly implied by the task → **L2: proceed + report explicitly**. (Changing already-published traversal semantics would be L3 → confirm first.)
5.  **Implement**: internals are free (grid math, animation, pathfinding) but MUST NOT leak dungeon types through `Transition`.
6.  **Verify**: contract test on `Transition` semantics — success relocates and emits exactly once; a blocked transition returns the error with no partial move. Dungeon policy is tested inside the dungeon module. Do NOT extract a shared `traversal` module yet — promotion waits for a second consumer (Rule of Two/Three, `PROJECT_STRUCTURE.md`).
