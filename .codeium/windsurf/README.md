# Windsurf/Cascade Configuration

This directory contains a comprehensive, production-grade configuration for Windsurf/Cascade AI-assisted development.

---

## Overview

This configuration enforces rigorous engineering discipline through:
- **Global Rules** - Core principles prioritizing correctness, performance, and architectural continuity
- **Skills** - Specialized capabilities for development, quality, security, documentation, and operations
- **Workflows** - Execution modes with varying autonomy levels for analysis, improvement loops, and validation
- **Maintenance System** - Automated validation and change management

---

## Directory Structure

```
.codeium/windsurf/
├── memories/
│   └── global_rules.md          # Core engineering principles and rules
├── skills/                       # Specialized skills
│   ├── analyze-metrics/          # Runtime/process metrics visualization
│   ├── audit-security/           # Security auditing
│   ├── create-item/              # New module creation
│   ├── debug/                    # Bug diagnosis and fixing
│   ├── design-architecture/      # Design and governance
│   ├── develop-api/              # API endpoint creation
│   ├── maintain-consistency/     # Project-wide consistency validation
│   ├── manage-dependencies/      # Dependency lifecycle management
│   ├── manage-git/               # Git lifecycle management
│   ├── manage-secrets/           # Secrets management architecture
│   ├── optimize/                 # Performance optimization
│   ├── recover-design/           # Reverse engineering
│   ├── refactor/                 # Code restructuring
│   ├── visualize-project/        # Codebase structure visualization
│   ├── write-docs/               # Documentation
│   └── write-tests/              # Test writing
├── global_workflows/             # Execution workflows
│   ├── analyze.md                # Analysis without changes
│   ├── dry-run.md                # Planning without execution
│   ├── enhance-prompt.md         # Prompt enhancement
│   ├── improve-correctness.md    # Correctness-only loop
│   ├── loop.md                   # Standard improvement loop
│   ├── test.md                   # Red-green-refactor loop
│   ├── tune-performance.md       # Performance-only loop
│   ├── turbo-loop.md             # Autonomous loop
│   └── validate.md               # Project consistency validation
└── README.md                     # This file

Note: SKILLS_MAP.md, CHANGE_CHECKLISTS.md, and MAINTENANCE_GUIDE.md are located in docs/ (shared across tools).
```

---

## Quick Start

### 1. Validate Configuration

Run the `/validate` workflow:

```
/validate
```

This uses the maintain-consistency skill to comprehensively check:
- Directory structure and file existence
- YAML frontmatter completeness
- Cross-reference integrity
- Documentation consistency
- Naming conventions

### 2. Make Changes Safely

Before making any change:
1. Open `CHANGE_CHECKLISTS.md`
2. Find the appropriate checklist for your change type
3. Follow the checklist
4. Run `/validate` workflow after changes
5. Fix all reported issues before committing

### 3. Use Skills

**How Skills Work:**

Skills are invoked **automatically by Cascade** based on your request. You don't need slash commands - just describe what you need in natural language.

**Invocation Process:**
1. You write a request: "Fix the bug in login.js"
2. Cascade reads your request and matches it against skill triggers
3. Cascade selects the appropriate skill (e.g., `debug`)
4. The skill executes its specialized process

**Example Prompts → Skills:**
- "Fix this bug" → `debug` skill
- "Add tests for this function" → `write-tests` skill
- "Create a new API endpoint" → `develop-api` skill
- "Optimize this slow function" → `optimize` skill
- "Design this feature" → `design-architecture` skill
- "Check for security issues" → `audit-security` skill

**For More:**
- Complete skill catalog → `SKILLS_MAP.md`
- Detailed trigger conditions → `skills/*/SKILL.md`
- Usage patterns and combinations → `SKILLS_MAP.md` → "Skill Invocation Patterns"

**Note:** Skills are internal to Cascade. If you want to control *how* Cascade works (e.g., analysis mode, loop mode), use **workflows** (slash commands like `/analyze`, `/validate`).

### 4. Use Workflows

Workflows control execution mode:

**Analysis & Planning:**
- `/analyze` - Deep analysis without making changes
- `/dry-run` - Plan only, no code changes
- `/enhance-prompt` - Transform prompts into actionable requests

