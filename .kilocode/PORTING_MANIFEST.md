# Porting Manifest: Windsurf/Cascade → Kilo Code

This document maps the source Windsurf/Cascade configuration to the target Kilo Code configuration.

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

## Source Structure

```
.codeium/windsurf/
├── memories/
│   └── global_rules.md
├── skills/
│   └── [16 skill directories]/
│       └── SKILL.md
├── global_workflows/
│   └── [12 workflow files].md
└── README.md

docs/ (shared across all tools)
├── SKILLS_MAP.md
├── CHANGE_CHECKLISTS.md
├── MAINTENANCE_GUIDE.md
└── AI_AGENT_FEATURE_MAPPING.md
```

## Target Structure

```
.kilocode/
├── rules/
│   └── master-rules.md          # Complete rules (single source of truth)
├── modes/
│   └── [9 mode files].yaml
├── skills/
│   └── [16 skill directories]/
│       └── SKILL.md
├── PORTING_MANIFEST.md
└── README.md

AGENTS.md (root level, points to .kilocode/rules/master-rules.md)
docs/ (shared, not copied)
```

## Mapping Table

### Global Rules

| Source | Target | Notes |
|--------|--------|-------|
| `memories/global_rules.md` | `.kilocode/rules/master-rules.md` | Complete rules (single source of truth) |
| `memories/global_rules.md` | `AGENTS.md` | Cross-tool discovery pointer |

### Skills (16 total)

| Source | Target | Format Change |
|--------|--------|---------------|
| `skills/audit-security/SKILL.md` | `skills/audit-security/SKILL.md` | None (YAML+MD compatible) |
| `skills/create-item/SKILL.md` | `skills/create-item/SKILL.md` | None (YAML+MD compatible) |
| `skills/debug/SKILL.md` | `skills/debug/SKILL.md` | None (YAML+MD compatible) |
| `skills/design-architecture/SKILL.md` | `skills/design-architecture/SKILL.md` | None (YAML+MD compatible) |
| `skills/develop-api/SKILL.md` | `skills/develop-api/SKILL.md` | None (YAML+MD compatible) |
| `skills/maintain-consistency/SKILL.md` | `skills/maintain-consistency/SKILL.md` | None (YAML+MD compatible) |
| `skills/manage-dependencies/SKILL.md` | `skills/manage-dependencies/SKILL.md` | None (YAML+MD compatible) |
| `skills/manage-git/SKILL.md` | `skills/manage-git/SKILL.md` | None (YAML+MD compatible) |
| `skills/manage-secrets/SKILL.md` | `skills/manage-secrets/SKILL.md` | None (YAML+MD compatible) |
| `skills/optimize/SKILL.md` | `skills/optimize/SKILL.md` | None (YAML+MD compatible) |
| `skills/recover-design/SKILL.md` | `skills/recover-design/SKILL.md` | None (YAML+MD compatible) |
| `skills/refactor/SKILL.md` | `skills/refactor/SKILL.md` | None (YAML+MD compatible) |
| `skills/write-docs/SKILL.md` | `skills/write-docs/SKILL.md` | None (YAML+MD compatible) |
| `skills/write-tests/SKILL.md` | `skills/write-tests/SKILL.md` | None (YAML+MD compatible) |
| `skills/visualize-project/SKILL.md` | `skills/visualize-project/SKILL.md` | None (YAML+MD compatible) |
| `skills/analyze-metrics/SKILL.md` | `skills/analyze-metrics/SKILL.md` | None (YAML+MD compatible) |

### Workflows → Modes (9 total)

| Source (Workflow) | Target (Mode) | Format Change |
|-------------------|---------------|---------------|
| `global_workflows/analyze.md` | `modes/analyze.yaml` | MD → YAML with Kilo Code schema (`slug`, `name`, `description`, `roleDefinition`, `groups`, `whenToUse`, `customInstructions`) |
| `global_workflows/dry-run.md` | `modes/dry-run.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/enhance-prompt.md` | `modes/enhance-prompt.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/loop.md` | `modes/loop.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/turbo-loop.md` | `modes/turbo-loop.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/improve-correctness.md` | `modes/improve-correctness.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/test.md` | `modes/test.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/tune-performance.md` | `modes/tune-performance.yaml` | MD → YAML with Kilo Code schema |
| `global_workflows/validate.md` | `modes/validate.yaml` | MD → YAML with Kilo Code schema |

