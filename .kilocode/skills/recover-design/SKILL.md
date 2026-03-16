---
name: recover-design
description: Deconstruct an artifact/the codebase to discover the design processes used in its creation
---

# SKILL: Reverse Engineer & Recover Design

## Trigger
When asked to:
- Understand an unfamiliar codebase
- Recover the original design intent from code
- Reverse engineer architecture from implementation
- Onboard onto an existing project
- Produce missing documentation from code
- Understand how a specific feature works end-to-end
- Identify who owns what in an undocumented system
- Recover the data model from code or DB schema
- Understand why something was built the way it was

## Core Principle
Read first, conclude last. Never infer design intent from
a single file. Always triangulate across: code structure,
naming, tests, git history, and comments — in that order.
Distinguish confidently between OBSERVED (what the code does)
and INFERRED (what it was likely trying to do).

---

## MODE 1: Full Codebase Orientation

### Trigger phrase
"Help me understand this codebase", "I'm new to this project",
"Give me an orientation", "What does this system do?"

### Process
1. Read the directory tree — understand the top-level structure
2. Read all config files: `package.json`, `Cargo.toml`,
   `go.mod`, `pyproject.toml`, `.env.example`, `docker-compose.yml`
3. Read the entry point(s) — `main.ts`, `index.js`, `main.rs`,
   `app.py`, etc.
4. Read the router or top-level dispatcher
5. Read one representative file from each major directory
6. Read the test directory structure — tests reveal intent
7. Read the most recent 20 commits: `git log --oneline -20`
8. Synthesize and produce the Orientation Report

### Orientation Report Format
```markdown
## Codebase Orientation: [project name]

### What This System Does
[2-3 sentences: the domain problem it solves and for whom]

### Tech Stack
[Language, framework, DB, infrastructure — as observed]

### Top-Level Structure
[Each top-level directory: name → responsibility]

### Entry Points
[How requests/jobs/events enter the system]

### Core Domain Concepts
[The 5-10 most important domain entities and what they represent]

### Data Flow
[How a typical request moves through the system,
 from entry to response]

### Key Dependencies
[External services, libraries, or APIs this system relies on]

### What Looks Intentional
[Patterns and decisions that appear deliberate and consistent]

### What Looks Accidental or Unclear
[Inconsistencies, dead code, or patterns that seem unintentional]

### Suggested Next Steps for Understanding
[Which areas to read next, in recommended order]
```

---

## MODE 2: Recover Architecture

### Trigger phrase
"Recover the architecture", "Reverse engineer the design",
"What was the intended architecture?",
"Generate ARCHITECTURE.md from the code"

### Process
1. Run MODE 1 orientation first if not already done
2. Map every module/package and its dependencies:
   - What does it import?
   - What imports it?
   - What does it read/write?
3. Identify the layer structure:
   - What layer is each module in?
   - Are the layers respected or violated?
4. Identify module boundaries:
   - What does each module expose publicly?
   - What does it keep private?
5. Identify the dominant architectural pattern:
   - Layered / hexagonal / CQRS / event-driven / monolith /
     microservices / etc.
6. Identify approved vs accidental patterns
7. Identify violations and drift
8. Produce the recovered ARCHITECTURE.md

### Recovered ARCHITECTURE.md Format
```markdown
## Architecture (Recovered)
> This document was recovered from code analysis on [date].
> Sections marked [INFERRED] represent best-guess intent,
> not confirmed design decisions.

### System Overview
[What the system does — from entry points and domain objects]

### Observed Layer Map
[Each layer: what it contains, what it calls, violations found]

### Module Catalog
[Each module: owns, depends on, observed violations]

### Dominant Pattern
[The architectural pattern most consistently applied]
  Confidence: [High | Medium | Low]
  Evidence: [which files/patterns support this conclusion]

### Inferred Design Principles [INFERRED]
[Principles that appear to have guided the original design,
 based on consistent patterns observed]

### Observed Violations
[Places where the code contradicts the dominant pattern]
[Each: location, what rule is violated, likely cause]

### Dead Code & Abandoned Patterns
[Modules, patterns, or abstractions that appear unused
 or superseded but not removed]

### Recommended ADRs to Write
[Decisions visible in the code that should be documented]

### Open Questions
[Things that cannot be determined from code alone]
```

