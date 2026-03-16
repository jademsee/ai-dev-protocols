---
name: create-item
description: Create a new file, module, or service
---

# SKILL: Create New Module

## Trigger
When asked to create a new file, module, class, service, package,
or any new unit of code that does not yet exist.

## Process — follow in order, no skipping
1. Read at least 3 existing modules of the same type/layer
2. Identify the directory structure and where this belongs
3. Identify the naming conventions used
4. Identify the standard module shape (imports order, exports style,
   class vs functional, etc.)
5. Identify any base classes, interfaces, or abstractions to extend
6. Check: does an equivalent already exist? If so, STOP and report
7. Propose the module interface (public API only) — WAIT for approval
8. Implement the module following existing patterns exactly
9. Write corresponding tests:
   - Test happy path with valid input
   - Test auth failure cases
   - Test validation errors
   - Follow existing test patterns in the test directory
10. Register/wire the module into the application

## Module Structure — match existing, default to:
```
[license header if project uses one]
[imports: std lib → third party → internal → types]
[constants]
[types / interfaces]
[main export: class or functions]
[private helpers at bottom]
```

## Standards
- Single responsibility — one primary concern per module
- Explicit public API — everything not exported is private
- No circular imports — check before creating
- No side effects at module load time
- Dependency injection over direct imports of singletons
- Follow existing error handling patterns exactly

## Naming — ALWAYS detect from existing code first

**Step 1: Read 3+ existing files of the same type**
Extract: file naming pattern, class naming, function naming, constant naming.

**Step 2: Use detected conventions. Only use these defaults if no convention is established:**

**JavaScript/TypeScript defaults:**
- File: kebab-case (`user-profile-service.ts`)
- Class: PascalCase (`UserProfileService`)
- Functions: camelCase (`getUserProfile`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)

**Python defaults:**
- File: snake_case (`user_profile_service.py`)
- Class: PascalCase (`UserProfileService`)
- Functions: snake_case (`get_user_profile`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)

**Go defaults:**
- Package: lowercase, single word (`userprofile`)
- File: snake_case (`user_profile.go`)
- Exports: PascalCase (`GetUserProfile`)
- Non-exports: camelCase (`getUserProfile`)

**Rust defaults:**
- File: snake_case (`user_profile.rs`)
- Struct/Enum: PascalCase (`UserProfile`)
- Functions: snake_case (`get_user_profile`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)

**Java/Kotlin defaults:**
- File: PascalCase matching class (`UserProfileService.java`)
- Class: PascalCase (`UserProfileService`)
- Methods: camelCase (`getUserProfile`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)

## Integration Checklist
After creating the module, update:
- [ ] Index/barrel exports (if project uses them)
- [ ] DI container registration (if project uses DI)
- [ ] Module registry or config (if applicable)
- [ ] Documentation index (if project maintains one)

## Hard Rules
- NEVER create a module that duplicates existing functionality
- NEVER add a new dependency for the new module without justification
- NEVER create a module with more than one primary responsibility
- NEVER use global state inside a module
- NEVER skip writing tests for the new module

## Pre-Submit Check
- [ ] No equivalent module already exists
- [ ] Follows existing directory structure
- [ ] Naming matches conventions
- [ ] No circular imports introduced
- [ ] Wired into application correctly
- [ ] Tests written and passing
- [ ] Public API is minimal and intentional
