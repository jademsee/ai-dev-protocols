---
name: optimize
description: Profile, optimize, or reduce latency
---

# SKILL: Performance Audit & Optimization

## Trigger
When asked to profile, optimize, speed up, reduce latency,
reduce allocations, or audit performance of any code path.

## Process — follow in order, no skipping
1. Read the target code fully — understand it before measuring
2. Identify the hot path: the specific execution path that runs
   most frequently or has the tightest latency budget
3. **Profile first** — use language-specific profiling tools (see below)
4. Analyze statically BEFORE suggesting changes:
   - Time complexity of each operation
   - Memory allocations per call
   - Cache access patterns
   - Lock contention points
   - IO blocking points
5. Rank bottlenecks by impact — fix highest impact first
6. Propose 2-3 optimization options per bottleneck with tradeoffs
7. WAIT for approval before implementing
8. Implement one change at a time
9. **Profile again** — measure actual before/after improvement
10. Run tests — correctness must not regress

## Profiling Tools by Language

### JavaScript/TypeScript
**CPU Profiling:**
- `node --prof` — built-in V8 profiler, generates isolate-*.log
- `node --inspect` + Chrome DevTools — visual flame graphs
- **clinic.js** — comprehensive performance toolkit
  - `clinic doctor` — overall health check
  - `clinic flame` — flame graphs
  - `clinic bubbleprof` — async operations
- **0x** — flamegraph profiler for Node.js

**Memory Profiling:**
- Chrome DevTools Memory tab — heap snapshots, allocation timeline
- `node --inspect --expose-gc` — manual GC triggering
- **clinic.js heapprofiler** — memory leak detection

**Benchmarking:**
- **benchmark.js** — micro-benchmarking
- **autocannon** — HTTP load testing

### Python
**CPU Profiling:**
- **cProfile** — built-in deterministic profiler
- **py-spy** — sampling profiler, no code changes needed
- **scalene** — CPU + memory + GPU profiler
- **austin** — frame stack sampler

**Memory Profiling:**
- **memray** — memory profiler from Bloomberg
- **memory_profiler** — line-by-line memory usage
- **tracemalloc** — built-in memory tracking

**Visualization:**
- **snakeviz** — visualize cProfile output
- **pyinstrument** — call stack profiler with web UI

### Go
**CPU Profiling:**
- **pprof** — built-in profiler
  - `import _ "net/http/pprof"` in code
  - `go tool pprof http://localhost:6060/debug/pprof/profile`
- **fgprof** — full goroutine profiler (includes off-CPU time)

**Memory Profiling:**
- `go tool pprof http://localhost:6060/debug/pprof/heap`
- `go tool pprof -alloc_space` — allocation profiling

**Benchmarking:**
- `go test -bench=. -benchmem` — built-in benchmarking
- **benchstat** — statistical comparison of benchmarks

**Tracing:**
- `go tool trace` — execution tracer for goroutines

### Rust
**CPU Profiling:**
- **cargo-flamegraph** — generates flame graphs
- **perf** (Linux) — `perf record`, `perf report`
- **Instruments** (macOS) — Xcode profiling tools
- **samply** — Firefox profiler integration

**Memory Profiling:**
- **valgrind** with `--tool=massif` — heap profiler
- **heaptrack** — heap memory profiler
- **dhat** — dynamic heap analysis tool

**Benchmarking:**
- **criterion** — statistical benchmarking
- `cargo bench` — built-in benchmarking

### Java
**CPU Profiling:**
- **JProfiler** — commercial profiler
- **VisualVM** — free profiler, bundled with JDK
- **async-profiler** — low-overhead sampling profiler
- **Java Flight Recorder (JFR)** — production-grade profiler

**Memory Profiling:**
- **VisualVM** — heap dumps, memory analysis
- **Eclipse Memory Analyzer (MAT)** — heap dump analysis
- **JProfiler** — live memory monitoring

**Benchmarking:**
- **JMH (Java Microbenchmark Harness)** — gold standard for JVM benchmarks

