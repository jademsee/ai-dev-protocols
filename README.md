# AI Development Protocols

Production-grade configuration system for AI-assisted development. Currently implemented for Windsurf/Cascade, but principles apply to any AI coding agent.

---

## What Is This?

A comprehensive, battle-tested configuration system that transforms AI coding assistants into rigorous engineering partners that:

- **Enforces correctness** - No fast wrong answers, tests pass at every commit, concurrency safety mandatory
- **Maintains architectural consistency** - Reuses existing abstractions, prevents parallel implementations
- **Optimizes hot paths** - Lock-free structures, minimal allocations, measured performance
- **Validates automatically** - Detects broken references, inconsistent coverage, orphaned files

---

## Quick Start

### 1. Install

**For Windsurf/Cascade:**

Copy the `.codeium` directory to your project root:

```bash
cp -r .codeium /path/to/your/project/
```

**For other AI agents:**

Adapt the principles from `@.codeium\windsurf\memories\rules.md` to your agent's configuration format.

### 2. Validate

Run the validation workflow to ensure everything is configured correctly:

```
/validate
```

### 3. Start Using

**Task-Based Prompts** (automatic - AI agent selects approach):
- "Fix this bug" → Debug workflow
- "Add tests" → Test writing workflow
- "Optimize this function" → Performance optimization
- "Create an API endpoint" → API development workflow

**Execution Modes** (manual - control how AI works):
- Deep reasoning with multiple approaches
- Improvement loop with approval gates
- Consistency validation
- Analysis without making changes

---

## What's Included

### Core Components

- **Skills** - Specialized capabilities for development, quality, security, documentation, and operations
- **Workflows** - Execution modes for analysis, improvement loops, and validation
- **Global Rules** - Engineering discipline (correctness > performance > elegance)
- **Validation System** - Automated consistency checking

### Language Support

**10 languages:** JavaScript/TypeScript, Python, Go, Rust, Java, C#/.NET, C/C++, Swift, Kotlin, Dart/Flutter

**Tool categories:**
- Dependency analysis
- Performance profiling
- Security scanning
- Testing frameworks

---

## Documentation

| Document | Purpose |
|----------|---------|
| `docs/SKILLS_MAP.md` | Skill relationships and patterns |
| `docs/CHANGE_CHECKLISTS.md` | Change management checklists |
| `docs/MAINTENANCE_GUIDE.md` | Maintenance protocols |
| `AGENTS.md` | Core engineering principles |
| `.codeium/windsurf/README.md` | Complete configuration guide |

---

## Core Philosophy

### Correctness First
- Fast wrong answers are rejected
- Tests must pass at every commit
- Concurrency correctness is mandatory
- No optimization without profiling

### Architectural Continuity
- Reuse existing abstractions
- No parallel implementations
- Understand before modifying
- No new abstraction without removing old one

### Minimal Changes
- One logical change per commit
- Smallest possible fix for bugs
- No "while I'm here" changes
- Refactors separate from features

---

## Making Changes

**Required protocol for modifying this configuration:**

1. Open `docs/CHANGE_CHECKLISTS.md`
2. Find the appropriate checklist
3. Follow every step
4. Run `/validate` workflow
5. Fix ALL issues before committing

**Never skip validation** - it prevents broken references, inconsistent coverage, and orphaned files.

---

## Key Features

### Engineering Discipline

Global rules enforce:
- Correctness > Performance > Elegance
- Lock-free, allocation-minimal hot paths
- No new dependencies without justification (≥500 LOC replacement)
- Mandatory concurrency correctness

### Comprehensive Skills

Specialized skills with:
- Clear trigger conditions
- Step-by-step processes
- Hard rules preventing mistakes
- Pre-submit checklists
- Language-specific tooling

### Change Management

Automated validation detects:
- Missing or broken skill references
- Inconsistent language coverage
- Orphaned files
- Cross-reference integrity issues

---

## Task Prompts vs Execution Modes

| Aspect | Task Prompts | Execution Modes |
|--------|--------|-----------|
| **Invocation** | Automatic (AI decides) | Manual (you choose) |
| **Command** | Natural language | Agent-specific syntax |
| **Purpose** | Execute tasks | Control execution mode |
| **Example** | "Fix this bug" | Turbo/autonomous mode |

**Use Task Prompts:** When you want the AI to do something  
**Use Execution Modes:** When you want to control HOW the AI works

---

## Examples

### Bug Fix with Tests
```
"Fix the race condition in cache.go and add a test"
→ AI debugs and identifies root cause
→ Adds regression test
→ Commits the fix with clear message
```

### Performance Optimization
```
Performance-focused mode
→ Autonomous loop optimizing hot paths only
→ Validates no correctness regression
→ Documents performance characteristics
```

### New Feature Development
```
"Create a new /users endpoint"
→ AI follows existing API patterns
→ Adds comprehensive endpoint tests
→ Documents API contract
```

---

## Validation

**Windsurf/Cascade:** Run `/validate` workflow

**Any AI agent:** Request validation to check:
- Directory structure integrity
- YAML frontmatter completeness
- Cross-reference validity
- Documentation consistency
- Naming conventions

**When to validate:**
- After modifying any skill or workflow
- After updating documentation
- Before committing configuration changes

---

## Support

For issues:
1. Run `/validate` workflow
2. Check `docs/CHANGE_CHECKLISTS.md`
3. Review `docs/MAINTENANCE_GUIDE.md`
4. Consult `docs/SKILLS_MAP.md`

---

## Platform Support

**Current Implementation:** Windsurf/Cascade (`.codeium` directory structure)  
**Adaptable To:** Cursor, GitHub Copilot, Aider, Continue.dev, or any AI coding agent

**Core Principles Are Universal:**
- Engineering discipline rules apply to any AI assistant
- Task decomposition patterns are platform-agnostic
- Validation and consistency protocols transfer directly

---

## License

MIT License - See [LICENSE](LICENSE) file for details.
