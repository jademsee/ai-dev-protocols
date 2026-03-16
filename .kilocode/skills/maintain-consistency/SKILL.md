---
name: maintain-consistency
description: Ensure comprehensive consistency across all related files, documentation, tests, dependencies, and cross-references when any component is modified
---

# SKILL: Maintain Project Consistency

## Trigger
When asked to ensure consistency, validate changes, check for drift, or verify that all related components are synchronized after a modification.

## Purpose
This skill ensures that when any component of a project is modified, ALL related files, documentation, tests, dependencies, and cross-references are identified and updated to maintain consistency.

---

## Process — follow in order, no skipping

### 1. Identify the Change Type

Determine what was changed:
- [ ] Code (function signature, class interface, API contract)
- [ ] Module/file (refactored, renamed, moved)
- [ ] Database schema
- [ ] Configuration (environment variables, build settings)
- [ ] Dependency (added, updated, removed)
- [ ] Documentation
- [ ] Architecture/design decision

### 2. Map All Related Components

For the identified change, create a comprehensive map of affected items:

**Code Changes:**
- All callers/consumers of the changed code
- All tests that exercise the changed code
- All documentation that describes the changed code
- All type definitions/interfaces that reference the changed code
- All configuration that depends on the changed code

**Schema Changes:**
- Migration files
- ORM models
- API response types
- Database access layer
- Tests that use the schema
- Documentation of data models

**Configuration Changes:**
- .env.example or equivalent
- Deployment configurations (Docker, K8s, etc.)
- CI/CD pipeline files
- Setup documentation
- Validation code that checks configuration

**Dependency Changes:**
- Lock files (package-lock.json, Cargo.lock, go.sum, etc.)
- All modules that import the dependency
- Type definitions if applicable
- Build configuration
- CI/CD that may cache dependencies

### 3. Analyze Impact Using Language-Specific Tools

**Static Analysis:**
- **JavaScript/TypeScript**: Use TypeScript compiler (`tsc --noEmit`), ESLint
- **Python**: Use mypy, pylint, import analysis
- **Go**: Use `go build`, `go vet`, `go mod graph`
- **Rust**: Use `cargo check`, `cargo clippy`
- **Java**: Use compiler, IDE analysis, dependency tools
- **C#/.NET**: Use `dotnet build`, Roslyn analyzers
- **Swift**: Use `swift build`, SwiftLint
- **Kotlin**: Use `kotlinc`, detekt
- **C/C++**: Use compiler (`gcc`, `clang`), Clang Static Analyzer
- **Dart/Flutter**: Use `dart analyze`, `flutter analyze`

**Dependency Analysis:**
- **JavaScript/TypeScript**: dependency-cruiser, madge
- **Python**: import-linter, pipdeptree
- **Go**: `go mod graph`, `go mod why`
- **Rust**: cargo-modules, cargo-tree
- **Java**: jdeps, Maven/Gradle dependency tools
- **C#/.NET**: `dotnet list package`, NDepend
- **Swift**: `swift package show-dependencies`
- **Kotlin**: Konsist, ArchUnit-Kotlin
- **C/C++**: `include-what-you-use`, CMake dependency graphs
- **Dart/Flutter**: `dart pub deps`, lakos

**Find All References:**
- Use IDE "Find All References" or equivalent
- Use grep/ripgrep for text-based search
- Use AST-based tools for semantic search

### 4. Create Change Impact Checklist

Generate a specific checklist for THIS change:

```
## Change Impact Checklist for: [Change Description]

### Files to Update:
- [ ] [file1] - [reason]
- [ ] [file2] - [reason]
...

### Tests to Update/Add:
- [ ] [test1] - [reason]
- [ ] [test2] - [reason]
...

### Documentation to Update:
- [ ] [doc1] - [reason]
- [ ] [doc2] - [reason]
...

### Configuration to Update:
- [ ] [config1] - [reason]
...

### Validation Steps:
- [ ] [validation1]
- [ ] [validation2]
...
```

### 5. Verify Completeness

Check that nothing was missed:

**Cross-Reference Integrity:**
- [ ] All imports/includes are valid
- [ ] All function/method calls are valid
- [ ] All type references are valid
- [ ] All file paths are valid
- [ ] No broken links in documentation

**Test Coverage:**
- [ ] All modified code has corresponding tests
- [ ] All new edge cases have tests
- [ ] All error conditions have tests
- [ ] Tests pass after changes

**Documentation Sync:**
- [ ] README reflects current behavior
- [ ] API docs match implementation
- [ ] Inline comments are accurate
- [ ] Examples still work
- [ ] Architecture docs are current

### 6. Run Automated Validation

Execute project-specific validation:

**Build & Compile:**
```bash
# Verify everything compiles/builds
npm run build          # JavaScript/TypeScript
cargo build           # Rust
go build ./...        # Go
dotnet build          # C#/.NET
mvn compile           # Java
python -m compileall  # Python
swift build           # Swift
kotlinc              # Kotlin
make                  # C/C++
flutter build         # Dart/Flutter
```

