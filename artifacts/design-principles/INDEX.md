# AI Agent Guidance - Index

```yaml
document_type: "index"
target_audience: "ai_agents"
optimization: "token_efficiency"
language: "english"
role: "entry point for the exported design guidance set"
```

This is the entry point for the exported guidance. Read it first.

## Read Order

```yaml
1_philosophy: "DESIGN_PHILOSOPHY.md"   # WHY:   core values, Bounded Contracts, design priorities
2_standards:  "CODING_STANDARDS.md"    # HOW:   interfaces, layering, DI, errors, models, tests
3_structure:  "PROJECT_STRUCTURE.md"   # WHERE: public surface, shared kernel, runtime topology, test placement
4_workflow:   "AI_WORKFLOW.md"         # FLOW:  per-task operating procedure & discipline
```

On first contact, read 1 → 2 → 3 → 4. For a specific task, jump via the Ownership Map below.

## Document Split Policy

```yaml
split_by: "the question each doc answers — WHY (philosophy) / HOW (standards) / WHERE (structure) / FLOW (workflow); INDEX routes."
one_owner: "each concept lives in exactly ONE doc — see Ownership Map; link, never duplicate."
restatement_cap: "when a doc needs a concept it does not own, restate AT MOST one sentence + a link to the owner; on any apparent conflict between docs, the OWNING doc's wording is authoritative."
why_vs_how: "a topic may split as principle (why) vs normative rule (how/where), joined by 'single source of truth' pointers."
not_split_by: ["audience", "language", "feature/domain"]   # all docs are AI-facing, English, language-agnostic
```

## Foundational Lens

These artifacts assume a **Contract-Oriented, boundary-driven** paradigm.

```yaml
contract: "Signature + Semantics + Constraints"
interpret_through: ["boundaries", "contracts", "responsibilities", "side-effect containment"]
do_not_optimize_for: ["class count", "inheritance depth", "paradigm purity"]
core_idea: "OOP is the Shell, not the Core Logic. The contract is the design; implementation is replaceable."
scale_invariant: "the boundary principle is recursive — function -> class -> module -> library -> service -> app/API; module is the privileged operating scale (see DESIGN_PHILOSOPHY.md -> Boundaries Are Recursive)."
```

## Ownership Map (Single Source of Truth)

Each concept has exactly ONE authoritative document. Do not duplicate; link instead.

```yaml
DESIGN_PHILOSOPHY.md:
  owns:
    - "Bounded Contracts: definition & rationale"
    - "Design priority order"
    - "Shell vs Core Logic"
    - "Responsibility-driven design (SRP)"
    - "Composition over inheritance"
    - "Fail-fast & side-effect / environment protection policy"
    - "Type-Driven State Design: the principle (the WHY)"
    - "Internal paradigm agnosticism: the principle (the WHY)"
    - "Performance vs. abstraction policy: load-bearing requirements, evidence, and when interaction shape may change (the WHY)"
    - "Appropriate complexity / YAGNI"
    - "Concept Altitude: consumer-neutral meaning, semantic-identity evidence, and separation from physical sharing (the WHY)"
    - "State ownership & cross-boundary consistency responsibility: the boundary principle (the WHY)"
    - "Mistake prevention priority"
    - "External dependency containment: the principle (the WHY)"
    - "Boundaries are recursive / scale-invariant: the principle (the WHY)"
    - "Module as the primary boundary: the principle (the WHY)"
    - "Module shell vs internal & accuracy-vs-speed: the principle (the WHY)"
    - "Encapsulation Horizon: the hardening line, macro→micro (harden public surfaces by default), module as initial-horizon prior, harden-when guards, dynamic re-draw (the WHY)"
    - "Interior freedom <-> surface completeness duality & leakage channels (the WHY)"
    - "Refined AND test (warning, not auto-split: subordinate vs peer-level)"
    - "Common misreadings to prevent"
    - "Responsibility anti-patterns (god service, etc.)"
    - "Domain purity (mechanism vs concept): the principle (the WHY)"

CODING_STANDARDS.md:
  owns:
    - "Interface design & naming"
    - "Contract semantics: declare resource/performance & determinism bounds (close leakage channels)"
    - "Interface segregation (ISP)"
    - "Concept Generality rule: semantic-identity checks, consumer-neutral naming/types, feature-policy placement, local-before-shared"
    - "Layering & contract placement"
    - "Dependency Injection rules"
    - "Error handling (Result vs Panic)"
    - "Error boundary translation"
    - "Concurrency & async contracts"
    - "Contract evolution & versioning: compatibility from both consumer and provider sides; additive shape is not proof"
    - "Performance-shaped contracts: evidence gate, batch/stream/pagination/async interaction shape, medium-specific compatibility, and verification (the HOW)"
    - "Internal maturation-split preserves the outer contract"
    - "Domain modeling (Rich vs Anemic)"
    - "Entity mutability & Type-Driven State: the normative pattern (the HOW)"
    - "State ownership & cross-boundary consistency: state owner, orchestration owner, failure/consistency model"
    - "Internal implementation flexibility & paradigm consistency: the normative rule (the HOW)"
    - "External Dependency Boundary Policy: the normative rule (the HOW)"
    - "Module layout (feature-first; layers inside)"
    - "Module-local vs public/cross-module interface rule (the rule; structural mechanism → PROJECT_STRUCTURE.md)"
    - "UseCase / Application Service responsibilities"
    - "Domain purity rules & examples (the HOW)"
    - "Mapping & conversion policy (placement, naming)"
    - "Testing strategy: contract conformance vs requested-outcome verification"
    - "Testing by boundary"

PROJECT_STRUCTURE.md:
  owns:
    - "Module public surface & default-internal: the structural mechanism (the WHERE)"
    - "Cross-module dependency rule (depend on the public surface)"
    - "Shared kernel & cross-cutting tiers (T0 kernel / T1 ports / T2 contracts / T3 shared VOs) + placement"
    - "Runtime topology & multi-deployable layout (frontend + backend; the runtime seam as a contract)"
    - "Composition root placement"
    - "Test file placement (co-location; contract-suite beside the port; fakes; e2e location)"

AI_WORKFLOW.md:
  owns:
    - "Per-task process: required outcome -> analysis -> contract -> risk gate -> implementation -> contract + requirement verification"
    - "Contract Confirmation Gate (severity levels L0–L3; L2 compatible public evolution vs L3 published breaking)"
    - "Pre-implementation scan (task outcome / module shell & horizon / responsibility / concept altitude + semantic identity / state ownership + consistency / dependency spread / mapping / accuracy-vs-speed / load-bearing performance)"
    - "Compatibility check before classifying an existing public-contract evolution"
    - "Load-bearing performance evidence check before redesigning interaction shape"
    - "Scan proportionality (scale analysis effort to blast radius)"
    - "Brownfield policy (existing violations, local-convention precedence)"
    - "Operational discipline (reporting language, test timing, commit rules)"
    - "Worked example (end-to-end task walkthrough)"
```

