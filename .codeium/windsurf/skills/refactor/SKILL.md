---
name: refactor
description: Make code cleaner, more understandable, and easier to maintain or extend
---

# SKILL: Refactor Module

## Trigger
When asked to refactor, restructure, reorganize, clean up, or
improve the design of an existing module or file.

## Process — follow in order, no skipping
1. Read the entire module before touching anything
2. Read all callers/importers of the module
3. Run existing tests — confirm GREEN baseline before any change
4. Identify the specific problem being solved by the refactor
5. Propose the refactor plan with minimal change set
6. WAIT for approval
7. Refactor in small, test-passing increments — not one big rewrite
8. Run tests after each increment
9. Update callers only after the module is stable

## Refactor Categories — approach each differently

### Rename
- Use IDE rename tool, not find/replace
- Update all imports, type references, and tests
- Single commit per rename

### Extract Function/Module
- New function must have a single clear responsibility
- Must not increase the call depth unnecessarily
- All existing tests must still pass without modification

### Simplify Logic
- Must not change observable behavior
- Must have test coverage before simplifying
- Prefer clarity over micro-optimization here

### Restructure Files
- Follow existing directory conventions exactly
- Update all import paths
- Do not change public API during restructure

### Remove Dead Code
- Confirm code is unreachable via search of entire codebase
- Do not remove code that may be called dynamically (reflection,
  string-based dispatch, plugin systems)
- Flag and confirm before deleting

## Hard Rules
- NEVER refactor and add features in the same change
- NEVER change public API shape during a refactor
- NEVER rewrite working code "for clarity" without a clear
  measurable improvement
- NEVER refactor without a GREEN test baseline first
- NEVER change more files than necessary
- One concern per commit

## Scope Limits — STOP and ask for explicit approval if refactor would require:
- Changing more files than typical for the project (default: 5 files;
  larger monorepos may use 10-15; microservices may use 2-3)
- Modifying a public API
- Touching code outside the original module's directory
- Deleting significant logic (default: >20 lines; always show diff first)

## Refactoring Tools by Language

### JavaScript/TypeScript
- **Rename:** IDE rename tool (VS Code, WebStorm), `ts-morph`
- **Extract:** IDE extract method/function, `vscode-js-refactor`
- **Move:** `ts-morph` for programmatic moves, IDE move refactoring
- **Dead Code:** `ts-prune`, `unimported`, `depcheck`

### Python
- **Rename:** IDE rename tool (PyCharm, VS Code), `rope`
- **Extract:** IDE extract method, `rope`
- **Move:** IDE move refactoring, `rope`
- **Dead Code:** `vulture`, `pyflakes`, `autoflake`

### Go
- **Rename:** `gorename`, IDE rename (GoLand, VS Code)
- **Extract:** IDE extract method, `godoctor`
- **Move:** IDE move refactoring
- **Dead Code:** `deadcode`, `staticcheck`

### Rust
- **Rename:** IDE rename (rust-analyzer, IntelliJ Rust)
- **Extract:** IDE extract method, `rust-analyzer` assists
- **Move:** IDE move refactoring
- **Dead Code:** `cargo-udeps`, compiler warnings (`unused`)

### Java
- **Rename:** IDE rename (IntelliJ IDEA, Eclipse)
- **Extract:** IDE extract method/class/interface
- **Move:** IDE move refactoring
- **Dead Code:** IDE unused code detection, `proguard`

### C#/.NET
- **Rename:** IDE rename (Visual Studio, VS Code)
- **Extract:** IDE extract method/class/interface
- **Move:** IDE move refactoring
- **Dead Code:** IDE unused code detection, ReSharper

### C/C++
- **Rename:** IDE rename (CLion, Visual Studio), `clang-rename`
- **Extract:** IDE extract method
- **Move:** IDE move refactoring
- **Dead Code:** `cppcheck`, compiler warnings (`-Wunused`)

### Swift
- **Rename:** IDE rename (Xcode)
- **Extract:** IDE extract method
- **Move:** IDE move refactoring
- **Dead Code:** Xcode unused code warnings, SwiftLint

### Kotlin
- **Rename:** IDE rename (IntelliJ IDEA, Android Studio)
- **Extract:** IDE extract method/class
- **Move:** IDE move refactoring
- **Dead Code:** IDE unused code detection, `detekt`

### Dart/Flutter
- **Rename:** IDE rename (VS Code, Android Studio)
- **Extract:** IDE extract method/widget
- **Move:** IDE move refactoring
- **Dead Code:** `dart analyze`, `dart fix`

## Related Skills
- **write-tests** — Verify tests pass before and after refactoring
- **debug** — If refactoring reveals unexpected behavior
- **maintain-consistency** — Ensure all callers and docs updated

## Pre-Submit Check
- [ ] Tests GREEN before and after
- [ ] No behavior change — only structural change
- [ ] No public API modified
- [ ] All callers updated if signatures changed
- [ ] No new abstractions added without removing old ones
- [ ] Change is minimal — no scope creep
