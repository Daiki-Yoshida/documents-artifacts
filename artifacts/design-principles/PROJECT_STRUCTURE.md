# Project Structure & Boundaries - AI Agent Reference

```yaml
document_type: "project_structure"
target_audience: "ai_agents"
language: "english"
optimization: "structural_consistency"
scope: "physical layout — module public surface, shared kernel, runtime topology, test placement"
```

This document owns the **physical realization of boundaries**: how a module declares its
public surface, where shared / cross-cutting code lives, how multi-runtime projects (e.g.,
frontend + backend) are laid out, and where test files go.

```yaml
ownership_split:
  this_doc: "WHERE — placement & topology (public surface, shared kernel, runtime layout, test location)"
  CODING_STANDARDS.md: "HOW — in-module layer rules (domain/application/infrastructure/ui) and testing STRATEGY"
  DESIGN_PHILOSOPHY.md: "WHY — boundaries, contracts, dependency direction"
rule: "Do not duplicate the layer rules or the testing strategy here; link to CODING_STANDARDS."
```

> **Naming is intentionally NOT prescribed.** Filenames, casing, and suffixes depend on the
> language/ecosystem. This document defines **concepts** and maps each to the ecosystem's
> nearest mechanism — the same approach the other artifacts use for `interface`.

---

## 1. Module Public Surface (default-internal)

A module is a black box. It must declare **exactly ONE public surface**; everything else is
**internal**. Cross-module access goes through the public surface only — **no deep imports**.

> Here "module" = the chosen **hardening horizon** (default: the module; it may sit below or above — see `DESIGN_PHILOSOPHY.md` → Encapsulation Horizon). The public-surface mechanism applies to whatever unit you hardened.

```yaml
principle: "One public surface per module; default-internal; deep cross-module imports prohibited."
rationale: "This is Bounded Contracts made physical. It enforces Design Priority #2 (interface stability) and #3 (locality of change), and makes Mistake #3 (silent contract change) visible as a diff of the public surface."
```

> **Audience exception:** the default is ONE primary surface. Additional public surfaces are allowed **only when each names its audience, scopes what is stable, and has an evolution rule** (e.g. a test-support surface, an admin/internal surface, an event-contract surface). Do not spawn unnamed extra surfaces — that recreates the giant-facade / barrel-sprawl problem.

### What is on the surface vs internal