**Improvement Loops:**
- `/loop` - Standard improvement loop with approval gates
- `/turbo-loop` - Autonomous loop without approval
- `/improve-correctness` - Improve correctness and concurrency issues only
- `/test` - Test-driven red-green-refactor loop
- `/tune-performance` - Optimize performance only

**Validation:**
- `/validate` - Validate project consistency and integrity

### Skills vs Workflows: What's the Difference?

| Aspect | Skills | Workflows |
|--------|--------|-----------|
| **Invocation** | Automatic (Cascade decides) | Manual (you choose) |
| **Command** | Natural language request | Slash command (`/validate`) |
| **Purpose** | Execute specific tasks | Control execution mode |
| **Example** | "Fix this bug" triggers `debug` | `/turbo-loop` runs autonomous loop |

**Use Skills When:** You want Cascade to do something (fix, create, test, optimize)  
**Use Workflows When:** You want to control HOW Cascade works (analysis-only, loop mode, validation)

---

## Key Features

### Engineering Discipline

**Global Rules** enforce:
- Correctness > Performance > Elegance
- Lock-free, allocation-minimal hot paths
- No new dependencies without justification (≥500 LOC replacement)
- Architectural continuity (reuse existing abstractions)
- Correctness under concurrency is mandatory

### Comprehensive Skills

**Specialized skills** covering:
- Development: create-item, develop-api, refactor, optimize
- Quality: debug, write-tests, audit-security, maintain-consistency
- Security: manage-secrets, manage-dependencies
- Documentation: write-docs, design-architecture, recover-design
- Operations: manage-git

Each skill includes:
- Clear trigger conditions
- Step-by-step process
- Hard rules preventing mistakes
- Pre-submit checklists
- Language-specific tooling (10 languages)

### Multi-Language Support

**Languages covered:**
- JavaScript/TypeScript, Python, Go, Rust
- Java, C#/.NET, C/C++
- Swift, Kotlin, Dart/Flutter

**Tool categories:**
- Dependency management (manage-dependencies skill)
- Dependency analysis (design-architecture skill)
- Performance profiling (optimize skill)
- Security scanning (audit-security skill)
- Testing frameworks (write-tests skill)

### Change Management

**Automated validation** detects:
- Missing or broken skill references
- Inconsistent language coverage
- Orphaned files
- Cross-reference integrity issues

**Change checklists** for:
- Modifying skills or workflows
- Adding language support
- Updating global rules
- Removing components

---

## Maintenance

### Daily
- Run validation script after changes
- Follow appropriate checklist from `CHANGE_CHECKLISTS.md`

### Weekly
- Cross-reference audit
- Documentation review

### Monthly
- Comprehensive validation
- Language coverage audit
- Tool recommendation updates

### Quarterly
- Major review of all skills and workflows
- Update tool recommendations
- Documentation refresh

See `MAINTENANCE_GUIDE.md` for complete procedures.

---

## Core Philosophy

### Correctness First
- Fast wrong answers are rejected
- Tests must pass at every commit
- Concurrency correctness is mandatory
- No optimization without profiling

### Minimal Changes
- One logical change per commit
- Smallest possible fix for bugs
- No "while I'm here" changes
- Refactors are separate from features

### Architectural Continuity
- Reuse existing abstractions
- No parallel implementations
- No new abstraction without removing old one
- Understand before modifying

### Performance in Hot Paths
- Lock-free data structures preferred
- Minimize allocations
- Measure before and after
- Document non-obvious optimizations

---

## Documentation

| Document | Purpose |
|----------|---------|
| `global_rules.md` | Core engineering principles and rules |
| `SKILLS_MAP.md` | Skill relationships and invocation patterns |
| `CHANGE_CHECKLISTS.md` | Change impact checklists for consistency |
| `MAINTENANCE_GUIDE.md` | Maintenance protocols and schedules |
| `README.md` | This overview document |

---

## Validation

### Validation Workflow

Use the `/validate` workflow for comprehensive consistency checking:

```
/validate
```

