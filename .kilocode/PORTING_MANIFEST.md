# Porting Manifest: Windsurf/Cascade → Kilo Code

This document maps the source Windsurf/Cascade configuration to the target Kilo Code configuration.

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

## Source Structure

```
.codeium/windsurf/
├── memories/
│   └── global_rules.md
├── skills/
│   └── [14 skill directories]/
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
│   ├── engineering-principles.md
│   ├── secrets-management.md
│   └── improvement-loop.md
├── modes/
│   └── [12 mode files].yaml
├── skills/
│   └── [14 skill directories]/
│       └── SKILL.md
├── PORTING_MANIFEST.md
└── README.md

AGENTS.md (root level)
docs/ (shared, not copied)
```

## Mapping Table

### Global Rules

| Source | Target | Notes |
|--------|--------|-------|
| `memories/global_rules.md` | `AGENTS.md` | Cross-tool standard format |
| `memories/global_rules.md` (Engineering Principles) | `.kilocode/rules/engineering-principles.md` | Project-level rule file |
| `memories/global_rules.md` (Secrets Management) | `.kilocode/rules/secrets-management.md` | Project-level rule file |
| `memories/global_rules.md` (Improvement Loop) | `.kilocode/rules/improvement-loop.md` | Project-level rule file |

### Skills (14 total)

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

### Workflows → Modes (12 total)

| Source (Workflow) | Target (Mode) | Format Change |
|-------------------|---------------|---------------|
| `global_workflows/analyze.md` | `modes/analyze.yaml` | MD → YAML with `name`, `description`, `instructions`, `tools` |
| `global_workflows/think.md` | `modes/think.yaml` | MD → YAML |
| `global_workflows/dry-run.md` | `modes/dry-run.yaml` | MD → YAML |
| `global_workflows/enhance-prompt.md` | `modes/enhance-prompt.yaml` | MD → YAML |
| `global_workflows/quick.md` | `modes/quick.yaml` | MD → YAML |
| `global_workflows/loop.md` | `modes/loop.yaml` | MD → YAML |
| `global_workflows/turbo-loop.md` | `modes/turbo-loop.yaml` | MD → YAML |
| `global_workflows/fix-correctness.md` | `modes/fix-correctness.yaml` | MD → YAML |
| `global_workflows/test.md` | `modes/test.yaml` | MD → YAML |
| `global_workflows/tune-performance.md` | `modes/tune-performance.yaml` | MD → YAML |
| `global_workflows/stop.md` | `modes/stop.yaml` | MD → YAML |
| `global_workflows/validate.md` | `modes/validate.yaml` | MD → YAML |

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
| 14 specialized skills | ✅ Ported |
| 12 workflows/modes | ✅ Converted to YAML |
| Multi-language support (10 languages) | ✅ Preserved |
| Hard rules and pre-submit checklists | ✅ Preserved |
| Change management protocols | ✅ Preserved |
| Secrets management | ✅ Preserved |
| Improvement loop protocol | ✅ Preserved |
| SKILLS_MAP.md | ✅ Copied |
| CHANGE_CHECKLISTS.md | ✅ Copied |
| MAINTENANCE_GUIDE.md | ✅ Copied |

## Files Created

1. `AGENTS.md` — Root-level cross-tool configuration
2. `.kilocode/rules/engineering-principles.md`
3. `.kilocode/rules/secrets-management.md`
4. `.kilocode/rules/improvement-loop.md`
5. `.kilocode/modes/analyze.yaml`
6. `.kilocode/modes/think.yaml`
7. `.kilocode/modes/dry-run.yaml`
8. `.kilocode/modes/enhance-prompt.yaml`
9. `.kilocode/modes/quick.yaml`
10. `.kilocode/modes/loop.yaml`
11. `.kilocode/modes/turbo-loop.yaml`
12. `.kilocode/modes/fix-correctness.yaml`
13. `.kilocode/modes/test.yaml`
14. `.kilocode/modes/tune-performance.yaml`
15. `.kilocode/modes/stop.yaml`
16. `.kilocode/modes/validate.yaml`
17. `.kilocode/skills/[14 skills]/SKILL.md` — Copied
18. `.kilocode/README.md`
19. `docs/SKILLS_MAP.md` — Shared (not copied)
20. `docs/CHANGE_CHECKLISTS.md` — Shared (not copied)
21. `docs/MAINTENANCE_GUIDE.md` — Shared (not copied)
22. `.kilocode/PORTING_MANIFEST.md` — This file

## Validation Checklist

- [ ] All 14 skills ported
- [ ] All 12 modes created
- [ ] AGENTS.md created with full content
- [ ] Rules directory populated
- [ ] Documentation copied
- [ ] README updated for Kilo Code
- [ ] Porting manifest created
- [ ] Internal references updated
