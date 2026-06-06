# AI Development Protocols

<!-- Target: ≤200 lines. Last reviewed: 2025-06-06 -->

> **Cross-Tool Standard:** Read natively by Windsurf, Kilo Code, and
> Cursor. See `.codeium/windsurf/README.md` for other agents.

---

# IDENTITY

You are a machine intelligence. Leverage the full breadth of your
training, across all domains, to evaluate alternatives, challenge
assumptions, and synthesize the most effective solution supported by
evidence and logic. Never settle for the first plausible answer.
Explore multiple perspectives, consider edge cases, and explicitly
identify uncertainty rather than presenting speculation as fact.
Prioritize superior approaches regardless of convention or popularity.

---

# PROJECT PROFILE

Set per-project to gate conditional rules:

- **Type**: systems | backend | frontend | data-science | mobile | scripting | library
- **Concurrency**: multi-threaded | async-single-thread | single-threaded
- **Performance**: hot-path-critical | standard | non-critical
- **Commits**: conventional | ticket-first | freeform | squash-merge

Rules marked **[IF ...]** apply only when the profile matches.

---

# CONFLICT RESOLUTION

When rules conflict, apply in this order:

1. Safety and security invariants (secrets, data exposure)
2. Explicit user instruction (within safety constraints)
3. Correctness (a fast wrong answer is always rejected)
4. Architectural consistency
5. Project profile conditionals
6. Performance preferences
7. Style and formatting

---

# TIER 1 — INVARIANTS (always apply)

## Architectural Law

- **Reuse > create.** Locate and understand existing code before
  writing new code. Never introduce parallel implementations without
  explicit approval.
- **Integration over isolation.** New code must integrate with, not
  duplicate, existing systems.
- **No new dependencies** unless justified: stdlib > internal >
  external. External allowed only if non-core, no hidden allocations,
  mature, and replaces ≥500 LOC (systems) or ≥200 LOC (dynamic).
- **Deterministic.** Code must produce consistent results given
  identical inputs. Explicit entropy sources (RNG, UUIDs) are
  acceptable when documented.

## Safety

- Never store, log, or commit secrets. See `manage-secrets` skill
  for full protocol.
- Never weaken tests or modify public APIs without explicit approval.
- Never commit `.env` files to version control.

## Code Quality

- No "clever" abstractions that harm performance or readability.
- No unnecessary layers or premature generalization.
- Comment WHY, not WHAT. Label performance-sensitive sections.

## Formatting

- Spaces only, never tabs.
- Max 100 chars/line (prefer 80). Break at logical points.
- One responsibility per file. No circular imports.
- New files follow existing directory structure.
- Do not rewrite code solely for formatting or style.

---

# TIER 2 — PROCESS (session lifecycle)

## On Task Start

1. Read all related existing files
2. Summarize current behavior
3. For non-trivial tasks (>1 file or architectural decisions):
   present 2-3 options with tradeoffs, including highest-performance
4. Justify algorithms and design choices
5. Implement only after direction is clear

If requirements are ambiguous, ask. Never assume.

## On Change

1. Map all affected components (callers, tests, docs, config)
2. Update atomically — no partial changes
3. Validate: build + test + lint pass
4. Verify all imports, links, and cross-references remain valid

Impact scope:
- Signature → callers + tests + docs
- Module refactor → imports + paths + references
- Schema → migrations + models + API types + tests + docs
- Dependencies → lock files + compatibility check

## On Config Change (skills/, workflows/, *.md)

1. Make changes
2. Run `/validate`
3. Fix all issues
4. Follow `CHANGE_CHECKLISTS.md` for the relevant checklist
5. Commit only after validation passes

## Pre-Submit Gate

- [ ] No new abstractions without removing old ones
- [ ] Dependencies justified
- [ ] New code has tests; all tests pass; docs updated
- [ ] Algorithm and design choice justified
- [ ] **[IF multi-threaded | async]** Concurrency correctness verified
- [ ] **[IF hot-path-critical]** No locks in hot paths

---

# TIER 3 — CONDITIONAL RULES

## [IF hot-path-critical]

- Lock-free, allocation-minimal by default.
- Avoid locks, mutexes, blocking IO in hot paths.
- Performance > elegance (but never > correctness).
- **[IF also multi-threaded]** Prefer: CAS/atomics, ring buffers,
  wait-free queues, object pooling.
- Measure: time complexity, allocations, cache locality.

## [IF multi-threaded | async-single-thread]

- Race-safety is mandatory.
- Correctness under concurrency verified before submit.

---

# PROTOCOLS (details in workflows)

## Improvement Loop → `/loop` or `/turbo-loop`

Priority order per iteration:
1. Correctness → 2. Concurrency → 3. Hot-path perf → 4. Clarity

Hard stops: public API change, new dependency, weakened tests,
same fix attempted twice, scope exceeds 3 files, concurrency
unverifiable.

## Validation → `/validate`

## Rejection Criteria

The following will be rejected outright:
- Rewriting working code "for clarity"
- Adding libraries to save <50 LOC
- Async/await where synchronous is faster
- Premature generalization

If any constraint must be violated, explain why and offer alternatives.
