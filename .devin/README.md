# Devin Configuration

Devin CLI port of the workflow layer. Devin has no separate workflow
concept — its skills are slash-command invocable — so Windsurf
workflows are converted to Devin skills.

## Directory Structure

```
.devin/
├── skills/                      # Workflow ports (slash commands)
│   ├── diagnose/SKILL.md
│   ├── enhance-prompt/SKILL.md
│   ├── loop/SKILL.md
│   ├── prescribe/SKILL.md
│   ├── test/SKILL.md
│   └── validate/SKILL.md
└── README.md                    # This file
```

## Source Mapping

| Source (Windsurf workflow) | Devin skill | Conversion |
|----------------------------|-------------|------------|
| `global_workflows/loop.md` | `skills/loop` | Consolidated: turbo-loop, improve-correctness, tune-performance absorbed as arguments |
| `global_workflows/test.md` | `skills/test` | Content unchanged; adds `triggers: [user]` |
| `global_workflows/validate.md` | `skills/validate` | Adds `allowed-tools` (read, grep, glob, exec) |
| `global_workflows/diagnose.md` | `skills/diagnose` | Adds `allowed-tools` (read, grep, glob) — read-only enforced |
| `global_workflows/prescribe.md` | `skills/prescribe` | Adds `allowed-tools` (read, grep, glob) — read-only enforced |
| `global_workflows/enhance-prompt.md` | `skills/enhance-prompt` | Content unchanged; adds `triggers: [user]` |

Capability skills (debug, optimize, write-tests, ...) are **not** ported
here: Devin reads them from the deployed `~/.codeium/windsurf/skills/`
directory directly, so they stay single-source.

Rules references are adapted: "rules.md" becomes "the rules (AGENTS.md)"
because Devin loads the rules via AGENTS.md, not memories/rules.md.

## Deployment

Devin reads `.devin/skills/` at project level when working in this
repository. For global (all projects) use, copy to the Devin global
skills directory:

```
# Windows
cp -r .devin/skills/* "$APPDATA/devin/skills/"
```

## Update Protocol

When a workflow in `.codeium/windsurf/global_workflows/` changes:

1. Update the corresponding skill here
2. Update the deployment copy in `%APPDATA%\devin\skills\`
3. Follow `docs/CHANGE_CHECKLISTS.md` → Checklist 2 (Modifying a Workflow)
