---
description: Validate project consistency, build status, tests, and dependencies
---
# /validate
Comprehensive project validation using the maintain-consistency skill.

**Validation Process:**

1. **Project Discovery**
   - Detect project type (web app, backend, library, data science, mobile, etc.)
   - Identify languages and frameworks (package.json, requirements.txt, Cargo.toml, etc.)
   - Locate build configuration and test files

2. **Language-Specific Validation**
   
   **JavaScript/TypeScript:**
   - Verify package.json dependencies are installed
   - Check for missing imports or unused dependencies
   - Validate tsconfig.json if present
   - Run linter if configured (eslint, prettier)
   
   **Python:**
   - Check requirements.txt or pyproject.toml consistency
   - Validate imports and module structure
   - Verify virtual environment setup if applicable
   - Run mypy for type checking if configured
   
   **Go:**
   - Run `go vet` for issues
   - Validate go.mod consistency
   - Check for missing imports
   - Run `go build` for compilation errors
   
   **Rust:**
   - Run `cargo check` for compilation errors
   - Validate Cargo.toml dependencies
   - Check for unused dependencies
   - Run `cargo clippy` if available
   
   **Java:**
   - Validate pom.xml or build.gradle
   - Run `mvn compile` or `gradle build`
   - Check for missing dependencies
   - Run checkstyle if configured
   
   **C#/.NET:**
   - Validate .csproj or solution files
   - Run `dotnet build` for compilation
   - Check for missing packages
   - Run Roslyn analyzers if configured
   
   **C/C++:**
   - Validate CMakeLists.txt or Makefile
   - Run compiler (gcc, clang) for syntax errors
   - Check for include issues
   - Run static analysis if configured
   
   **Swift:**
   - Validate Package.swift
   - Run `swift build` for compilation
   - Check dependencies
   - Run SwiftLint if configured
   
   **Kotlin:**
   - Validate build.gradle.kts or pom.xml
   - Run `kotlinc` or gradle build
   - Check for missing dependencies
   - Run detekt if configured
   
   **Dart/Flutter:**
   - Validate pubspec.yaml
   - Run `dart analyze` or `flutter analyze`
   - Check for missing dependencies
   - Run tests if available

3. **Cross-File Consistency**
   - Function/API changes reflected in all callers
   - Type/schema changes updated across codebase
   - Documentation matches implementation
   - Tests cover modified code
   - Configuration files are consistent

4. **Build & Test Status**
   - Attempt build if build system detected
   - Run test suite if tests exist
   - Report test coverage if available
   - Check for broken builds or failing tests

5. **Code Quality Checks**
   - Dead code detection
   - Unused imports/variables
   - Deprecated API usage
   - Security vulnerabilities (if tools available)

**Output Format:**

```
# Validation Report

## Project: [name]
## Type: [project type]
## Languages: [detected languages]

## Status: [PASS/FAIL/WARNINGS]

## Critical Issues (P0)
[List with remediation steps]

## Warnings (P1)
[List with recommendations]

## Summary
- Project Type: [type]
- Languages: [languages]
- Errors: X
- Warnings: Y
- Files Checked: Z
- Tests: [pass/fail/not found]
- Build: [pass/fail/not found]

## Recommended Actions
[Prioritized list of fixes]
```

**Important:**
- Do NOT make any changes - only report findings
- Wait for explicit approval before fixing any issues
- Use available project-specific tools (npm, cargo, pytest, etc.)
- Adapt validation to the actual project structure
