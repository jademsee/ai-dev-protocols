---
description: Run iterative improvements with approval required for each change
---

# /loop

Standard improvement loop with approval gates.

## Steps

1. Run the improvement loop on the current file
2. Invoke the **refactor** skill for each improvement
3. Follow the IMPROVEMENT LOOP PROTOCOL in AGENTS.md
4. Wait for my approval before each iteration

**Iteration Limit:** Maximum 10 iterations (default). Stop and report summary after limit reached, even if improvements remain. User may extend with `/loop 20`.
