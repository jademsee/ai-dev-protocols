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

## Testing Frameworks by Language

### JavaScript/TypeScript
**Unit Testing:**
- **Jest** — most popular, batteries-included
- **Vitest** — fast Vite-native alternative
- **Mocha** + **Chai** — flexible, composable

**Mocking:**
- Jest built-in mocks
- **Sinon.js** — spies, stubs, mocks

**E2E/Integration:**
- **Playwright** — modern browser automation
- **Cypress** — developer-friendly E2E

### Python
**Unit Testing:**
- **pytest** — de facto standard, fixture-based
- **unittest** — built-in, xUnit-style

**Mocking:**
- **unittest.mock** — built-in mocking
- **pytest-mock** — pytest wrapper for mock

**Property-Based:**
- **Hypothesis** — generative testing

### Go
**Unit Testing:**
- **testing** package — built-in, table-driven tests
- **testify** — assertions and mocking

**Mocking:**
- **gomock** — official mock framework
- **testify/mock** — simpler alternative

**Race Detection:**
- `go test -race` — built-in race detector

### Rust
**Unit Testing:**
- Built-in `#[test]` and `#[cfg(test)]`
- **rstest** — fixture-based testing

**Mocking:**
- **mockall** — mock object library
- **mockito** — HTTP mocking

**Property-Based:**
- **proptest** — property-based testing
- **quickcheck** — QuickCheck port

### Java
**Unit Testing:**
- **JUnit 5** — standard framework
- **TestNG** — alternative with more features

**Mocking:**
- **Mockito** — most popular mocking
- **JMockit** — advanced mocking

**Property-Based:**
- **jqwik** — property-based testing

**Integration:**
- **Spring Test** — Spring integration testing
- **Testcontainers** — Docker-based integration tests

### C#/.NET
**Unit Testing:**
- **xUnit** — modern, recommended
- **NUnit** — mature alternative
- **MSTest** — Microsoft's framework

**Mocking:**
- **Moq** — most popular
- **NSubstitute** — simpler syntax

**Integration:**
- **WebApplicationFactory** — ASP.NET Core testing

### C/C++
**Unit Testing:**
- **Google Test (gtest)** — most popular
- **Catch2** — header-only, BDD-style
- **Doctest** — fastest compile times

**Mocking:**
- **Google Mock (gmock)** — works with gtest
- **FakeIt** — header-only mocking

**Memory Testing:**
- **Valgrind** — memory leak detection
- **AddressSanitizer** — memory error detector

### Swift
**Unit Testing:**
- **XCTest** — built-in framework
- **Quick** + **Nimble** — BDD-style

**Mocking:**
- **Cuckoo** — mock generator
- Manual protocol-based mocking

**UI Testing:**
- **XCUITest** — UI automation

### Kotlin
**Unit Testing:**
- **JUnit 5** — same as Java
- **Kotest** — Kotlin-native framework

**Mocking:**
- **MockK** — Kotlin-first mocking
- **Mockito-Kotlin** — Mockito wrapper

**Coroutine Testing:**
- **kotlinx-coroutines-test** — coroutine testing utilities

### Dart/Flutter
**Unit Testing:**
- **test** package — built-in Dart testing
- **flutter_test** — Flutter widget testing

**Mocking:**
- **mockito** — Dart port
- **mocktail** — null-safe alternative

**Widget Testing:**
- **flutter_test** — widget unit tests
- **golden_toolkit** — screenshot testing

**Integration:**
- **integration_test** — Flutter integration tests

## Test Framework Detection

When running tests, detect the framework using this 4-step hierarchy.

**Supported Languages:** JavaScript/TypeScript, Python, Go, Rust, Java, C#/.NET, C/C++, Swift, Kotlin, Dart/Flutter

### Step 1: Check for Test Runner Config Files

**JavaScript/TypeScript:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `jest.config.js/ts/mjs` | Jest | `npm test` or `npx jest` |
| `vitest.config.js/ts` | Vitest | `npx vitest` |
| `.mocharc.js/json/yaml` | Mocha | `npx mocha` |
| `karma.conf.js` | Karma | `npx karma start` |
| `playwright.config.ts` | Playwright | `npx playwright test` |
| `cypress.config.js/ts` | Cypress | `npx cypress run` |
| `ava.config.js/cjs/mjs` | AVA | `npx ava` |

**Python:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `pytest.ini` | pytest | `pytest` |
| `pyproject.toml [tool.pytest]` | pytest | `pytest` |
| `setup.cfg [tool:pytest]` | pytest | `pytest` |
| `tox.ini` | tox+pytest | `tox` |

**Rust:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `Cargo.toml` | cargo test | `cargo test` |

**Go:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `go.mod` | go test | `go test ./...` |

**Java/Kotlin:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `pom.xml` | Maven/JUnit | `mvn test` |
| `build.gradle` or `build.gradle.kts` | Gradle/JUnit | `./gradlew test` |

**C#/.NET:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `*.csproj` | dotnet test (xUnit/NUnit/MSTest) | `dotnet test` |
| `*.sln` | dotnet test | `dotnet test` |

**C/C++:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `CMakeLists.txt` with CTest | CTest | `ctest` |
| `Makefile` with test target | make test | `make test` |
| `meson.build` | Meson test | `meson test` |

**Swift:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `Package.swift` | XCTest | `swift test` |
| `*.xcodeproj` or `*.xcworkspace` | XCTest | `xcodebuild test` |

**Dart/Flutter:**
| File | Framework | Run Command |
|------|-----------|-------------|
| `pubspec.yaml` | dart test | `dart test` |
| `pubspec.yaml` (Flutter project) | flutter test | `flutter test` |

### Step 2: Check Package Manager Files
- **package.json**: Check `scripts.test`, `devDependencies` for jest/vitest/mocha/ava
- **pyproject.toml**: Check `[tool.poetry.dev-dependencies]` or `[project.optional-dependencies]`
- **pubspec.yaml**: Check `dev_dependencies` for `test:` or `flutter_test:`

### Step 3: Check Directory Structure
- `__tests__/`, `*.test.js/ts`, `*.spec.js/ts` → JavaScript/TypeScript
- `tests/`, `test_*.py`, `*_test.py` → Python
- `*_test.go` → Go
- `src/test/` → Java/Kotlin
- `test/` (with Dart files) → Dart/Flutter
- `Tests/` (with Swift files) → Swift

### Step 4: Detect from CI Config
Read existing CI config (`.github/workflows/*.yml`, `.gitlab-ci.yml`, `Jenkinsfile`, `azure-pipelines.yml`) for actual test commands being used.

**Report format:** "Detected: [framework] via [config file/method]. Run command: [cmd]"
**If ambiguous:** List all detected and ask which to use.
**If none detected:** Ask user for framework and run command.

---

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