### C/C++
**CPU Profiling:**
- **perf** (Linux) — `perf record`, `perf report`, `perf top`
- **gprof** — GNU profiler
- **Valgrind** with `--tool=callgrind` — call graph profiler
- **Intel VTune** — advanced profiler (commercial)
- **Instruments** (macOS) — Xcode profiling

**Memory Profiling:**
- **Valgrind** with `--tool=memcheck` — memory errors
- **Valgrind** with `--tool=massif` — heap profiler
- **AddressSanitizer (ASan)** — memory error detector
- **LeakSanitizer (LSan)** — memory leak detector

**Cache Analysis:**
- **Cachegrind** (Valgrind) — cache miss analysis
- **perf stat** — hardware counter statistics

### C#/.NET
**CPU Profiling:**
- **dotnet-trace** — built-in tracing tool
- **PerfView** — free performance analysis tool from Microsoft
- **Visual Studio Profiler** — integrated profiler
- **JetBrains dotTrace** — commercial profiler

**Memory Profiling:**
- **dotnet-counters** — real-time metrics
- **dotnet-gcdump** — GC heap dumps
- **Visual Studio Memory Profiler**
- **JetBrains dotMemory**

**Benchmarking:**
- **BenchmarkDotNet** — comprehensive benchmarking library

### Swift
**Profiling:**
- **Instruments** (Xcode) — Time Profiler, Allocations, Leaks
- **swift package benchmark** — benchmarking support

### Kotlin
**Profiling:**
- Same as Java (JProfiler, VisualVM, async-profiler, JFR)
- **Kotlin Benchmark** — multiplatform benchmarking

### Dart/Flutter
**CPU Profiling:**
- **DevTools Performance** — Flutter DevTools profiler
- **dart run --observe` + Observatory** — Dart VM profiler

**Memory Profiling:**
- **DevTools Memory** — heap snapshots, allocation tracking

## Analysis Framework

### Complexity Analysis
- State the current Big-O for time and space
- Identify any O(n²) or worse in hot paths — these must be fixed
- Identify unnecessary repeated work (recompute vs cache)

### Allocation Analysis
- Count heap allocations per call in the hot path
- Flag: boxing, closure captures, string formatting, collection
  growth, cloning where borrowing suffices
- Prefer stack allocation, object pooling, pre-allocation

### Concurrency Analysis
- Identify lock contention under load
- Identify false sharing (data on same cache line, written by
  different threads)
- Identify unnecessary synchronization on read-only data

### IO Analysis
- Identify blocking IO in hot paths
- Identify N+1 query patterns
- Identify missing batching opportunities
- Identify missing caching opportunities

## Optimization Techniques — prefer in this order
1. Algorithmic improvement (O(n²) → O(n log n))
2. Eliminate unnecessary work (cache, memoize, lazy eval)
3. Reduce allocations (pool, reuse, stack-allocate)
4. Improve cache locality (SoA vs AoS, sequential access)
5. Lock-free data structures (CAS, atomics, ring buffers)
6. Parallelism (only after single-threaded is optimized)

## Hard Rules
- NEVER optimize without understanding the current behavior first
- NEVER introduce lock-free structures without proving correctness
- NEVER sacrifice correctness for performance
- NEVER optimize code that is not in a measured hot path
- NEVER add complexity without a measurable gain
- Document ALL non-obvious optimizations with WHY comments

## Output Format Per Bottleneck
```
### Bottleneck: [name]
Location: [file:line]
Current cost: [complexity / allocs / latency estimate]
Root cause: [explanation]

Option 1: [name]
  Change: [what to do]
  Gain: [estimated improvement]
  Cost: [complexity added, risk]

Option 2: [name]
  ...

Recommendation: [which option and why]
```

## Related Skills
- **write-tests** — Verify no correctness regression after optimization
- **refactor** — May be needed to enable optimization
- **debug** — If performance issue reveals a bug

## Pre-Submit Check
- [ ] All tests pass — no correctness regression
- [ ] Change is limited to identified hot path
- [ ] Non-obvious code is commented with WHY
- [ ] No new locks in hot paths
- [ ] No new dependencies introduced
- [ ] Before/after complexity documented