---

## MODE 3: Trace a Feature End-to-End

### Trigger phrase
"How does [feature] work?", "Trace [request/event] through
the system", "Show me the flow for [operation]"

### Process
1. Identify the entry point for the feature
   (API route, event, job, CLI command)
2. Follow the call chain from entry to persistence:
   - Read each function called, in order
   - Note every branch and condition
   - Note every external call (DB, cache, queue, API)
3. Follow the return path back to the response
4. Identify all side effects (writes, events emitted, emails, etc.)
5. Identify all failure modes at each step
6. Produce the Feature Flow document

### Feature Flow Format
```markdown
## Feature Flow: [name]

### Entry Point
[file:line — the function/handler where this begins]

### Happy Path
Step 1: [function name] @ [file:line]
  Does: [what it does in one line]
  Calls: [next function or external system]
  Data: [what data is passed/returned]

Step 2: ...

### External Calls
[Each external system touched: DB query, cache, queue, API]
[For DB: the exact query or ORM call and what it touches]

### Side Effects
[Everything written, emitted, or sent as a result]

### Failure Modes
[At each step: what can fail and what happens when it does]

### Data Transformations
[How the core data object changes shape through the flow]

### Observations
[Anything surprising, non-obvious, or worth flagging]
```

---

## MODE 4: Recover the Data Model

### Trigger phrase
"What is the data model?", "Recover the schema",
"Explain the domain model", "What entities exist?"

### Process
1. Find all schema definitions:
   - Migration files (read in chronological order)
   - ORM models / entity classes
   - Type definitions / interfaces
   - GraphQL schema / Protobuf definitions
2. For each entity: extract fields, types, constraints,
   relations
3. Identify the cardinality of every relationship
4. Identify which entities are core domain vs. supporting
5. Identify soft-delete patterns, audit columns, versioning
6. Identify any denormalization and infer the reason
7. Produce the recovered data model document

### Recovered Data Model Format
```markdown
## Data Model (Recovered)

### Entity Catalog

#### [EntityName]
Table: [table_name]
Purpose: [what real-world concept this represents]

Fields:
| Column       | Type      | Nullable | Notes                    |
|--------------|-----------|----------|--------------------------|
| id           | uuid      | NO       | primary key              |
| ...          |           |          |                          |

Relationships:
- belongs_to [Entity] via [foreign_key]
- has_many [Entity] via [foreign_key]

Indexes: [list]
Constraints: [list]
Notes: [anything non-obvious about this entity]

---

### Relationship Map
[Diagram or prose: how entities relate to each other]

### Core vs. Supporting Entities
Core (central to the domain): [list]
Supporting (infrastructure/audit/config): [list]

### Observed Patterns
[Soft delete, optimistic locking, event sourcing, etc.]

### Inferred Design Decisions [INFERRED]
[Why certain denormalizations or constraints exist]

### Anomalies
[Missing indexes, inconsistent naming, orphaned tables,
 columns that appear unused]
```

---

## MODE 5: Recover Intent from Git History

### Trigger phrase
"Why was this built this way?", "What was the original intent?",
"Understand the history of [module]", "Why does this exist?"

### Process
1. Read git log for the target file/module:
   ```
   git log --follow --oneline [file]
   git log --follow -p [file]  ← full diff history
   ```
2. Read the first commit that introduced the file — this
   reveals the original intent most clearly
3. Read commits around major refactors
4. Read commit messages for context clues
5. Read any referenced issue/ticket numbers in commit messages
6. Identify: what problem was being solved? what constraints
   existed? what alternatives were tried?
7. Produce the Design History document

