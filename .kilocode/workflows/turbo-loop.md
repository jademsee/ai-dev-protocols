---
description: Run autonomous improvement loop without approval gates
---

# /turbo-loop

Fully autonomous loop, no approval gates.

## Steps

1. Run the improvement loop on the current file using Turbo Mode
2. Follow the IMPROVEMENT LOOP PROTOCOL in AGENTS.md
3. Do not wait for approval between iterations
4. Stop immediately on any Hard Stop condition and report why

**Iteration Limit:** Maximum 10 iterations (default). Stop after limit even if improvements remain. User may extend with `/turbo-loop 20`.

**Rollback Requirement:** Before starting, note the current state. If any iteration causes test failure count to increase by >2 or a Hard Stop condition is hit, report what to revert and stop. User is responsible for actual revert via git.