| On the public surface | Internal (never exported) |
| :--- | :--- |
| The module's **ports / contracts** (domain contracts, application ports) | **Infrastructure adapters** (DB/HTTP/queue clients) |
| **Request / Response DTOs** (boundary data) | Entity mutable internals & invariant enforcement |
| A **composition / factory** entry (so callers don't wire internals) | Mappers, converters, private helpers |
| **Domain errors** that cross the boundary | Temporary / refactorable internal structure |

> **Key rule:** Infrastructure is **not** part of the public surface. A module exposes its
> use cases (or ports + a factory) — never its concrete adapters. Only the composition root
> (see §3) touches infrastructure.

### Mechanism — map the concept to your ecosystem

| Ecosystem | Public-surface mechanism |
| :--- | :--- |
| **Go** | Exported (Capitalized) identifiers + compiler-enforced `internal/` package |
| **Rust** | `pub` on a curated module tree; crate as the module unit |
| **C#** | `internal` (assembly-scoped) + `public` types; one assembly per module is ideal |
| **Kotlin** | `internal` modifier (module-scoped) + Explicit API mode |
| **Java** | JPMS `module-info` `exports`, or package-private defaults |
| **TypeScript** | Single entry (barrel) + package `exports` field + lint rule banning deep imports |
| **Python** | Package `__init__` + `__all__`; leading-underscore for privates |

```yaml
preference: "compiler-enforced visibility  >  curated entry + lint rule  >  internal/ folder convention"
combine_if_weak: "If the language lacks module-scoped visibility (e.g., TS), use a curated entry PLUS a lint rule; optionally add an internal/ folder for clarity."
```

### Cross-module dependency rule
```yaml
depend_on: "another module's public surface only."
prefer: "depend on its contracts / DTOs, NOT its Entities — avoid one module becoming the implicit shared model (see CODING_STANDARDS.md → External Dependency Boundary Policy)."
```

---

## 2. Shared Kernel & Cross-Cutting Placement

A single `shared/` dumping ground **is** the anti-pattern the philosophy warns about
(god module; `Config`/`Logger` everywhere). Decompose "shared" into **four tiers**, each
with its own rule.

| Tier | Holds | Dependency rule | Stability |
| :--- | :--- | :--- | :--- |
| **T0 — Kernel** | `Result`/`Option`, base error, `Id`, value-object base | depends on **nothing**; anyone may depend on it | near-frozen |
| **T1 — Cross-cutting ports** | `Clock`, `Logger`, `Config`, `IdGenerator` — **contracts only** | code depends on the **port**; impl in Infrastructure; wired at the composition root | stable |
| **T2 — Shared contracts** | cross-module / cross-runtime **DTOs** (e.g., the wire contract) | both sides depend on it; **kept separate from the Kernel** | evolves (Gate) |
| **T3 — Shared domain VOs** | only truly universal, behavior-light value objects (`Money`, `Email`) | reach via the owning module by default | promote with care |

```yaml
direction: "T0 depends on nothing. NOTHING in shared may depend on a feature module. (Prevents cycles and god modules.)"
cross_cutting_via_ports: "current time / randomness / logging / settings are injected as T1 ports — matches DESIGN_PHILOSOPHY.md → Domain Purity ('contextual' values are injected, not referenced directly)."
separate_T2_from_T0: "Contracts evolve under the Contract Confirmation Gate; the Kernel is frozen. Mixing them makes frozen primitives wobble."
promotion_gate: "Rule of Two/Three — a thing earns a shared home only when >=2 modules genuinely need it AND it is stable. Until then it lives in its owning module (YAGNI; over-engineering ranks below boundary discipline)."
T3_rule: "Share value objects, NOT entities. Entities keep a lifecycle and an owner."
```

---

## 3. Runtime Topology & Multi-Deployable Layout (frontend + backend)

The in-module `ui/` folder and "the frontend is a separate app" are **two different axes**.
Choose the topology explicitly.

| | **Topology 1 — single runtime** | **Topology 2 — multiple deployables** |
| :--- | :--- | :--- |
| Example | SSR / server-rendered in one process | SPA (browser) + API (server/edge) |
| `ui/` placement | **inside each module**, depends inward | frontend is its **own bounded context** |
| Select when | one runtime serves everything | separate runtimes / deploy targets |

### The seam between runtimes is itself a Bounded Contract
```yaml
seam_is_a_contract: "The HTTP/RPC DTOs between frontend and backend are a published contract (Signature + Semantics + Constraints)."
governance: "Treat the seam like any published contract — evolve it only when existing consumers and providers keep working under prior guarantees, and check the relevant wire/schema compatibility before applying the Contract Confirmation Gate (see CODING_STANDARDS.md → Contract Evolution). Additive shape is not proof of compatibility."
recursion_note: "This is the recursive boundary principle one scale up — a service/runtime boundary is a Bounded Contract just like a module (see DESIGN_PHILOSOPHY.md → Boundaries Are Recursive)."
```

### The frontend is its own bounded context (Topology 2)
It mirrors the backend with its **own** layers, and consumes the published contract:

```text
web/features/<feature>/
  ui/              # components / pages
  application/     # interaction / view-state orchestration (often thin; optional)
  infrastructure/  # API-client adapter implementing a gateway port; talks via the shared contract (T2)
  domain/          # usually light — reuse contract DTOs or a lightweight view model; Rich domain rarely belongs in the client
```

```yaml
hard_rule: "The frontend depends ONLY on the shared contract (T2). It MUST NOT depend on the backend's domain/application/infrastructure. (External Dependency Containment applied to the runtime seam; also keeps server-only code out of the browser bundle.)"
```

### Monorepo layout — two options

```yaml
option_A_runtime_first:   # RECOMMENDED for multi-runtime
  layout: "apps/{api,web} = thin shells + composition roots; packages/features/<f>/{domain,application,infrastructure} = server core; packages/{kernel(T0/T1), contracts(T2)} = shared; apps/web/features/<f>/{ui,application,infrastructure} = frontend"
  pros: "honest runtime separation; bundler cannot pull server infra into the browser; shared core reusable"
  cons: "one feature spans two packages (server + web), linked by the shared contract"
  why_ok: "apps/ is a DEPLOYMENT boundary, not a technical layer — it does NOT violate 'no technical layer on top'. Each side stays feature-first internally."

option_B_feature_first:
  layout: "features/<f>/{domain,application,infrastructure(server),ui(web),contracts}; apps/{api,web} are thin entry points"
  pros: "most literal 'one small world per feature'"
  cons: "must enforce by discipline that the browser never imports infrastructure/; weaker tooling guarantees; bundling risk"
  use_when: "small app, one team owns both sides, tight coupling acceptable"

decision: "Use Option A for multiple runtimes; Option B is defensible for small single-team apps. Document the chosen topology."
```

### Composition root
```yaml
rule: "Each runtime entry point (server request handler, queue consumer, browser bootstrap) is a composition root: it reads the environment/bindings ONCE, constructs adapters, injects them into use cases (constructor DI), and stays at the edge. Business logic never lives in the entry point."
```

---

## 4. Test File Placement

> Testing **strategy** (what to test, contract tests, AAA, boundaries) lives in
> `CODING_STANDARDS.md` → "Testing Strategy". This section owns **placement** only.

```yaml
co_location: "Co-locate unit & contract tests with the code under test. Aligns with Design Priority #3 (locality of change): tests move with the code during refactors."
parallel_tree: "Reserve a separate top-level location only for cross-module / cross-runtime end-to-end tests."
```

### The Contract Test Suite lives beside the PORT (not the implementation)
```yaml
location: "Place the shared contract-test suite next to the contract owner (domain for domain contracts, application for application ports)."
shape: "Parameterize the suite by a factory."
conformance: "Every implementation (in-memory fake, real adapter) provides a factory and runs the SAME suite. This physically encodes that the contract owns conformance expectations and implementations must satisfy them; requested-outcome verification remains a separate responsibility (CODING_STANDARDS.md → Testing Strategy)."
```

### Test doubles / fakes
```yaml
reusable_fake: "A fake reused by other modules' tests is part of the module's TEST-SUPPORT public surface (a separate export/entry), so consumers can wire it. (See §1.)"
internal_fake: "A fake used only within the module stays internal."
```

### Cross-runtime / E2E
```yaml
location: "Top level (not inside a feature), because it spans the seam."
target: "It verifies the published seam contract (T2) between frontend and backend (§3)."
```

---

## How These Interlock

```yaml
public_surface_is_the_unit: "§1 defines the unit; what a module exposes drives everything else."
shared_hangs_off_surfaces:  "§2 kernel/contracts are themselves public surfaces with the same default-internal rule."
seam_is_a_special_surface:  "§3 the front/back seam is a public surface across runtimes — same governance."
tests_track_the_contract:   "§4 contract tests live with the contract owner from §1."
one_idea: "Make the boundary (public surface) the single unit, and shared code, the runtime seam, and tests all follow from it."
```
