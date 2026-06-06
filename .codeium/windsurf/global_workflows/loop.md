---
description: Run iterative improvements with approval required for each change
---

# /loop

Standard improvement loop with approval gates.

## Steps

1. Run the improvement loop on the current file
2. Choose the skill per improvement type:
   - Correctness → **debug**
   - Concurrency → **debug** or **write-tests**
   - Performance → **optimize**
   - Clarity → **refactor**
3. Follow the Improvement Loop summary in rules.md
4. Wait for my approval before each iteration

**Iteration Limit:** Maximum 10 iterations (default). Stop and report summary after limit reached, even if improvements remain. User may extend with `/loop 20`.