## Quick Task Routing

```yaml
"defining a new service/repository":      "AI_WORKFLOW.md (Step 1) + CODING_STANDARDS.md (Interface Design)"
"placing a contract in a layer":          "CODING_STANDARDS.md (Architectural Boundaries)"
"handling failures":                      "CODING_STANDARDS.md (Error Handling + Boundary Translation)"
"async / threading decision":             "CODING_STANDARDS.md (Concurrency & Async Contracts)"
"changing an existing public contract":   "CODING_STANDARDS.md (Contract Evolution) + AI_WORKFLOW.md (Compatibility Check + Confirmation Gate)"
"performance requirement changes API shape": "DESIGN_PHILOSOPHY.md (Performance vs. Abstraction Policy) + CODING_STANDARDS.md (Performance-Shaped Contracts) + AI_WORKFLOW.md (Load-Bearing Performance)"
"is an additive change actually compatible?": "CODING_STANDARDS.md (Contract Evolution) + AI_WORKFLOW.md (Compatibility Check)"
"modeling a domain entity":               "CODING_STANDARDS.md (Domain Modeling) + DESIGN_PHILOSOPHY.md (Shell vs Core Logic)"
"using an external library / SDK / API":  "CODING_STANDARDS.md (External Dependency Boundary Policy) + AI_WORKFLOW.md (Pre-Implementation Scan)"
"organizing modules / project layout":    "PROJECT_STRUCTURE.md + DESIGN_PHILOSOPHY.md (Module — The Primary Boundary) + CODING_STANDARDS.md (Architectural Boundaries)"
"where to draw the hard boundary / when to split": "DESIGN_PHILOSOPHY.md (Encapsulation Horizon) + CODING_STANDARDS.md (Interface Requirement Threshold)"
"is this AND a real split?":               "DESIGN_PHILOSOPHY.md (Responsibility-Driven Design — Refined AND)"
"is this feature-specific or a general concept?": "DESIGN_PHILOSOPHY.md (Concept Altitude) + CODING_STANDARDS.md (Concept Generality)"
"who owns a cross-state business outcome?": "CODING_STANDARDS.md (State Ownership & Cross-Boundary Consistency) + DESIGN_PHILOSOPHY.md (State Ownership & Consistency Responsibility)"
"how much to confirm before changing?":    "AI_WORKFLOW.md (Contract Confirmation Gate — L0–L3)"
"did the implementation actually satisfy the request?": "AI_WORKFLOW.md (Step 3: Requirement Satisfaction) + CODING_STANDARDS.md (Testing Strategy)"
"module public vs internal surface":       "PROJECT_STRUCTURE.md (Module Public Surface)"
"where to put shared / Result / Clock":    "PROJECT_STRUCTURE.md (Shared Kernel & Cross-Cutting)"
"frontend + backend / multi-runtime":      "PROJECT_STRUCTURE.md (Runtime Topology)"
"where do test files go":                  "PROJECT_STRUCTURE.md (Test File Placement) + CODING_STANDARDS.md (Testing Strategy)"
"mapping / DTO conversion":               "CODING_STANDARDS.md (Mapping & Conversion Policy)"
"is a value Domain or UI?":               "CODING_STANDARDS.md (Domain Purity Rules)"
"existing code violates these standards":  "AI_WORKFLOW.md (Brownfield Policy)"
"how should I approach this?":            "AI_WORKFLOW.md (Special Instructions)"
```