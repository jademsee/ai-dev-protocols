---
name: write-tests
description: Write tests to ensure the code works as expected and doesn't break when you make changes
---

# SKILL: Write Tests

## Trigger
When asked to write, add, fix, or improve tests for any module,
function, class, or feature.

## Process — follow in order, no skipping
1. Read the module under test FULLY before writing anything
2. Identify all public interfaces, side effects, and edge cases
3. Read existing test files to extract naming, structure, and
   assertion patterns — match them exactly
4. Map out test cases before writing: happy path, edge cases,
   error cases, concurrency cases
5. Write tests in that order
6. Run tests and confirm GREEN before presenting output

## Standards
- One logical assertion per test where possible
- Test BEHAVIOR, not implementation details
- No mocks unless: IO, time, network, or non-determinism is involved
- When mocking, mock at the boundary — never mock internals
- Name format: "should [expected behavior] when [condition]"
- Group with describe blocks mirroring module structure

## Test Coverage Order
1. Happy path — normal expected usage
2. Boundary conditions — min/max values, empty inputs, zero
3. Edge cases — nulls, undefined, empty collections, overflow
4. Error/failure cases — invalid input, missing deps, timeouts
5. Concurrency cases (only if module is concurrent):
   - Race conditions between concurrent operations
   - Double-calls and reentrancy
   - Interleaved operations in different orders
   - Deadlock and livelock scenarios
   - Data races on shared state

## Hard Rules
- NEVER delete or weaken existing tests
- NEVER change assertions to make a test pass — fix the code
- If an existing test appears wrong, FLAG it, do not silently fix it
- Do not test private/internal functions directly
- Do not write tests that depend on execution order

## Performance
- Tests must be fast — no real sleeps, use fake timers
- No real network calls — mock at transport layer
- Each test must be independently runnable

## Concurrency Testing [CONDITIONAL: skip if module has no concurrency]

### Detection Check — Answer BEFORE proceeding:
Does this module use ANY of the following?
- Threads, goroutines, async/await, actors, channels
- Locks, mutexes, semaphores, synchronization primitives
- Shared mutable state across execution contexts
- Documentation claiming thread-safety or concurrent operation

**If ALL answers are NO → Skip this entire section. No concurrency tests needed.**

### When Concurrency Tests Are Required
- Module uses locks, mutexes, or synchronization primitives
- Module accesses shared mutable state
- Module is documented as thread-safe or concurrent
- Module uses async/await, goroutines, threads, or actors

### Concurrency Testing Patterns

#### 1. Race Condition Detection
Use language-specific race detectors:
- **Go**: Run tests with `-race` flag: `go test -race`
- **Rust**: Use `cargo test` with ThreadSanitizer
- **Java**: Use ThreadSanitizer or tools like jcstress
- **C/C++**: Use ThreadSanitizer (TSan) or Helgrind (Valgrind)
- **JavaScript**: Use `--expose-gc` and stress testing

#### 2. Stress Testing
Run operations in parallel with high contention:
```
Test pattern:
1. Spawn N concurrent operations (N = 100-1000)
2. All operations access the same shared resource
3. Verify invariants hold after all complete
4. Verify no data corruption or lost updates
```

#### 3. Property-Based Testing
Use frameworks to test concurrent properties:
- **JavaScript/TypeScript**: fast-check
- **Python**: Hypothesis
- **Haskell**: QuickCheck
- **Rust**: proptest, quickcheck
- **Java**: jqwik
- **Scala**: ScalaCheck

#### 4. Interleaving Tests
Test different operation orders:
```
Test pattern:
1. Define operations A, B, C
2. Test all orderings: ABC, ACB, BAC, BCA, CAB, CBA
3. Verify invariants hold for all orderings
4. Use tools like Loom (Java) or shuttle (Rust) for systematic testing
```

#### 5. Deadlock Detection
- Set timeouts on all concurrent tests (fail if timeout exceeded)
- Use deadlock detectors: Java VisualVM, Go runtime deadlock detector
- Test with different lock acquisition orders
- Verify lock ordering is consistent

#### 6. Liveness Testing
Verify progress guarantees:
- Operations eventually complete (no infinite loops)
- No starvation (all threads make progress)
- Use bounded wait times and verify completion

### Concurrency Test Checklist
- [ ] Race detector enabled and passing
- [ ] Stress test with high concurrency (100+ operations)
- [ ] All shared state access is synchronized
- [ ] No data races reported by tools
- [ ] Deadlock timeout tests pass
- [ ] Invariants verified after concurrent operations
- [ ] Property-based tests cover concurrent scenarios

### Concurrency Anti-Patterns to Avoid
- **Sleep-based synchronization** — use proper sync primitives
- **Assuming operation order** — concurrent code is non-deterministic
- **Single-threaded tests only** — concurrency bugs won't appear
- **Ignoring race detector warnings** — they indicate real bugs

## Pre-Submit Check
- [ ] All new tests pass
- [ ] No existing tests broken
- [ ] Coverage includes error paths
- [ ] No real IO in unit tests
- [ ] Naming is consistent with existing suite
