# Changelog

All notable changes to the AI Development Protocols project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Task ledger standard** (`docs/TASK_LEDGER.md`) - Canonical format for
  plan-driven task tracking: sparse table (Task/Status/Note/Evidence),
  closed status vocabulary (in-progress/blocked/done), write-ahead
  update semantics tied to rules.md On Recovery / [IF autonomous]
- **verify-task-ledger.sh** (`scripts/`) - Machine-checks ledger validity:
  header shape, status vocabulary, evidence on done rows, notes on open
  rows, duplicate task IDs; exits 1 on ledger drift
- **analyze-metrics skill** - New Atomic skill for runtime/process metrics visualization
  - Performance metrics (latency, throughput, memory, GC, error rates)
  - CI/CD health (pipeline success, build time, flaky tests, rollbacks)
  - Dev velocity (lead time, deployment frequency, cycle time, PR metrics)
  - User analytics (funnels, feature adoption, DAU/WAU, error by segment)
  - Privacy-first approach: aggregated team-level data only
- **7 visualization scripts** in scripts/ directory
  - `generate-dependency-graph.sh` - Multi-language dependency graph (JS, Go, Rust, Python, Java)
  - `generate-ownership-heatmap.sh` - Git history ownership analysis with orphan detection
  - `check-bus-factor.sh` - Bus factor risk detection with configurable threshold
  - `generate-coupling-heatmap.sh` - Module coupling metrics (afferent, efferent, instability)
  - `generate-layer-compliance.sh` - Architecture layer violation detection
  - `create-onboarding-guide.sh` - Combined onboarding document with all visualizations
  - `analyze-knowledge-transfer.sh` - Offboarding knowledge transfer analysis
- Cross-reference between visualize-project and analyze-metrics skills
- Event-driven automation workflows for visualization generation (PR, merge, team events)

### Changed
- **Workflows** - Consolidated turbo-loop, improve-correctness, and
  tune-performance into `/loop` arguments (`correctness`, `performance`,
  `turbo`); 9 → 6 workflows, existing invocations unaffected
- **rules.md** - Consolidated appended content into the tiered core (519 → 279 lines)
  - Removed 14-section "GLOBAL AGENT RULES" that duplicated Tiers 1-2 nearly verbatim
  - Removed unfilled template placeholders (`<e.g., Next.js 15...>`) and dangling headings
  - Removed broken references to non-existent files (task-ledger.md, verify_task_ledger.py)
  - Removed tool-specific content (DEVIN_LOG.md scratchpad, GLM 5.3 mentions) from the
    cross-tool standard
  - Resolved autonomy contradiction by adding profile flags: `Mode: brownfield | greenfield`
    and `Execution: autonomous | gated`
  - Integrated the non-duplicative ideas: preserve-existing-intent before deletion
    (Architecture), targeted reading of large files (Minimalism), objective-over-wording
    and plan/ledger compliance (On Task Start), On Failure persistence, On Completion
    scope discipline and evidence-based ledger updates, [IF greenfield] and [IF gated]
    conditional rules
  - Added crash-safety for autonomous execution: On Recovery reconciliation protocol
    (Tier 2) and [IF autonomous] checkpoint/write-ahead/break discipline (Tier 3)
  - Synced AGENTS.md and .kilocode/rules/rules.md
- **rules.md** - Comprehensive optimization (230 → 200 lines)
  - Added Honesty invariants: no fabrication, no false completion claims, state uncertainty
  - Added completeness requirements: full end-to-end scope, no in-scope stubs, report reductions
  - Added unset-profile defaults (single-threaded, standard) to close conditional-rule loophole
  - Fixed contradictions: `<50 LOC` rejection vs Tier 1 thresholds; `[IF async]` vs profile values
  - Replaced undefined "dynamic" with "all other types"; removed unverifiable "no hidden allocations"
  - Consolidated 3 redundant don't-guess rules and 3 overlapping minimalism lists
  - Synced AGENTS.md, .kilocode/rules/rules.md, and manage-dependencies/manage-git skills
- **manage-git / manage-dependencies skills** - Aligned with rules.md AUTHORSHIP and Tier 1 dependency thresholds
- **visualize-project skill** - Refactored to focus exclusively on codebase understanding
  - Retained 4 core visualizations: dependency graph, code ownership, module coupling, layer compliance
  - Added Mermaid output format with styling for violations and risks
  - Added comprehensive event-driven trigger system (no scheduled jobs needed)
  - Removed performance, CI/CD, dev velocity, and user analytics (moved to analyze-metrics)
- Updated skill count from 14 to 16 across all documentation
- Updated Atomic Skills category from 8 to 10 skills
- Updated SKILLS_MAP.md with both skills in dependency matrix and selection guide
- Updated PORTING_MANIFEST.md to reflect 16 skills

### Added
- **manage-dependencies skill** - New Atomic skill for full dependency lifecycle management
  - Dependency adoption decision framework extending global rules threshold
  - Lock file strategy for all 10 supported languages
  - Version pinning strategy with tradeoff analysis
  - Automated update strategies (Renovate, Dependabot) with recommended cadence
  - License compliance tooling per ecosystem
  - Language-specific tools for all 10 languages (vulnerability scanning, dependency trees, unused deps)
  - Performance and build optimization (CI caching, monorepo patterns, tree-shaking)
  - Operational concerns (reproducible builds, breaking changes, registry fallbacks)
  - Anti-patterns and red flags reference
