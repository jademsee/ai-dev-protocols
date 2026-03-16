# Kilo Code Configuration

This directory contains the Kilo Code AI coding assistant configuration, ported from Windsurf/Cascade.

## Directory Structure

```
.kilocode/
├── rules/                    # Project-level rules
│   ├── engineering-principles.md
│   ├── secrets-management.md
│   └── improvement-loop.md
├── modes/                    # Custom modes (workflows)
│   ├── analyze.yaml
│   ├── think.yaml
│   ├── dry-run.yaml
│   ├── enhance-prompt.yaml
│   ├── quick.yaml
│   ├── loop.yaml
│   ├── turbo-loop.yaml
│   ├── fix-correctness.yaml
│   ├── test.yaml
│   ├── tune-performance.yaml
│   ├── stop.yaml
│   └── validate.yaml
├── skills/                   # Specialized skills
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

## AGENTS.md — Global Rules File

`AGENTS.md` lives at the **repository root** (`/AGENTS.md`) and contains the core engineering principles and protocols for this project.

### Location

```
<repo-root>/
└── AGENTS.md   ← place here, not inside .kilocode/
```

It must be at the root so all AI tools can discover it by walking up from the working directory.

### Which agents read AGENTS.md natively

| Agent | Reads AGENTS.md? | Native config file | Notes |
|-------|------------------|--------------------|-------|
| **Kilo Code** | ✅ Yes | `AGENTS.md` | Primary target for this config |
| **Cursor** | ✅ Yes | `AGENTS.md` | Also reads `.cursorrules` and `.cursor/rules/` |
| **Claude Code** | ❌ No | `CLAUDE.md` | Copy/rename `AGENTS.md` → `CLAUDE.md` at repo root |
| **GitHub Copilot** | ❌ No | `.github/copilot-instructions.md` | Copy content into that file |
| **Gemini CLI** | ❌ No | `GEMINI.md` | Copy/rename `AGENTS.md` → `GEMINI.md` at repo root |
| **Codex** | ❌ No | `.codex/config.toml` | Adapt content into TOML `instructions` field |
| **Continue** | ❌ No | `~/.continue/config.yaml` | Add content to `systemMessage` in config |
| **Aider** | ❌ No | `.aider.conf.yml` | Add content to custom prompts via `--message` |

### Using this config with other agents

For agents that don't read `AGENTS.md` natively, copy the content to their expected file:

**Claude Code** — create `CLAUDE.md` at repo root:
```
cp AGENTS.md CLAUDE.md
```

**GitHub Copilot** — create `.github/copilot-instructions.md`:
```
cp AGENTS.md .github/copilot-instructions.md
```

**Gemini CLI** — create `GEMINI.md` at repo root:
```
cp AGENTS.md GEMINI.md
```

> ⚠️ These copies must be kept in sync manually when `AGENTS.md` is updated. See `CHANGE_CHECKLISTS.md` for the update protocol.

## Usage

### Modes (Workflows)

Invoke modes using slash commands:

- `/analyze` — Deep analysis mode, identify patterns and risks
- `/think` — Maximum reasoning effort with multiple approaches
- `/dry-run` — Plan only, no code changes
- `/enhance-prompt` — Transform prompts into actionable requests
- `/quick` — Execute directly with minimal reasoning
- `/loop` — Iterative improvements with approval gates
- `/turbo-loop` — Autonomous improvement loop
- `/fix-correctness` — Focus on correctness and concurrency only
- `/test` — Test-driven improvement loop
- `/tune-performance` — Performance optimization only
- `/stop` — Exit active loop and summarize
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
