---
description: Optimize hot paths, allocations, and cache locality only
---

# /tune-performance

Performance-only loop. Tests must stay GREEN.

## Steps

1. Run the improvement loop on the current file
2. Focus exclusively on: hot path performance, allocations, and cache locality
3. Do not touch anything unrelated to performance
4. Each iteration must profile before and after and report estimated improvement
5. Follow Hard Stops from AGENTS.md
6. Wait for my approval before each iteration