- **manage-secrets skill** - New Atomic skill for secrets management architecture and best practices
  - 3 architecture patterns: Development-First, Enterprise Multi-Cloud, Single-Cloud Native
  - Tool decision matrix comparing Varlock, Doppler, HashiCorp Vault, and cloud-native solutions
  - Implementation checklists for Varlock setup, cloud vaults, CI/CD integration, and migration
  - Secret scanning tools (pre-commit, repository, git history)
  - Rotation best practices (automatic and manual workflows)
  - Access control patterns following least privilege principle
  - Compliance guidance for SOC2, HIPAA, PCI-DSS
  - Common pitfalls and solutions
- **SECRETS MANAGEMENT PROTOCOL** in rules.md
  - 8 core rules for handling secrets, credentials, and sensitive configuration
  - 3 hard stops to prevent credential exposure
- **Pattern 8: Secrets Management** invocation pattern in SKILLS_MAP.md
- **Pattern 9: Dependency Management** invocation pattern in SKILLS_MAP.md
- Cross-reference between manage-secrets and audit-security skills
- Cross-reference between manage-dependencies and audit-security/design-architecture skills

### Changed
- Updated skill count from 13 to 14 across all documentation
- Updated Atomic Skills category from 7 to 8 skills
- Updated AI_AGENT_FEATURE_MAPPING.md with new skill counts and categories
- Enhanced audit-security skill with Related Skills section

## [1.0.0] - 2026-03-16

### Added
- **13 specialized skills** organized into Atomic, Composite, and Orchestration categories
  - Atomic: debug, write-tests, write-docs, refactor, optimize, maintain-consistency, manage-secrets
  - Composite: develop-api, create-item, manage-git
  - Orchestration: design-architecture, recover-design, audit-security
- **9 custom workflows (Analysis, Loops, Validation)**
  - Analysis: analyze, dry-run, enhance-prompt
  - Loops: loop, turbo-loop, improve-correctness, test, tune-performance
  - Validation: validate
- **Global rules system** (memories/rules.md)
  - PROJECT PROFILE for context-dependent rules
  - SESSION START PROTOCOL
  - CHANGE MANAGEMENT PROTOCOL
  - CONFIGURATION CHANGE PROTOCOL
  - SECRETS MANAGEMENT PROTOCOL
  - PROCESS REQUIREMENT
  - PROJECT LAW (correctness > performance > elegance)
  - IMPROVEMENT LOOP PROTOCOL
- **Comprehensive documentation**
  - SKILLS_MAP.md - Skill relationships and invocation patterns
  - CHANGE_CHECKLISTS.md - Change impact checklists
  - MAINTENANCE_GUIDE.md - Maintenance protocols and schedules
  - AI_AGENT_FEATURE_MAPPING.md - Cross-agent compatibility mapping
- **Multi-language support** (10 languages)
  - JavaScript/TypeScript, Python, Go, Rust
  - Java, C#/.NET, C/C++
  - Swift, Kotlin, Dart/Flutter
- **Automated validation system**
  - /validate workflow using maintain-consistency skill
  - Directory structure validation
  - YAML frontmatter validation
  - Cross-reference integrity checking
  - Language coverage consistency
  - Documentation count verification

### Changed
- Renamed skills for clarity:
  - audit → audit-security
  - architect → design-architecture
  - create → create-item
  - git → manage-git
- Renamed workflows for clarity:
  - tune → tune-performance
  - turbo → turbo-loop
  - enhance → enhance-prompt
  - correct → improve-correctness
  - dry → dry-run
- Replaced .windsurfrules with language-specific dependency analysis tools
- Removed cross-skill invocations (skills now use checklist references only)

### Removed
- Ruby and PHP language support (focused on 10 core languages)

### Fixed
- enhance-prompt.md workflow template variable issue

---

## Version History Summary

| Version | Skills | Workflows | Languages | Key Features |
|---------|--------|-----------|-----------|--------------|
| 1.0.0 | 13 | 12 | 10 | Full skill system, validation, change management |

---

## Migration Guide

### From Pre-1.0 Versions

If you're upgrading from an earlier version:

1. **Skill Renames**: Update any custom references to renamed skills
   - `audit` → `audit-security`
   - `architect` → `design-architecture`
   - `create` → `create-item`
   - `git` → `manage-git`

2. **Workflow Renames**: Update any documentation or scripts
   - `/tune` → `/tune-performance`
   - `/turbo` → `/turbo-loop`
   - `/enhance` → `/enhance-prompt`
   - `/correct` → `/improve-correctness`
   - `/dry` → `/prescribe`

3. **Language Support**: If using Ruby or PHP, migrate to supported languages or add custom tooling

4. **Validation**: Run `/validate` workflow to ensure consistency

---

## Contributing

When adding changes to this project:

1. Follow CHANGE_CHECKLISTS.md for the appropriate change type
2. Update this CHANGELOG.md under [Unreleased]
3. Run `/validate` workflow before committing
4. Follow the CONFIGURATION CHANGE PROTOCOL in rules.md

---

## Links

- [Project README](README.md)
- [Configuration Guide](.codeium/windsurf/README.md)
- [Skills Map](docs/SKILLS_MAP.md)
- [Change Checklists](docs/CHANGE_CHECKLISTS.md)
- [Maintenance Guide](docs/MAINTENANCE_GUIDE.md)
- [Agent Feature Mapping](docs/AI_AGENT_FEATURE_MAPPING.md)
