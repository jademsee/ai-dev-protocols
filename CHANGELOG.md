# Changelog

All notable changes to the AI Development Protocols project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **manage-secrets skill** - New Atomic skill for secrets management architecture and best practices
  - 3 architecture patterns: Development-First, Enterprise Multi-Cloud, Single-Cloud Native
  - Tool decision matrix comparing Varlock, Doppler, HashiCorp Vault, and cloud-native solutions
  - Implementation checklists for Varlock setup, cloud vaults, CI/CD integration, and migration
  - Secret scanning tools (pre-commit, repository, git history)
  - Rotation best practices (automatic and manual workflows)
  - Access control patterns following least privilege principle
  - Compliance guidance for SOC2, HIPAA, PCI-DSS
  - Common pitfalls and solutions
- **SECRETS MANAGEMENT PROTOCOL** in global_rules.md
  - 8 core rules for handling secrets, credentials, and sensitive configuration
  - 3 hard stops to prevent credential exposure
- **Pattern 8: Secrets Management** invocation pattern in SKILLS_MAP.md
- Cross-reference between manage-secrets and audit-security skills

### Changed
- Updated skill count from 12 to 13 across all documentation
- Updated Atomic Skills category from 6 to 7 skills
- Updated AI_AGENT_FEATURE_MAPPING.md with new skill counts and categories
- Enhanced audit-security skill with Related Skills section

## [1.0.0] - 2026-03-16

### Added
- **13 specialized skills** organized into Atomic, Composite, and Orchestration categories
  - Atomic: debug, write-tests, write-docs, refactor, optimize, maintain-consistency, manage-secrets
  - Composite: develop-api, create-item, manage-git
  - Orchestration: design-architecture, recover-design, audit-security
- **12 custom workflows** for execution control
  - Analysis: analyze, think, dry-run, enhance-prompt
  - Execution: quick
  - Loops: loop, turbo-loop, fix-correctness, test, tune-performance
  - Control: stop, validate
- **Global rules system** (memories/global_rules.md)
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
  - correct → fix-correctness
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
   - `/correct` → `/fix-correctness`
   - `/dry` → `/dry-run`

3. **Language Support**: If using Ruby or PHP, migrate to supported languages or add custom tooling

4. **Validation**: Run `/validate` workflow to ensure consistency

---

## Contributing

When adding changes to this project:

1. Follow CHANGE_CHECKLISTS.md for the appropriate change type
2. Update this CHANGELOG.md under [Unreleased]
3. Run `/validate` workflow before committing
4. Follow the CONFIGURATION CHANGE PROTOCOL in global_rules.md

---

## Links

- [Project README](README.md)
- [Configuration Guide](.codeium/windsurf/README.md)
- [Skills Map](.codeium/windsurf/SKILLS_MAP.md)
- [Change Checklists](.codeium/windsurf/CHANGE_CHECKLISTS.md)
- [Maintenance Guide](.codeium/windsurf/MAINTENANCE_GUIDE.md)
