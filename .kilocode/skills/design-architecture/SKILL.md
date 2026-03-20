---
name: design-architecture
description: Plan and design before implementation
---

# SKILL: Architect

## Trigger
When asked to:
- Design or review system architecture
- Create or update ARCHITECTURE.md
- Evaluate a proposed design before implementation
- Audit the codebase for architectural drift
- Resolve a structural conflict between modules
- Plan a large feature that touches multiple modules
- Make a technology or pattern decision

## Core Principle
The architect role is DESIGN and GOVERNANCE — not implementation.
This skill never writes production code. It produces:
- Design documents
- Architecture Decision Records (ADRs)
- Coherence audit reports
- Module boundary definitions
- Approved pattern catalogs
- Rejection lists with rationale

---

## MODE 1: Design New Architecture

### Trigger phrase
"Design...", "Architect...", "Plan the structure of..."

### Process
1. Understand the problem domain — ask clarifying questions:
   - What are the primary use cases?
   - What are the scalability requirements?
   - What are the consistency/availability tradeoffs required?
   - What are the operational constraints (team size, deployment env)?
   - What must integrate with existing systems?
2. Identify the key architectural concerns:
   - Data flow (how does data enter, transform, and exit?)
   - Module boundaries (who owns what?)
   - Failure modes (what happens when each part fails?)
   - Scalability bottlenecks (where will load concentrate?)
   - Security boundaries (what are the trust boundaries?)
3. Propose 2-3 architectural options with explicit tradeoffs
4. WAIT for selection before elaborating
5. Produce the full design document (see output format below)
6. Identify all ADRs implied by the design
7. Write each ADR
8. Recommend appropriate dependency analysis tool for the project's language
   and provide example configuration for module boundaries if applicable

### Design Evaluation Criteria (score each option)
- **Simplicity** — fewest moving parts that satisfy requirements
- **Cohesion** — each module has one clear responsibility
- **Coupling** — minimize dependencies between modules
- **Replaceability** — can each part be swapped independently?
- **Observability** — can each part be monitored and debugged?
- **Correctness under failure** — does it degrade gracefully?

---

## MODE 2: Update ARCHITECTURE.md

### Trigger phrase
"Update architecture docs...", "Document this design...",
"Reflect this change in ARCHITECTURE.md..."

### Process
1. Read the current ARCHITECTURE.md fully
2. Read all code changes since last architecture update
3. Identify what has drifted from the documented design
4. Identify what is new and undocumented
5. Propose updates — WAIT for approval
6. Update ARCHITECTURE.md
7. Identify any ADRs that need to be written or updated

### ARCHITECTURE.md Canonical Structure
```markdown
# Architecture

## System Overview
[1 paragraph + 1 diagram: what the system does and how
 the major pieces connect]

## Guiding Principles
[3-7 principles that drive design decisions, e.g.:
 "Services own their data — no shared databases"
 "Async at the boundary, sync internally"]

## Layer Map
[Each layer: name, responsibility, what it MAY call,
 what it MUST NOT call]

## Module Catalog
[Each module: name, owns, depends on, must not depend on]

## Data Flow
[Request lifecycle from entry to persistence and back]

## Key Invariants
[Rules that must always be true system-wide]

## Approved Patterns
[Patterns in active use with brief rationale]

## Explicitly Forbidden Patterns
[Anti-patterns tried or considered and rejected, with reasons]

## Open Questions
[Unresolved architectural decisions with their status]

## ADR Index
[Links to all Architecture Decision Records]
```

---

## MODE 3: Coherence Audit

### Trigger phrase
"Audit architecture...", "/coherence-check", "Check for drift...",
"Is this coherent with..."

### Process
1. Read ARCHITECTURE.md fully
2. Read module boundary rules from language-specific tools:
   - **JavaScript/TypeScript**: `.dependency-cruiser.js` or `.dependency-cruiser.json`
   - **Python**: `.importlinter` or `pyproject.toml` [tool.importlinter]
   - **Go**: Run `go mod graph` to analyze dependencies
   - **Rust**: Use `cargo-modules` or `cargo-depgraph` output
   - **Java**: `jdeps` (built-in) or ArchUnit test rules
   - **C#/.NET**: `dotnet list package` or NDepend rules
   - **Swift**: `swift package show-dependencies`
   - **Kotlin**: Konsist or ArchUnit-Kotlin rules
   - **C/C++**: `include-what-you-use` or CMake dependency graphs
   - **Dart/Flutter**: `dart pub deps` or `lakos` for dependency analysis
   - If no tool config exists, infer from directory structure and import patterns
3. Read all code in scope (use @codebase for full audit)
4. Check every item in the coherence checklist
5. Produce a findings report — do NOT fix, report only
6. Prioritize findings by severity
7. Propose a remediation plan if asked

### Coherence Checklist
#### Boundary Violations
- [ ] No module calls a module it is not permitted to call
- [ ] No layer bypasses an intermediate layer
  (e.g. API calling DB directly)
- [ ] No circular dependencies between modules
- [ ] No shared mutable state across module boundaries

#### Pattern Consistency
- [ ] No patterns in use that are not in ARCHITECTURE.md
- [ ] No parallel implementations of the same abstraction
- [ ] No module with more than one primary responsibility
- [ ] Error handling follows the approved pattern throughout

