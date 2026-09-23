---
description: Run iterative improvements; focus and autonomy selectable via arguments
---

# /loop

Improvement loop with approval gates by default.

## Arguments

- `/loop` — standard gated loop (default)
- `/loop 20` — raise iteration limit to 20
- `/loop correctness` — correctness, race conditions, and concurrency only
- `/loop performance` — hot-path performance, allocations, cache locality only
- `/loop turbo` — fully autonomous, no approval gates
- Combine freely: `/loop turbo performance 20`

## Steps

1. Run the improvement loop on the current file
2. Choose the skill per improvement type:
   - Correctness → **debug**
   - Concurrency → **debug** or **write-tests**
   - Performance → **optimize**
   - Clarity → **refactor**
3. Follow the Improvement Loop summary in rules.md
4. Wait for my approval before each iteration (skip in turbo mode)

**Iteration Limit:** Maximum 10 iterations (default). Stop and report summary after limit reached, even if improvements remain. User may extend with `/loop 20`.

## Focus Modes

### correctness

- Invoke the **debug** and **write-tests** skills with focus on correctness
- Focus exclusively on: correctness, race conditions, and concurrency safety
- Ignore performance and clarity improvements entirely

### performance

- Invoke the **optimize** skill with focus on performance
- Focus exclusively on: hot path performance, allocations, and cache locality
- Do not touch anything unrelated to performance
- Each iteration must profile before and after and report estimated improvement

## Turbo Mode

- Do not wait for approval between iterations
- Stop immediately on any Hard Stop condition and report why
- **Rollback Requirement:** Before starting, note the current state. If any
  iteration causes test failure count to increase by >2 or a Hard Stop
  condition is hit, report what to revert and stop. User is responsible for
  actual revert via git.

## Hard Stops

- Follow Hard Stops from rules.md
