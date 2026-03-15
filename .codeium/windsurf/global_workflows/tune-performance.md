---
description: Optimize hot paths, allocations, and cache locality only
---
## /tune-performance
Performance-only loop. Tests must stay GREEN.
Run the improvement loop on the current file.
Focus exclusively on: hot path performance, allocations, and cache locality.
Do not touch anything unrelated to performance.
Each iteration must profile before and after and report estimated improvement.
Follow Hard Stops from global_rules.md.
Wait for my approval before each iteration.
