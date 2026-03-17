# Kilo Code Configuration

This directory contains the Kilo Code AI coding assistant configuration, ported from Windsurf/Cascade.

## Directory Structure

```
.kilocode/
├── rules/                    # Project-level rules
│   └── master-rules.md       # Complete rules (single source of truth)
├── modes/                    # Custom modes (workflows)
│   ├── analyze.yaml
│   ├── dry-run.yaml
│   ├── enhance-prompt.yaml
│   ├── loop.yaml
│   ├── turbo-loop.yaml
│   ├── improve-correctness.yaml
│   ├── test.yaml
│   ├── tune-performance.yaml
│   └── validate.yaml
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

## AGENTS.md — Global Rules File

`AGENTS.md` lives at the **repository root** (`/AGENTS.md`) and serves as a cross-tool discovery pointer. The actual rules content is in [`.kilocode/rules/master-rules.md`](rules/master-rules.md).

### Location

```
<repo-root>/
├── AGENTS.md              ← Cross-tool discovery pointer
└── .kilocode/
    └── rules/
        └── master-rules.md  ← Actual rules content
```

It must be at the root so all AI tools can discover it by walking up from the working directory.

### Which agents read AGENTS.md natively

| Agent | Reads AGENTS.md? | Native config file | Notes |
|-------|------------------|--------------------|-------|
| **Kilo Code** | ✅ Yes | `AGENTS.md` | Primary target for this config |
| **Cursor** | ✅ Yes | `AGENTS.md` | Also reads `.cursorrules` and `.cursor/rules/` |
| **Claude Code** | ❌ No | `CLAUDE.md` | Copy content from `.kilocode/rules/master-rules.md` |
| **GitHub Copilot** | ❌ No | `.github/copilot-instructions.md` | Copy content from `.kilocode/rules/master-rules.md` |
| **Gemini CLI** | ❌ No | `GEMINI.md` | Copy content from `.kilocode/rules/master-rules.md` |
| **Codex** | ❌ No | `.codex/config.toml` | Adapt content into TOML `instructions` field |
| **Continue** | ❌ No | `~/.continue/config.yaml` | Add content to `systemMessage` in config |
| **Aider** | ❌ No | `.aider.conf.yml` | Add content to custom prompts via `--message` |

### Using this config with other agents

For agents that don't read `AGENTS.md` natively, copy the content from `.kilocode/rules/master-rules.md` to their expected file:

**Claude Code** — create `CLAUDE.md` at repo root:
```
cp .kilocode/rules/master-rules.md CLAUDE.md
```

**GitHub Copilot** — create `.github/copilot-instructions.md`:
```
cp .kilocode/rules/master-rules.md .github/copilot-instructions.md
```

**Gemini CLI** — create `GEMINI.md` at repo root:
```
cp .kilocode/rules/master-rules.md GEMINI.md
```

> ⚠️ These copies must be kept in sync manually when `.kilocode/rules/master-rules.md` is updated. See `CHANGE_CHECKLISTS.md` for the update protocol.

## Usage

### Modes (Workflows)

Invoke modes using slash commands:

- `/analyze` — Deep analysis mode, identify patterns and risks
- `/dry-run` — Plan only, no code changes
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
