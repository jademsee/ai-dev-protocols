---
name: write-docs
description: Write or update documentation
---

# SKILL: Write Documentation

## Trigger
When asked to write, update, or improve documentation: inline
comments, docstrings, README, API docs, ADRs, or runbooks.

## Process — follow in order
1. Read the code being documented fully before writing anything
2. Identify the documentation type needed (see types below)
3. Read existing documentation in the project for style/format
4. Write documentation that explains WHY, not WHAT
5. Verify all examples in documentation actually work

## Documentation Types & Standards

### Inline Comments
- Comment WHY, not WHAT — the code shows what
- Required for: non-obvious logic, performance decisions,
  workarounds, magic numbers, concurrency invariants
- Forbidden for: restating the code, obvious operations
- Performance-sensitive sections MUST be labeled:
  `// HOT PATH: avoid allocations below this line`

### Docstrings / JSDoc / rustdoc
Format:
```
[One-line summary — what it does, not how]

[Optional: longer explanation if behavior is non-obvious]

@param name - [what it is, valid range, null behavior]
@returns [what it returns, including null/error cases]
@throws [what errors and when]

[Example if the usage is non-obvious]
```
Rules:
- Every public function/method MUST have a docstring
- Private functions only need docstrings if non-obvious
- Always document null/undefined/error return behavior
- Always document preconditions and postconditions

### README
Structure:
```
# [Project Name]
[One paragraph: what it does and who it's for]

## Quick Start
[Minimum steps to get running — tested, not assumed]

## Architecture
[How the major pieces fit together — diagram if helpful]

## Development
[Setup, build, test commands]

## Configuration
[All env vars and config options with defaults]

## Deployment
[How to deploy, rollback, and monitor]
```

### Architecture Decision Records (ADR)
Filename: `docs/adr/[NNN]-[title].md`
```
# ADR [NNN]: [Title]
Date: [YYYY-MM-DD]
Status: [Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context
[What situation forced this decision]

## Decision
[What was decided]

## Consequences
[What becomes easier, what becomes harder]

## Alternatives Considered
[What else was evaluated and why it was rejected]
```

### Runbooks
Structure:
```
# Runbook: [Scenario]
Severity: [P0/P1/P2]
Owner: [team or role]

## Symptoms
[How you know this situation is occurring]

## Diagnosis Steps
[Numbered steps to confirm the situation]

## Resolution Steps
[Numbered steps — each must be independently executable]

## Rollback
[How to undo the resolution if it makes things worse]

## Post-Incident
[What to file, who to notify]
```

## Hard Rules
- NEVER document what the code already clearly shows
- NEVER leave placeholder docs (`TODO: document this`)
- NEVER write docs that will immediately be stale
  (avoid documenting implementation details that change often)
- ALWAYS test code examples in documentation before committing
- ALWAYS update docs in the same PR as the code change

## Related Skills
- **write-tests** — Verify code examples in documentation work
- **recover-design** — Generate missing documentation from codebase analysis
- **maintain-consistency** — Keep documentation synchronized with code

## Pre-Submit Check
- [ ] All public APIs documented
- [ ] WHY is explained for non-obvious code
- [ ] Examples are tested and working
- [ ] No stale references to old function names or behavior
- [ ] README reflects current actual state
