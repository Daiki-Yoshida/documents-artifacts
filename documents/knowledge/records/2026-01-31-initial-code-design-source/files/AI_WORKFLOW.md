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
  1_analysis: "Understand the Requirement & User Intent"
  2_design: "Define Interfaces & Contracts (The 'What')"
  3_approval: "Confirm Design with User"
  4_implementation: "Implement Details (The 'How')"
  5_verification: "Validate against Contracts"
```

---

## Step 1: Interface-First Design

**Rule**: Never start implementing logic until the Interfaces are defined.

1.  **Draft Interfaces**: Propose the `interface` definitions first.
    *   Focus on method signatures, return types (Result vs Task), and dependencies.
    *   Do not write method bodies yet.
2.  **Check Capability**: Ensure the interface represents a *Cohesive Capability* (from `DESIGN_PHILOSOPHY`).
3.  **Propose to User**: Show the interface definition to the user.
    *   *Self-Correction*: "Does this interface leak implementation details?"

---

## Step 2: Implementation

Once interfaces are agreed upon (or if the task is trivial):

1.  **Dependency Injection**:
    *   Define the class with `I...` dependencies in the constructor.
    *   Do not `new` up volatile dependencies.
2.  **Internal Logic**:
    *   Implement the logic behind the interface.
    *   You are free to optimize internals (buffering, caching) as long as the interface contract holds.
    *   Follow `CODING_STANDARDS` for Error Handling (Result vs Exception).

---

## Step 3: Verification

1.  **Contract Compliance**:
    *   Does the implementation strictly adhere to the Interface contract?
    *   Does it pass the Contract Tests (if applicable)?
2.  **Constraint Check**:
    *   did I introduce any illegal states? (Type-Driven Design check)
    *   did I leak domain entities to the boundary? (Layer check)

---

## Special Instructions

### Handling "How to Approach" Questions
When the user asks "How should I do this?", do NOT jump to code.
1.  Explain multiple approaches (Option A vs Option B).
2.  Compare trade-offs (Complexity vs Performance vs Maintainability).
3.  Recommend one based on `DESIGN_PHILOSOPHY`.
