# Engineering Principles

These rules define the core engineering discipline for all development work.

---

## Project Law

1. **Correctness > Performance > Elegance**
   - A fast wrong answer is always rejected
   - Tests must pass at every commit
   - Concurrency correctness is mandatory

2. **Architectural Continuity**
   - Reuse existing abstractions, modules, patterns, and utilities
   - Do NOT introduce new concepts if an equivalent already exists
   - NEVER introduce parallel implementations unless explicitly approved
   - Before writing new code, LOCATE and UNDERSTAND related existing code

3. **Minimal Changes**
   - One logical change per commit
   - Smallest possible fix for bugs
   - No "while I'm here" changes
   - Refactors are separate from features

---

## Change Management

When modifying any component:

1. **Map all related components** - Identify ALL files, tests, documentation, and configuration affected
2. **Verify completeness** - Use language-specific tools to find all references and dependencies
3. **Update everything together** - Never update code without updating tests and documentation
4. **Validate consistency** - Run build, tests, and linting to verify nothing is broken
5. **Check cross-references** - Ensure all imports, links, and references remain valid

---

## Dependencies

Third-party code is allowed ONLY IF:

- The problem is non-core
- It has no runtime reflection or hidden allocations
- The dependency is mature, minimal, clearly superior, and replaces significant complexity
  (≥500 LOC for systems languages, ≥200 LOC for dynamic languages)
- Standard library > existing internal code > new dependency

---

## Coding Standards

### Indentation
- **CRITICAL:** Always use **spaces**, never tabs

### Line Length
- **Maximum:** 100 characters per line
- **Preferred:** 80 characters per line

### Files
- One primary responsibility per file
- No circular imports
- New files must follow existing directory structure

### Comments
- Comment WHY, not WHAT
- No redundant comments
- Performance-sensitive sections must be labeled

---

## Pre-Submit Checklist

Before submitting code, confirm:

- [ ] No new abstractions without removing old ones
- [ ] No locks in hot paths
- [ ] No unnecessary dependencies
- [ ] Existing utilities reused
- [ ] Algorithm and design choice justified
- [ ] Correctness under concurrency verified