### Design History Format
```markdown
## Design History: [module/file]

### Origin
First introduced: [date, commit hash]
Original author: [if available]
Original purpose: [inferred from first commit and message]

### Evolution
[Chronological list of significant changes:]
[date] [commit] — [what changed and why, from message/diff]

### Key Inflection Points
[Moments where the design changed significantly]
[What drove each change]

### Inferred Original Design Intent [INFERRED]
[What the code was trying to achieve before accumulating changes]

### Drift from Original Intent
[Ways the current code has moved away from the original design]

### Preserved Decisions
[Design choices from early commits still visible today]

### Recommendations
[Whether to continue the current direction, recover the
 original design, or take a new approach]
```

---

## MODE 6: Generate Missing Documentation

### Trigger phrase
"Document this codebase", "Generate docs from code",
"Write the README", "Document what this module does"

### Process
1. Run the appropriate analysis mode first:
   - Full codebase → MODE 1 + MODE 2
   - Single module → MODE 3 (trace its flows)
   - Data model → MODE 4
2. Use write-docs.md skill for the actual documentation output
3. Mark all inferred content clearly as [INFERRED]
4. Flag gaps where documentation cannot be recovered from
   code alone and human input is needed

---

## MODE 7: Identify Unknown Unknowns

### Trigger phrase
"What don't I know about this codebase?",
"What should I be worried about?",
"What are the hidden landmines?"

### Process
1. Run MODE 1 orientation
2. Specifically look for:
   - **Hidden coupling** — modules that appear independent
     but share state or make assumptions about each other
   - **Load-bearing hacks** — workarounds that everything
     now depends on
   - **Implicit contracts** — assumptions between modules
     that are never checked
   - **Abandoned migrations** — partial refactors left incomplete
   - **Temporal coupling** — operations that must happen in
     a specific order with nothing enforcing it
   - **God objects** — classes/modules doing too much that
     everything depends on
   - **Missing error handling** — failure paths that silently
     succeed or swallow errors
   - **Concurrency traps** — shared state accessed without
     synchronization
3. Produce the Risk Map

### Risk Map Format
```markdown
## Risk Map: [project name]

### Critical Risks (fix before adding features)
[Each: location, what the risk is, blast radius if it breaks]

### Hidden Coupling
[Pairs of modules that appear decoupled but are not]

### Load-Bearing Hacks
[Workarounds that must not be touched without understanding fully]

### Implicit Contracts
[Assumptions that are never validated in code]

### Incomplete Refactors
[Half-finished migrations or pattern changes]

### Recommended Reading Order
[For someone new: which files to read first to build
 the most accurate mental model fastest]
```

---

## Slash Commands

```
/orient             Run MODE 1. Full codebase orientation.
                    Produce the Orientation Report.

/recover-arch       Run MODE 1 + MODE 2. Recover and generate
                    ARCHITECTURE.md from the codebase.

/trace [feature]    Run MODE 3. Trace the named feature or
                    request type end-to-end through the system.

/recover-model      Run MODE 4. Recover the full data model
                    from migrations, ORM models, and types.

/why [file/module]  Run MODE 5. Read git history and recover
                    the original design intent for the target.

/doc-gen            Run MODE 6. Generate missing documentation
                    for the current scope.

/landmines          Run MODE 7. Identify hidden risks, coupling,
                    and unknown unknowns. Produce the Risk Map.
```

---

## Hard Rules
- NEVER confuse OBSERVED (what the code does) with INFERRED
  (what it was likely trying to do) — always label clearly
- NEVER draw conclusions from a single file — triangulate
  across multiple sources
- NEVER assume naming is accurate — verify behavior matches name
- NEVER skip git history when trying to understand WHY
  something exists — the commit log is primary evidence
- NEVER produce a design recovery without flagging gaps
  where evidence is insufficient
- ALWAYS note when the current code contradicts the inferred
  original intent — this is the most valuable finding

## Evidence Hierarchy
When recovering design intent, weight evidence in this order:
1. Tests — reveal intended behavior most honestly
2. First commit + message — reveals original purpose
3. Public interfaces — reveal what the author wanted to expose
4. Naming — reveals intent (when consistent)
5. Comments — useful but may be stale
6. Implementation — reveals what was done, not necessarily
   what was intended
