# PROJECT PROFILE

Set these per-project to gate context-dependent rules:

- **Project Type**: systems | backend | frontend | data-science | mobile | scripting | library
- **Concurrency Model**: multi-threaded | async-single-thread | single-threaded
- **Performance Sensitivity**: hot-path-critical | standard | non-critical
- **Commit Convention**: conventional | ticket-first | freeform | squash-merge

Rules marked with **[CONDITIONAL]** below only apply when the Project Profile matches.

---

# SESSION START PROTOCOL

When starting work on any task:
1. Identify and read all related existing files first
2. Summarize current behavior before proposing changes
3. Never modify more files than necessary

# CHANGE MANAGEMENT PROTOCOL

When modifying any component of a project:
1. **Map all related components** - Identify ALL files, tests, documentation, and configuration affected by the change
2. **Verify completeness** - Use language-specific tools to find all references and dependencies
3. **Update everything together** - Never update code without updating tests and documentation
4. **Validate consistency** - Run build, tests, and linting to verify nothing is broken
5. **Check cross-references** - Ensure all imports, links, and references remain valid

## Change Impact Requirements:
- Function signature changes → Update all callers, tests, and documentation
- Module refactors → Update all imports, paths, and references
- Schema changes → Update migrations, models, API types, tests, and docs
- Config changes → Update templates, deployment configs, and documentation
- Dependency updates → Update lock files, check for breaking changes, verify compatibility

When making changes that affect multiple files, ensure comprehensive synchronization of all callers, tests, documentation, and configuration.

# CONFIGURATION CHANGE PROTOCOL

When modifying Windsurf/Cascade configuration files (skills/, global_workflows/, *.md):

**MANDATORY STEPS - No exceptions:**

1. **Make your changes** to skills, workflows, or documentation
2. **Run validation** - Execute `/validate` workflow
3. **Fix ALL issues** - Address every error and warning reported
4. **Verify consistency** - Ensure:
   - Skill directory names match YAML name fields
   - Documentation references use correct skill/workflow names
   - Counts in README match actual files
   - Cross-references are valid
   - YAML frontmatter is complete
5. **Only then commit** - Changes must pass validation before committing

**Specific Requirements:**

- **Adding a skill:** Follow CHANGE_CHECKLISTS.md → "Checklist 1: Modifying a Skill"
- **Adding a workflow:** Follow CHANGE_CHECKLISTS.md → "Checklist 2: Modifying a Workflow"
- **Changing rules.md:** Follow CHANGE_CHECKLISTS.md → "Checklist 3: Modifying Global Rules"
- **Any config change:** Run `/validate` before committing

**Validation is NOT optional** - It prevents:
- Broken cross-references
- Documentation drift
- Naming inconsistencies
- Missing YAML frontmatter
- Orphaned files

# SECRETS MANAGEMENT PROTOCOL

When working with any project that handles secrets, credentials, or sensitive configuration:

1. **Never store secrets in source code** — no hardcoded API keys, passwords, tokens, or connection strings
2. **Use `.env.schema` or equivalent** — give AI agents config context without exposing secret values
3. **Separate secrets per environment** — dev, staging, and production must use different credentials
4. **Use service identities in production** — IAM roles, managed identities, or workload identity over static credentials
5. **Enable audit logging** — all production secret vaults must have access logging enabled
6. **Rotate after exposure** — rotate credentials immediately after offboarding, suspected compromise, public exposure, or emergency access
7. **Enforce pre-commit scanning** — block commits containing secrets (`varlock scan`, `gitleaks protect`)
8. **Never log secrets** — redact sensitive values from application logs, error traces, and monitoring

**Hard Stops:**
- NEVER commit `.env` files to version control
- NEVER share production secrets via Slack, email, or unencrypted channels
- NEVER grant production secret access without explicit justification

# PROCESS REQUIREMENT

## Process you MUST follow:
- Identify relevant existing files/modules
- Explain how they currently work
- Propose the minimal change set
- Justify algorithms and data structures used
- Only then produce code

# CLARIFICATION & OPTIONS

- Always present 2-3 implementation options with tradeoffs before
  writing code for any non-trivial task.
- Present all options including the highest-performance one.
  Do not pre-filter based on your own preferences.
- Ask clarifying questions if requirements are ambiguous.
- Never assume — ask.

# PROJECT LAW