> **Schema Note:** Kilo Code modes require a specific YAML schema different from Windsurf workflows:
> - `slug` (required) - Unique identifier matching pattern `/^[a-zA-Z0-9-]+$/`
> - `name` (required) - Display name shown in UI
> - `description` (required) - Short summary in mode selector
> - `roleDefinition` (required) - Role/personality definition for system prompt
> - `groups` (required) - Tool access groups: `read`, `edit`, `browser`, `command`, `mcp`
> - `whenToUse` (optional) - Guidance for automated mode selection
> - `customInstructions` (optional) - Detailed instructions
>
> The original porting used incorrect fields (`instructions`, `tools`) which caused modes to not load.

### Documentation

| Source | Target | Notes |
|--------|--------|-------|
| `README.md` | `README.md` | Rewritten for Kilo Code context |
| `SKILLS_MAP.md` | `SKILLS_MAP.md` | Direct copy |
| `CHANGE_CHECKLISTS.md` | `CHANGE_CHECKLISTS.md` | Direct copy |
| `MAINTENANCE_GUIDE.md` | `MAINTENANCE_GUIDE.md` | Direct copy |
| `AI_AGENT_FEATURE_MAPPING.md` | `docs/AI_AGENT_FEATURE_MAPPING.md` | Shared (cross-tool reference) |

## Terminology Changes

| Windsurf/Cascade Term | Kilo Code Term |
|-----------------------|---------------|
| Workflow | Mode |
| `/workflow-name` | `/mode-name` |
| `global_rules.md` | `AGENTS.md` |
| Windsurf | Kilo Code |

## Reference Updates

All internal references have been updated:

- `global_rules.md` → `AGENTS.md`
- Workflow names preserved as mode names
- Skill invocation patterns preserved
- Cross-references to documentation preserved

## Feature Parity Verification

| Feature | Status |
|---------|--------|
| Global engineering rules | ✅ Ported to AGENTS.md |
| Project-level rules | ✅ Created in rules/ |
| 16 specialized skills | ✅ Ported |
| 9 workflows/modes | ✅ Converted to YAML |
| Multi-language support (10 languages) | ✅ Preserved |
| Hard rules and pre-submit checklists | ✅ Preserved |
| Change management protocols | ✅ Preserved |
| Secrets management | ✅ Preserved |
| Improvement loop protocol | ✅ Preserved |
| SKILLS_MAP.md | ✅ Copied |
| CHANGE_CHECKLISTS.md | ✅ Copied |
| MAINTENANCE_GUIDE.md | ✅ Copied |

## Files Created

1. `AGENTS.md` — Root-level cross-tool discovery pointer
2. `.kilocode/rules/master-rules.md` — Complete rules (single source of truth)
3. `.kilocode/modes/analyze.yaml`
4. `.kilocode/modes/dry-run.yaml`
5. `.kilocode/modes/enhance-prompt.yaml`
6. `.kilocode/modes/loop.yaml`
7. `.kilocode/modes/turbo-loop.yaml`
8. `.kilocode/modes/improve-correctness.yaml`
9. `.kilocode/modes/test.yaml`
10. `.kilocode/modes/tune-performance.yaml`
11. `.kilocode/modes/validate.yaml`
12. `.kilocode/skills/[16 skills]/SKILL.md` — Copied
13. `.kilocode/README.md`
14. `docs/SKILLS_MAP.md` — Shared (not copied)
15. `docs/CHANGE_CHECKLISTS.md` — Shared (not copied)
16. `docs/MAINTENANCE_GUIDE.md` — Shared (not copied)
17. `.kilocode/PORTING_MANIFEST.md` — This file

## Validation Checklist

- [x] All 16 skills ported
- [x] All 9 modes created
- [x] AGENTS.md created as discovery pointer
- [x] master-rules.md created with complete rules
- [x] Documentation copied
- [x] README updated for Kilo Code
- [x] Porting manifest created
- [x] Internal references updated
