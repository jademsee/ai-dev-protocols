---
name: debug
description: Diagnose and fix software issues
---

# SKILL: Debug & Fix

## Trigger
When asked to debug, fix, investigate, trace, or resolve a bug,
error, crash, incorrect behavior, or test failure.

## Process — follow in order, no skipping
1. UNDERSTAND the symptom first — read the error, log, or
   failing test fully
2. Form a hypothesis — what is the most likely cause?
3. Read the relevant code — do NOT guess without reading
4. Identify the minimal reproduction path
5. Confirm the root cause before writing any fix
6. Propose the fix — explain WHY it addresses the root cause
7. WAIT for approval on non-trivial fixes
8. Implement the minimal fix — do not improve unrelated code
9. Check if a test exists for this case:
   - If no test → invoke **write-tests** skill to add one
   - If test exists but didn't catch bug → fix the test
10. Verify the fix does not break existing tests

## Debugging Framework

### Step 1 — Classify the Bug
- **Logic error** — wrong algorithm or condition
- **State error** — incorrect or stale state
- **Concurrency error** — race condition, deadlock, TOCTOU
- **Integration error** — incorrect assumption about external system
- **Type error** — wrong type, null/undefined, overflow
- **Resource error** — leak, exhaustion, missing cleanup
- **Configuration error** — wrong env, missing config, wrong default

### Step 2 — Locate the Bug
Work from the symptom backwards:
- Where does the incorrect output/behavior manifest?
- What is the last point where behavior was correct?
- What changed between correct and incorrect state?

### Step 3 — Confirm the Root Cause
State explicitly:
- "The root cause is [X] because [evidence]"
- "The fix is [Y] because it addresses [X] by [mechanism]"
- Do NOT propose a fix without this statement

### Step 4 — Fix Minimally
- Change only what is necessary to fix the root cause
- Do not refactor surrounding code as part of the fix
- Do not fix "while you're in there" — separate PRs

## Concurrency Bugs — special process
- Reproduce first with a stress test or sleep injection
- Identify the shared state and the racing operations
- Prefer: eliminate sharing > immutability > synchronization
- Document the invariant being protected in a comment

## Debugging Tools by Language

### JavaScript/TypeScript
- **Debuggers:** Chrome DevTools, VS Code debugger, `node inspect`
- **Logging:** `debug` package, `winston`, `pino`
- **Runtime:** `node --inspect`, `NODE_DEBUG=*`
- **Memory:** `node --inspect` + Chrome Memory tab, `heapdump`

### Python
- **Debuggers:** `pdb`, `ipdb`, VS Code debugger, PyCharm debugger
- **Logging:** `logging` module, `structlog`, `loguru`
- **Runtime:** `python -u` (unbuffered), `faulthandler`
- **Memory:** `tracemalloc`, `memory_profiler`, `objgraph`

### Go
- **Debuggers:** `delve` (`dlv`), VS Code Go extension
- **Logging:** `log` package, `slog`, `zerolog`
- **Runtime:** `GODEBUG=gctrace=1`, `pprof`
- **Concurrency:** `go run -race`, `goroutine` dumps

### Rust
- **Debuggers:** `rust-gdb`, `rust-lldb`, VS Code rust-analyzer
- **Logging:** `log` crate, `env_logger`, `tracing`
- **Runtime:** `RUST_BACKTRACE=1`, `RUST_LOG=debug`
- **Memory:** `valgrind --leak-check=full`

### Java
- **Debuggers:** `jdb`, IntelliJ IDEA debugger, Eclipse debugger
- **Logging:** `SLF4J`, `Log4j2`, `java.util.logging`
- **Runtime:** `-agentlib:jdwp`, `jstack`, `jmap`
- **Memory:** Eclipse MAT, VisualVM, `jhat`

### C#/.NET
- **Debuggers:** Visual Studio debugger, VS Code C# extension
- **Logging:** `Microsoft.Extensions.Logging`, `Serilog`, `NLog`
- **Runtime:** `dotnet-counters`, `dotnet-trace`
- **Memory:** `dotnet-gcdump`, Visual Studio Memory Profiler

### C/C++
- **Debuggers:** `gdb`, `lldb`, Visual Studio debugger
- **Logging:** `spdlog`, custom logging
- **Runtime:** `valgrind`, AddressSanitizer (`-fsanitize=address`)
- **Memory:** Valgrind memcheck, Dr. Memory

### Swift
- **Debuggers:** `lldb`, Xcode debugger
- **Logging:** `os_log`, `print`, `debugPrint`
- **Runtime:** Instruments (Allocations, Leaks)
- **Memory:** Xcode Memory Graph Debugger

### Kotlin
- **Debuggers:** IntelliJ IDEA debugger, Android Studio debugger
- **Logging:** `SLF4J`, `kotlin-logging`, `Timber` (Android)
- **Runtime:** Same as Java
- **Memory:** Same as Java

### Dart/Flutter
- **Debuggers:** VS Code Dart extension, Android Studio debugger
- **Logging:** `dart:developer log()`, `logger` package
- **Runtime:** `flutter run --debug`, DevTools
- **Memory:** Flutter DevTools Memory tab

## Hard Rules
- NEVER fix a symptom without understanding the root cause
- NEVER make a fix that is "probably fine" — be certain
- NEVER widen a catch block to suppress an error
- NEVER add a null check without understanding why null occurs
- NEVER fix a bug without adding a test that catches it
- NEVER change more code than necessary

## Output Format
```
## Bug Report
Symptom: [what is observed]
Location: [file:line]
Root cause: [explanation with evidence]

## Fix
Change: [what to change]
Why: [how this addresses the root cause]
Risk: [any side effects or edge cases to watch]

## Regression Test
[test that would have caught this bug]
```

## Related Skills
- **write-tests** — Add regression tests after fixing bugs
- **refactor** — May be needed if fix requires structural changes
- **audit-security** — For security vulnerability detection

## Pre-Submit Check
- [ ] Root cause confirmed — not just symptom treated
- [ ] Fix is minimal — no unrelated changes
- [ ] Regression test added
- [ ] All existing tests still pass
- [ ] Fix does not introduce new edge cases