**Validates:**
- Directory structure integrity
- Core file existence
- Skill YAML frontmatter (name, description)
- Workflow YAML frontmatter (description)
- Skill directory names match YAML names
- Cross-reference validity (skills, workflows, documentation)
- Language coverage consistency
- SKILLS_MAP.md accuracy
- Documentation counts match actual files

**Output:**
- Validation report with severity levels (P0 Critical, P1 Warnings)
- Specific remediation steps for each issue
- Prioritized action list

**When to Run:**
- After modifying any skill or workflow
- After updating documentation
- Before committing configuration changes
- As part of the CONFIGURATION CHANGE PROTOCOL (see global_rules.md)

### Manual Validation

See `MAINTENANCE_GUIDE.md` → "Validation Procedures" for manual checklist.

---

## Troubleshooting

### Configuration Issues

1. Run `/validate` workflow to identify problems
2. Check `CHANGE_CHECKLISTS.md` for guidance
3. Review `MAINTENANCE_GUIDE.md` → "Troubleshooting"
4. Fix errors in priority order (P0 Critical → P1 Warnings)

### Common Issues

**Missing skill reference:**
- Check if skill was renamed or removed
- Update all references to new name
- Run validation again

**Language coverage warning:**
- Add language to all relevant skills (design-architecture, optimize, audit-security, write-tests)
- Use consistent formatting
- Run validation again

**Circular dependency:**
- Review SKILLS_MAP.md dependency matrix
- Refactor to break cycle (use workflows to orchestrate)
- Update SKILLS_MAP.md

---

## Best Practices

### Do:
✓ Run `/validate` before committing changes  
✓ Use CHANGE_CHECKLISTS.md for every change  
✓ Follow CONFIGURATION CHANGE PROTOCOL (global_rules.md)  
✓ Keep language coverage consistent  
✓ Update SKILLS_MAP.md when patterns change  
✓ Keep skills atomic and focused  
✓ Use workflows to orchestrate multi-skill tasks  

### Don't:
✗ Skip `/validate` after changes  
✗ Commit without fixing validation issues  
✗ Add language to only one skill  
✗ Create circular dependencies  
✗ Let skills invoke other skills directly  
✗ Ignore validation warnings  
✗ Make changes without checking checklists  

---

## Version History

### Current Version
- Skills covering development, quality, security, documentation, and operations
- Workflows for analysis, improvement loops, and validation
- 10 languages supported
- Automated validation system
- Comprehensive change management
- Project-wide consistency enforcement

### Recent Improvements
- Removed Ruby and PHP support (now 10 languages)
- Added maintain-consistency skill for project-wide change management
- Added /validate workflow for consistency checking
- Added CHANGE MANAGEMENT PROTOCOL to global_rules.md
- Added SKILLS_MAP.md for relationship mapping
- Added concurrency testing guidance
- Added performance profiling tools (10 languages)
- Added security tool integration (10 languages)
- Added /validate workflow using maintain-consistency skill
- Added CONFIGURATION CHANGE PROTOCOL to global_rules.md
- Added SECRETS MANAGEMENT PROTOCOL to global_rules.md
- Added manage-secrets skill for secrets architecture and best practices
- Added manage-dependencies skill for full dependency lifecycle management
- Added change checklists and maintenance guide
- Replaced .windsurfrules with language-specific dependency tools
- Fixed enhance-prompt.md workflow template variable issue
- Removed cross-skill invocations (checklist references only)
- Renamed dry.md to dry-run.md
- Renamed perf.md to tune-performance.md
- Renamed skills for clarity: audit→audit-security, architect→design-architecture, create→create-item, git→manage-git
- Renamed workflows for clarity: tune→tune-performance, turbo→turbo-loop, enhance→enhance-prompt, correct→improve-correctness

---

## Support

For configuration issues:
1. Run `/validate` workflow to identify problems
2. Check `CHANGE_CHECKLISTS.md` for guidance
3. Review `MAINTENANCE_GUIDE.md` for procedures
4. Consult `SKILLS_MAP.md` for architecture understanding
5. Follow CONFIGURATION CHANGE PROTOCOL in global_rules.md

---

## License

This configuration is part of your personal Windsurf/Cascade setup.
