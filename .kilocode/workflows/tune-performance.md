---
description: Optimize hot paths, allocations, and cache locality only
---

# /tune-performance

Performance-only loop. Tests must stay GREEN.

## Steps

1. Run the improvement loop on the current file
2. Invoke the **optimize** skill with focus on performance
3. Focus exclusively on: hot path performance, allocations, and cache locality
4. Do not touch anything unrelated to performance
5. Each iteration must profile before and after and report estimated improvement
6. Follow Hard Stops from AGENTS.md
7. Wait for my approval before each iteration
