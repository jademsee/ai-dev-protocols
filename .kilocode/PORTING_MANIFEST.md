# Porting Manifest: Windsurf/Cascade → Kilo Code

This document maps the source Windsurf/Cascade configuration to the target Kilo Code configuration.

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

## Source Structure

```
.codeium/windsurf/
├── memories/
│   └── rules.md
├── skills/
│   └── [16 skill directories]/
│       └── SKILL.md
├── global_workflows/
│   └── [9 workflow files].md
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
│   └── rules.md              # Complete rules (same name as source)
├── workflows/
│   └── [9 workflow files].md
├── skills/
│   └── [16 skill directories]/
│       └── SKILL.md
├── PORTING_MANIFEST.md
└── README.md

rules.md (root level, complete rules)
docs/ (shared, not copied)
```

## Mapping Table

### Global Rules

| Source | Target | Notes |
|--------|--------|-------|
| `memories/rules.md` | `.kilocode/rules/rules.md` | Complete rules (same name both tools) |

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

### Workflows (9 total)

| Source (Workflow) | Target (Workflow) | Format Change |
|-------------------|-------------------|---------------|
| `global_workflows/diagnose.md` | `workflows/diagnose.md` | YAML frontmatter + MD content |
| `global_workflows/prescribe.md` | `workflows/prescribe.md` | YAML frontmatter + MD content |
| `global_workflows/enhance-prompt.md` | `workflows/enhance-prompt.md` | YAML frontmatter + MD content |
| `global_workflows/loop.md` | `workflows/loop.md` | YAML frontmatter + MD content |
| `global_workflows/turbo-loop.md` | `workflows/turbo-loop.md` | YAML frontmatter + MD content |
| `global_workflows/improve-correctness.md` | `workflows/improve-correctness.md` | YAML frontmatter + MD content |
| `global_workflows/test.md` | `workflows/test.md` | YAML frontmatter + MD content |
| `global_workflows/tune-performance.md` | `workflows/tune-performance.md` | YAML frontmatter + MD content |
| `global_workflows/validate.md` | `workflows/validate.md` | YAML frontmatter + MD content |

> **Format Note:** Kilo Code workflows use Markdown format with YAML frontmatter:
> - `description` (required in frontmatter) - Short summary shown in workflow selector
> - Content follows as Markdown steps

### Documentation

| Source | Target | Notes |
|--------|--------|-------|
| `README.md` | `README.md` | Rewritten for Kilo Code context |
| `SKILLS_MAP.md` | `SKILLS_MAP.md` | Direct copy |
| `CHANGE_CHECKLISTS.md` | `CHANGE_CHECKLISTS.md` | Direct copy |
| `MAINTENANCE_GUIDE.md` | `MAINTENANCE_GUIDE.md` | Direct copy |
| `AI_AGENT_FEATURE_MAPPING.md` | `docs/AI_AGENT_FEATURE_MAPPING.md` | Shared (cross-tool reference) |

## Terminology

Both Windsurf and Kilo Code now use the same terminology:

| Term | Used By |
|------|--------|
| Workflow | Both tools |
| `/workflow-name` | Both tools |
| `rules.md` | Both tools |
| `global_rules.md` | Deprecated (renamed to rules.md) |

> **Note:** The unified workflow format (Markdown + YAML frontmatter) works on both tools, eliminating the need for format conversion.

## Reference Updates

All internal references have been updated:

- `global_rules.md` → `rules.md` (same name both tools)
- Workflow format unified (no conversion needed)
- Skill invocation patterns preserved
- Cross-references to documentation preserved

## Feature Parity Verification

| Feature | Status |
|---------|--------|
| Global engineering rules | ✅ Ported to rules.md |
| Project-level rules | ✅ Created in rules/ |
| 16 specialized skills | ✅ Ported |
| 9 workflows | ✅ Unified format (direct copy) |
| Multi-language support (10 languages) | ✅ Preserved |
| Hard rules and pre-submit checklists | ✅ Preserved |
| Change management protocols | ✅ Preserved |
| Secrets management | ✅ Preserved |
| Improvement loop protocol | ✅ Preserved |
| SKILLS_MAP.md | ✅ Copied |
| CHANGE_CHECKLISTS.md | ✅ Copied |
| MAINTENANCE_GUIDE.md | ✅ Copied |

## Files Created

1. `.kilocode/rules/rules.md` — Complete rules (same name as source)
2. `.kilocode/workflows/diagnose.md`
3. `.kilocode/workflows/prescribe.md`
4. `.kilocode/workflows/enhance-prompt.md`
5. `.kilocode/workflows/loop.md`
6. `.kilocode/workflows/turbo-loop.md`
7. `.kilocode/workflows/improve-correctness.md`
8. `.kilocode/workflows/test.md`
9. `.kilocode/workflows/tune-performance.md`
10. `.kilocode/workflows/validate.md`
11. `.kilocode/skills/[16 skills]/SKILL.md` — Copied
12. `.kilocode/README.md`
13. `docs/SKILLS_MAP.md` — Shared (not copied)
14. `docs/CHANGE_CHECKLISTS.md` — Shared (not copied)
15. `docs/MAINTENANCE_GUIDE.md` — Shared (not copied)
16. `.kilocode/PORTING_MANIFEST.md` — This file

## Validation Checklist

- [x] All 16 skills ported
- [x] All 9 workflows created
- [x] rules.md created with complete rules
- [x] Documentation copied
- [x] README updated for Kilo Code
- [x] Porting manifest created
- [x] Internal references updated
