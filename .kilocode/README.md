# Kilo Code Configuration

This directory contains the Kilo Code AI coding assistant configuration, ported from Windsurf/Cascade.

## Directory Structure

```
.kilocode/
├── rules/                    # Project-level rules
│   └── rules.md              # Complete rules (same name as source)
├── workflows/                # Custom workflows (slash commands)
│   ├── diagnose.md
│   ├── prescribe.md
│   ├── enhance-prompt.md
│   ├── loop.md
│   ├── turbo-loop.md
│   ├── improve-correctness.md
│   ├── test.md
│   ├── tune-performance.md
│   └── validate.md
├── skills/                   # Specialized skills
│   ├── analyze-metrics/
│   ├── audit-security/
│   ├── create-item/
│   ├── debug/
│   ├── design-architecture/
│   ├── develop-api/
│   ├── maintain-consistency/
│   ├── manage-dependencies/
│   ├── manage-git/
│   ├── manage-secrets/
│   ├── optimize/
│   ├── recover-design/
│   ├── refactor/
│   ├── visualize-project/
│   ├── write-docs/
│   └── write-tests/
├── PORTING_MANIFEST.md       # Source-to-target mapping
└── README.md                 # This file
```

## Shared Documentation

The following documentation is shared across all tool configs and located in `docs/`:

| File | Location | Purpose |
|------|----------|---------|
| `SKILLS_MAP.md` | `docs/SKILLS_MAP.md` | Skill relationships and invocation patterns |
| `CHANGE_CHECKLISTS.md` | `docs/CHANGE_CHECKLISTS.md` | Change management checklists |
| `MAINTENANCE_GUIDE.md` | `docs/MAINTENANCE_GUIDE.md` | Maintenance protocols |
| `AI_AGENT_FEATURE_MAPPING.md` | `docs/AI_AGENT_FEATURE_MAPPING.md` | Cross-agent feature compatibility |

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

## Usage

### Workflows

Invoke workflows using slash commands:

- `/diagnose` — Diagnose code structure, patterns, and risks
- `/prescribe` — Prescribe prioritized improvements without code changes
- `/enhance-prompt` — Transform prompts into actionable requests
- `/loop` — Iterative improvements with approval gates
- `/turbo-loop` — Autonomous improvement loop
- `/improve-correctness` — Focus on correctness and concurrency only
- `/test` — Test-driven improvement loop
- `/tune-performance` — Performance optimization only
- `/validate` — Comprehensive project validation

### Skills

Skills are automatically invoked based on trigger conditions. You can also explicitly invoke them:

- `use the debug skill` — Diagnose and fix software issues
- `use the write-tests skill` — Write tests for modules
- `use the write-docs skill` — Write or update documentation
- `use the refactor skill` — Restructure code cleanly
- `use the optimize skill` — Profile and optimize performance
- `use the maintain-consistency skill` — Ensure cross-file consistency
- `use the manage-dependencies skill` — Manage project dependencies
- `use the manage-secrets skill` — Set up secrets management
- `use the manage-git skill` — Git operations and commits
- `use the develop-api skill` — Create API endpoints
- `use the create-item skill` — Create new modules/files
- `use the design-architecture skill` — Plan and design architecture
- `use the recover-design skill` — Reverse engineer existing code
- `use the audit-security skill` — Security audit and hardening
- `use the visualize-project skill` — Codebase structure visualization
- `use the analyze-metrics skill` — Runtime/process metrics visualization

## Supported Languages

All skills and modes support 10 languages:

- JavaScript/TypeScript
- Python
- Go
- Rust
- Java
- C#/.NET
- C/C++
- Swift
- Kotlin
- Dart/Flutter

## Key Features

1. **Engineering Discipline** — Correctness > Performance > Elegance
2. **Architectural Continuity** — Reuse existing patterns and abstractions
3. **Change Management** — Comprehensive synchronization of related components
4. **Multi-Language Support** — Language-specific tools and patterns
5. **Security-First** — Secrets management and security auditing built-in

## Porting Source

This configuration was ported from `.codeium/windsurf/` (Windsurf/Cascade configuration).

See `PORTING_MANIFEST.md` for detailed source-to-target mapping.