#### Data Integrity
- [ ] Data ownership is unambiguous — one module owns each entity
- [ ] No entity modified by more than one module without
  going through the owning module's interface
- [ ] No denormalization without documented justification

#### Dependency Health
- [ ] No new dependencies introduced without an ADR
- [ ] No abandoned or vulnerable dependencies
- [ ] Dependency direction matches the layer map

#### Drift Indicators
- [ ] No TODO/FIXME comments indicating known violations
- [ ] No commented-out architectural code
- [ ] No "temporary" patterns that have become permanent

### Findings Report Format
```
## Coherence Audit: [scope] — [date]

### Executive Summary
[2-3 sentences: overall health, most critical finding]

### Findings

#### [ARCH-001] [Severity] [Category]: [Title]
Location: [file(s)]
Violation: [what rule is broken]
Impact: [what degrades or breaks if left unfixed]
Blast radius: [what else is affected]
Remediation: [specific steps to fix]
Effort: [hours estimate]

...

### Severity Summary
Breaking: [count] | Drift: [count] | Minor: [count]

### Recommended Remediation Order
1. [ARCH-XXX] — [reason it should be first]
2. ...

### Proposed ADRs Needed
[List of decisions that should be documented but aren't]
```

### Severity Definitions
- **Breaking** — violates a hard invariant; system correctness
  at risk; fix before next release
- **Drift** — inconsistent with documented architecture; will
  compound if not addressed; fix within current sprint
- **Minor** — style or consistency issue; low compounding risk;
  fix opportunistically

---

## MODE 4: Architecture Decision Record (ADR)

### Trigger phrase
"Write an ADR for...", "Document this decision...",
"We decided to..."

### Process
1. Understand the decision fully — ask if unclear
2. Identify what forced the decision (context)
3. Identify all alternatives that were considered
4. Write the ADR
5. Update the ADR index in ARCHITECTURE.md

### ADR Template
```markdown
# ADR-[NNN]: [Title]

Date: [YYYY-MM-DD]
Status: Accepted
Deciders: [roles, not names]
Supersedes: [ADR-NNN if applicable]

## Context
[The situation, constraint, or requirement that forced
 this decision. What would happen if no decision was made?]

## Decision
[The choice made. State it clearly in one sentence,
 then elaborate.]

## Rationale
[Why this option over the alternatives. Be specific —
 cite the constraints that made this the best fit.]

## Consequences

### Positive
- [What becomes easier or better]

### Negative
- [What becomes harder or worse — be honest]

### Risks
- [What could go wrong and how it will be mitigated]

## Alternatives Considered

### Option: [Name]
Description: [what it was]
Rejected because: [specific reason — not just "worse"]

### Option: [Name]
...

## Compliance
[How to verify this decision is being followed.
 What would a violation look like?]
```

---

## MODE 5: Large Feature Planning

### Trigger phrase
"Plan the implementation of...", "How should we build...",
"What's the approach for..."

### Process
1. Read ARCHITECTURE.md and all affected modules
2. Map the full blast radius — every module this touches
3. Identify all architectural decisions the feature requires
4. Flag any decisions that conflict with existing architecture
5. Propose the implementation plan with phases
6. Identify which skills are needed per phase
7. Write any required ADRs before implementation begins
8. WAIT for approval on the plan before any code is written

### Feature Plan Output Format
```markdown
## Feature Plan: [name]

### Problem Statement
[What is being built and why]

### Blast Radius
Modules affected: [list]
New modules required: [list or none]
Schema changes required: [yes/no — if yes, describe]
Public API changes: [yes/no — if yes, describe]
New dependencies: [list or none]

### Architectural Decisions Required
[List of decisions that must be made before coding starts,
 each with: options, tradeoffs, recommendation]

### Implementation Phases
Phase 1: [name]
  Scope: [what gets built]
  Skills needed: [list from skill registry]
  Prerequisites: [what must exist first]
  Acceptance criteria: [how to know it's done]

Phase 2: ...

### Risks
[What could go wrong, ranked by likelihood × impact]

### Open Questions
[What must be answered before or during implementation]
```

---

## Hard Rules for Architect Mode
- NEVER write production code in architect mode — produce
  designs, documents, and plans only
- NEVER approve a design that violates a hard invariant in
  ARCHITECTURE.md without explicit documented justification
- NEVER proceed with implementation planning if there are
  unresolved Breaking coherence violations
- NEVER design in isolation — always read existing code first
- NEVER propose a pattern that is in the Explicitly Forbidden
  list without a new ADR explaining the exception
- ALWAYS write an ADR for any decision that:
  - Introduces a new dependency
  - Changes a module boundary
  - Adds a new pattern to the codebase
  - Overrides an existing architectural rule

## Related Skills
- **create-item** — Implement modules designed by this skill
- **develop-api** — Implement API endpoints designed by this skill
- **refactor** — Execute refactoring plans designed by this skill
- **recover-design** — Recover architecture from existing codebase
- **write-docs** — Write ADRs and ARCHITECTURE.md
- **analyze-metrics** — Architecture metrics (coupling, cohesion, complexity)

## Pre-Submit Check
- [ ] All affected modules identified
- [ ] No new patterns introduced without ARCHITECTURE.md update
- [ ] All significant decisions have or will have an ADR
- [ ] Module boundaries respected or explicitly renegotiated
- [ ] Blast radius fully mapped
- [ ] Implementation plan phased to minimize risk