- Correctness always beats performance. A fast wrong answer is always rejected.
- Reuse existing architecture and abstractions.
- Performance > elegance in hot paths.
- **[CONDITIONAL: hot-path-critical]** Lock-free and allocation-minimal by default.
- No new dependencies unless explicitly justified.
- **[CONDITIONAL: multi-threaded | async-single-thread]** Correctness under concurrency is mandatory.
- Code must integrate, not parallel existing systems.

## Coding standards are subordinate to:
- Correctness
- Performance
- Architectural consistency

## 1. Architectural Continuity
- ALWAYS reuse existing abstractions, modules, patterns, and utilities.
- Do NOT introduce new concepts if an equivalent already exists.
- NEVER introduce parallel implementations unless explicitly approved.
- Before writing new code, LOCATE and UNDERSTAND related existing code.

## 2. Code Quality
- Code must be:
  - deterministic
  - **[CONDITIONAL: multi-threaded | async-single-thread]** race-safe
  - **[CONDITIONAL: multi-threaded | async-single-thread]** correct under concurrency
- No "clever" abstractions that harm performance.
- No unnecessary layers.

## 3. Performance Principles **[CONDITIONAL: hot-path-critical]**
- Target: low-latency, lock-free, allocation-minimal execution paths.
- Avoid locks, mutexes, blocking IO in hot paths.
- **[CONDITIONAL: multi-threaded + hot-path-critical]** Prefer:
  - CAS / atomics
  - ring buffers
  - wait-free queues
  - object pooling
- Measure cost: time complexity, allocations, cache locality.

## 4. Required Reasoning
- Explain WHY this design fits existing architecture.
- Explain tradeoffs.
- Explicitly state why alternatives were rejected.

## The following WILL be rejected:
- Introducing a new abstraction without removing an old one
- Rewriting working code "for clarity"
- Adding libraries to save <50 LOC
- Async/await where a faster synchronous path exists
- Premature generalization

If any constraint is violated, explain why and offer best recommended options.

# DEPENDENCIES

Third-party code is allowed ONLY IF:

- The problem is non-core
- It has no runtime reflection or hidden allocations
- The dependency is mature, minimal, clearly superior, and replaces significant complexity (≥500 LOC for systems languages, ≥200 LOC for dynamic languages, or addresses correctness concerns that manual implementation would likely get wrong)
- Standard library > existing internal code > new dependency

# CODING STANDARDS & FORMATTING

Do not rewrite code solely for formatting or style.

## Indentation
- **CRITICAL:** Always use **spaces**, never tabs.

## Line Length
- **Maximum:** 100 characters per line
- **Preferred:** 80 characters per line
- Break long lines at logical points

## Files
- One primary responsibility per file
- No circular imports
- New files must follow existing directory structure

## Comments
- Comment WHY, not WHAT
- No redundant comments
- Performance-sensitive sections must be labeled

Before updating any file, ensure that all generated or modified content
conforms to the formatting standards applicable to that file.

# IMPROVEMENT LOOP PROTOCOL
 
When asked to run an improvement loop:
 
## Loop Structure (each iteration):
1. Run existing tests — report pass/fail count
2. If RED: fix failures first, minimal change only, then restart loop
3. If GREEN: identify the single highest-impact improvement using
   this priority order:
   - Correctness issues first
   - Concurrency/race conditions second
   - Performance in hot paths third
   - Clarity or structure last
4. Propose 2-3 options for that improvement with tradeoffs
5. Wait for approval before implementing (unless Turbo Mode
   is explicitly requested)
6. Implement selected option
7. Run tests again — verify still GREEN
8. Report: what changed, why, and what the next candidate is
9. Repeat
 
## Loop Stop Conditions (exit normally when any are true):
- 3 consecutive GREEN iterations with no improvements found
- All known correctness issues resolved and no performance
  regressions remain
- Explicit "STOP" from user
 
## Hard Stops — exit loop IMMEDIATELY and report why:
- A change would modify a public interface or API contract
- A change would add a new dependency
- A change would delete or weaken existing tests
- The same fix has been attempted twice without success
- Correctness under concurrency cannot be confirmed
- A change would touch more than 3 files not in the original scope
- Turbo Mode is active and test failure count increases by >2
 
## After every iteration, report:
- What was changed and in which file(s)
- Why this change fits the existing architecture
- Current test status (pass/fail count)
- Next highest-impact improvement candidate
- Any hard stop conditions that are approaching

# PRE-SUBMIT CHECKLIST

Before submitting code, confirm:

- [ ] No new abstractions without removing old ones
- [ ] No locks in hot paths
- [ ] No unnecessary dependencies
- [ ] Existing utilities reused
- [ ] Algorithm and design choice justified
- [ ] Correctness under concurrency verified
