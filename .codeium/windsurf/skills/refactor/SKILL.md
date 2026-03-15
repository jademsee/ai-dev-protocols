---
name: refactor
description: Make code cleaner, more understandable, and easier to maintain or extend
---

# SKILL: Refactor Module

## Trigger
When asked to refactor, restructure, reorganize, clean up, or
improve the design of an existing module or file.

## Process — follow in order, no skipping
1. Read the entire module before touching anything
2. Read all callers/importers of the module
3. Run existing tests — confirm GREEN baseline before any change
4. Identify the specific problem being solved by the refactor
5. Propose the refactor plan with minimal change set
6. WAIT for approval
7. Refactor in small, test-passing increments — not one big rewrite
8. Run tests after each increment
9. Update callers only after the module is stable

## Refactor Categories — approach each differently

### Rename
- Use IDE rename tool, not find/replace
- Update all imports, type references, and tests
- Single commit per rename

### Extract Function/Module
- New function must have a single clear responsibility
- Must not increase the call depth unnecessarily
- All existing tests must still pass without modification

### Simplify Logic
- Must not change observable behavior
- Must have test coverage before simplifying
- Prefer clarity over micro-optimization here

### Restructure Files
- Follow existing directory conventions exactly
- Update all import paths
- Do not change public API during restructure

### Remove Dead Code
- Confirm code is unreachable via search of entire codebase
- Do not remove code that may be called dynamically (reflection,
  string-based dispatch, plugin systems)
- Flag and confirm before deleting

## Hard Rules
- NEVER refactor and add features in the same change
- NEVER change public API shape during a refactor
- NEVER rewrite working code "for clarity" without a clear
  measurable improvement
- NEVER refactor without a GREEN test baseline first
- NEVER change more files than necessary
- One concern per commit

## Scope Limits — STOP and ask for explicit approval if refactor would require:
- Changing more files than typical for the project (default: 5 files;
  larger monorepos may use 10-15; microservices may use 2-3)
- Modifying a public API
- Touching code outside the original module's directory
- Deleting significant logic (default: >20 lines; always show diff first)

## Pre-Submit Check
- [ ] Tests GREEN before and after
- [ ] No behavior change — only structural change
- [ ] No public API modified
- [ ] All callers updated if signatures changed
- [ ] No new abstractions added without removing old ones
- [ ] Change is minimal — no scope creep