**Type Checking:**
```bash
tsc --noEmit          # TypeScript
mypy .                # Python
cargo check           # Rust
swift build           # Swift (includes type checking)
kotlinc              # Kotlin (includes type checking)
```

**Linting:**
```bash
npm run lint          # JavaScript/TypeScript
pylint .              # Python
cargo clippy          # Rust
go vet ./...          # Go
swiftlint             # Swift
detekt                # Kotlin
clang-tidy            # C/C++
dart analyze          # Dart/Flutter
```

**Tests:**
```bash
npm test              # JavaScript/TypeScript
pytest                # Python
cargo test            # Rust
go test ./...         # Go
dotnet test           # C#/.NET
mvn test              # Java
swift test            # Swift
./gradlew test        # Kotlin
ctest                 # C/C++
flutter test          # Dart/Flutter
```

**Dependency Validation:**
```bash
npm audit             # JavaScript/TypeScript
pip-audit             # Python
cargo audit           # Rust
go mod verify         # Go
dotnet list package --vulnerable  # C#/.NET
swift package show-dependencies  # Swift
./gradlew dependencies  # Kotlin
```

### 7. Report Findings

Provide a comprehensive report:

```
## Consistency Validation Report

### Change Summary
[Description of what was changed]

### Impact Analysis
- Files affected: [count]
- Tests affected: [count]
- Documentation affected: [count]

### Updates Required
[List of all updates needed with status]

### Validation Results
- Build: [PASS/FAIL]
- Type Check: [PASS/FAIL]
- Linting: [PASS/FAIL]
- Tests: [PASS/FAIL]
- Dependencies: [PASS/FAIL]

### Issues Found
[List any inconsistencies or broken references]

### Recommendations
[Specific actions to take]
```

### 8. Implement Updates (if approved)

After user approval:
- Make all identified updates
- Run validation again
- Verify all checks pass
- Document what was changed and why

---

## Change Type Patterns

### Pattern 1: Function Signature Change

**What to check:**
1. All call sites (use "Find All References")
2. All tests that call the function
3. All documentation that shows usage
4. All type definitions/interfaces
5. All mocks/stubs in tests

**Validation:**
- Compiler/type checker catches call site issues
- Tests verify behavior still correct
- Documentation examples still work

### Pattern 2: Module Refactor/Rename

**What to check:**
1. All import statements
2. All file paths in configuration
3. All references in documentation
4. All test file paths
5. Build system configuration

**Validation:**
- Build succeeds
- All imports resolve
- Tests still run
- Documentation links work

### Pattern 3: Database Schema Change

**What to check:**
1. Migration files (create new migration)
2. ORM models/entities
3. API response types
4. Database access layer (queries, repositories)
5. Tests that use the schema
6. Seed data/fixtures
7. Documentation of data model

**Validation:**
- Migration runs successfully
- All queries still work
- Tests pass with new schema
- API contracts maintained (or versioned)

### Pattern 4: API Contract Change

**What to check:**
1. API documentation (OpenAPI/Swagger)
2. Client code that calls the API
3. Tests for the endpoint
4. Type definitions (request/response)
5. Validation schemas
6. Error handling
7. Integration tests

**Validation:**
- API tests pass
- Contract tests pass (if using)
- Documentation matches implementation
- Breaking changes are versioned

### Pattern 5: Configuration Change

**What to check:**
1. .env.example or config template
2. Deployment configs (Docker, K8s, etc.)
3. CI/CD pipeline files
4. Setup/installation documentation
5. Configuration validation code
6. Default values in code

**Validation:**
- Application starts with new config
- Validation catches missing values
- Documentation is clear
- CI/CD still works

### Pattern 6: Dependency Update

**What to check:**
1. Lock file updated
2. Breaking changes in changelog
3. All usage of the dependency
4. Type definitions (if applicable)
5. Build configuration
6. CI/CD caching

**Validation:**
- Build succeeds
- Tests pass
- No security vulnerabilities
- Performance not degraded

---

## Automated Tools by Language

### JavaScript/TypeScript
**Consistency Checking:**
- `tsc --noEmit` - Type checking
- `eslint` - Linting
- `dependency-cruiser` - Dependency validation
- `madge` - Circular dependency detection
- `npm-check-updates` - Dependency updates
- `jest --coverage` - Test coverage

**Dead Code Detection:**
- `ts-prune` - Find unused exports
- `unimported` - Find unused files

### Python
**Consistency Checking:**
- `mypy` - Type checking
- `pylint` - Linting
- `import-linter` - Import rules
- `pipdeptree` - Dependency tree
- `pytest --cov` - Test coverage

**Dead Code Detection:**
- `vulture` - Find dead code
- `coverage` - Identify untested code

### Go
**Consistency Checking:**
- `go build ./...` - Compilation
- `go vet ./...` - Static analysis
- `go mod verify` - Dependency verification
- `go mod graph` - Dependency graph
- `staticcheck` - Advanced linting

**Dead Code Detection:**
- `deadcode` - Find unreachable code

### Rust
**Consistency Checking:**
- `cargo check` - Fast compilation check
- `cargo clippy` - Linting
- `cargo audit` - Security audit
- `cargo-modules` - Module structure
- `cargo test` - Run tests

