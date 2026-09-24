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
  3_approval: "Confirm Contracts with User"
  4_implementation: "Implement Internals (The 'How')"
  5_verification: "Validate against Contracts"
```

---

## Step 1: Define Boundaries & Contracts

**Rule**: Never start implementing logic until the Bounded Contract is defined.

**Distinguish the Component Type**:
*   **Case A: Behavioral Component** (Services, Repositories, Managers)
    *   **MUST** define an `interface`.
    *   **focus**: The "Contract" is the interaction boundary.
*   **Case B: Domain Model** (Entities, Value Objects)
    *   **MUST NOT** define an `interface` (unless for polymorphism).
    *   **focus**: The "Contract" is the Class State invariant & public Behavior.

### Process
1.  **Draft Contracts**:
    *   **Behavioral**: Define `interface` + Semantics (What happens? Side effects?).
    *   **Domain**: Define `class` + Invariants (What state is valid? How does it transition?).
2.  **Check Boundary Stability**: Is this boundary clear? Does it leak implementation details?
3.  **Propose to User**: Show the contract definition.
    *   *Self-Correction*: "Is this contract stable enough to hide future implementation changes?"

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

## Special Instructions

### Handling "How to Approach" Questions
When the user asks "How should I do this?", do NOT jump to code.
1.  Explain multiple approaches (Option A vs Option B).
2.  Compare trade-offs (Complexity vs Performance vs Maintainability).
3.  Recommend one based on `DESIGN_PHILOSOPHY`.