**Dead Code Detection:**
- `cargo-udeps` - Find unused dependencies
- Compiler warnings for unused code

### Java
**Consistency Checking:**
- `mvn compile` or `gradle build` - Compilation
- `jdeps` - Dependency analysis
- `checkstyle` - Code style
- `spotbugs` - Bug detection

**Dead Code Detection:**
- `proguard` - Shrink and optimize
- IDE analysis tools

### C#/.NET
**Consistency Checking:**
- `dotnet build` - Compilation
- `dotnet list package --vulnerable` - Security
- Roslyn analyzers - Code analysis
- `dotnet test` - Run tests

**Dead Code Detection:**
- Visual Studio Code Analysis
- ReSharper (commercial)

### Swift
**Consistency Checking:**
- `swift build` - Compilation
- `swiftlint` - Linting
- `swift package show-dependencies` - Dependency tree
- `swift test` - Run tests

**Dead Code Detection:**
- Xcode unused code warnings
- SwiftLint unused code rules

### Kotlin
**Consistency Checking:**
- `kotlinc` - Compilation
- `detekt` - Static analysis
- `./gradlew dependencies` - Dependency tree
- `./gradlew test` - Run tests
- Konsist - Architecture rules

**Dead Code Detection:**
- IDE unused code detection
- detekt unused code rules

### C/C++
**Consistency Checking:**
- `gcc` or `clang` - Compilation
- `clang-tidy` - Linting
- `include-what-you-use` - Include analysis
- `ctest` - Run tests
- `make` or `cmake` - Build system

**Dead Code Detection:**
- Compiler warnings (`-Wunused`)
- `cppcheck` - Static analysis
- Clang Static Analyzer

### Dart/Flutter
**Consistency Checking:**
- `dart analyze` - Static analysis
- `flutter analyze` - Flutter-specific analysis
- `dart pub deps` - Dependency tree
- `flutter test` - Run tests
- `dart format` - Code formatting

**Dead Code Detection:**
- Dart analyzer unused code warnings
- `dart fix` - Apply fixes including removing dead code

---

## Hard Rules

- NEVER assume a change is isolated — always map dependencies
- NEVER skip validation after making updates
- NEVER update code without updating corresponding tests
- NEVER update implementation without updating documentation
- NEVER make breaking changes without versioning or migration path
- NEVER ignore compiler/linter warnings introduced by changes
- NEVER commit if validation fails

---

## Pre-Submit Checklist

After ensuring consistency:
- [ ] All affected files identified and updated
- [ ] All tests pass (including new/updated tests)
- [ ] All documentation updated
- [ ] Build succeeds without warnings
- [ ] Type checking passes (if applicable)
- [ ] Linting passes
- [ ] No broken references or imports
- [ ] No dead code introduced
- [ ] Dependency lock files updated
- [ ] Configuration examples updated
- [ ] Migration path documented (for breaking changes)

---

## Integration with Other Skills

This skill works in conjunction with:
- **refactor** - Ensures refactoring maintains consistency
- **create** - Ensures new components integrate properly
- **develop-api** - Ensures API changes update all consumers
- **architect** - Validates architectural decisions are reflected everywhere
- **write-tests** - Ensures test coverage for all changes
- **write-docs** - Ensures documentation stays synchronized

---

## Output Format

```
## Consistency Check: [Change Description]

### Change Type
[Code/Schema/Config/Dependency/etc.]

### Impact Analysis
Files to update: [count]
- [file1] - [reason]
- [file2] - [reason]
...

Tests to update: [count]
- [test1] - [reason]
...

Documentation to update: [count]
- [doc1] - [reason]
...

### Validation Results
✓ Build: PASS
✓ Type Check: PASS
✓ Linting: PASS
✓ Tests: PASS (X/Y passing)
✓ Dependencies: PASS

### Issues Found
[None / List of issues]

### Recommendations
1. [Action 1]
2. [Action 2]
...

### Next Steps
[What to do next]
```

---

## Examples

### Example 1: Function Signature Change

**Change:** Added a new required parameter to `processOrder(orderId, userId)`

**Impact Analysis:**
- 23 call sites found
- 8 test files affected
- 2 documentation files reference this function
- 1 API endpoint uses this function

**Updates Required:**
- Update all 23 call sites to pass userId
- Update 8 test files with new parameter
- Update API documentation
- Update README example
- Add migration guide for external consumers

**Validation:**
- TypeScript compiler catches all call sites ✓
- All tests pass after updates ✓
- Documentation examples work ✓

### Example 2: Database Schema Change

**Change:** Added `email_verified` column to `users` table

**Impact Analysis:**
- 1 migration file to create
- User model/entity to update
- 3 API endpoints return user data
- 12 tests use user fixtures
- 1 documentation file describes user model

**Updates Required:**
- Create migration adding column with default value
- Update User model with new field
- Update API response types
- Update test fixtures
- Update data model documentation
- Update seed data

**Validation:**
- Migration runs successfully ✓
- All queries still work ✓
- API tests pass ✓
- Documentation matches schema ✓
