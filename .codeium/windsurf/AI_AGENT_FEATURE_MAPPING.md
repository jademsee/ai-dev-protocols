# AI Coding Agent Feature Mapping

This document maps Windsurf/Cascade configuration features to equivalent capabilities in other AI coding agents, serving as a reference for feature parity analysis and migration guidance.

---

## Overview

**Purpose:**
- Identify where to configure equivalent features in other AI coding agents
- Understand which agents support similar customization capabilities
- Identify gaps and limitations across platforms

**Scope:**
- **3 Feature Categories**: Global Rules & Protocols, Skills System, Workflows System
- **10 AI Coding Agents**: Windsurf/Cascade (reference), GitHub Copilot, Cursor, Continue, Kilo Code, Antigravity, Claude Code, Codex, Gemini CLI, Aider

**Note:** This is a mapping-only document showing configuration file locations and feature names, not full implementation guides.

**Last Verified:** 2025-01-15

> ⚠️ **AI coding agents evolve rapidly.** Verify capabilities against current documentation before relying on this mapping.

---

## Table of Contents

1. [Methodology](#methodology)
2. [Quick Reference: Customization Capabilities](#quick-reference-customization-capabilities)
   - [Quick Migration Guide](#quick-migration-guide)
3. [Global Rules & Protocols Mapping](#global-rules--protocols-mapping)
4. [Skills System Mapping](#skills-system-mapping)
5. [Workflows System Mapping](#workflows-system-mapping)
6. [Gap Analysis](#gap-analysis)
7. [Key Findings](#key-findings)
8. [Recommendations](#recommendations)
9. [Agent-Specific Notes](#agent-specific-notes)
10. [Conclusion](#conclusion)

---

## Methodology

- Capabilities were assessed from official documentation and direct testing where possible
- **"Custom"** means markdown/YAML context files the AI reads as instructions — achievable on any agent through prompt engineering
- **"Built-in"** means platform-native features with dedicated UI or enforcement
- Items marked **[UNVERIFIED]** could not be confirmed against official documentation

---

## Quick Reference: Customization Capabilities

| Agent | Global Rules | Skills/Modes | Workflows | Config Location | Custom Options |
|-------|-------------|--------------|-----------|-----------------|----------------|
| **Windsurf/Cascade** | ✅ Strong (Custom) | ✅ Strong (Custom) | ✅ Strong (Custom + 1 Built-in) | `memories/global_rules.md`, `skills/`, `global_workflows/` | Custom: 12 workflows + Built-in: `/review` |
| **GitHub Copilot** | ✅ Strong | ⚠️ Limited | ⚠️ Limited | `.github/copilot-instructions.md` | Markdown instructions, Copilot Chat modes (explain, fix, test), Copilot Workspace |
| **Cursor** | ✅ Strong | ⚠️ Limited | ⚠️ Limited | `.cursorrules`, `.cursor/rules/`, `AGENTS.md` | Markdown rules, file-specific, AGENTS.md support |
| **Continue** | ✅ Strong | ✅ Strong | ⚠️ Partial | `~/.continue/config.yaml` | Custom slash commands, context providers, MCP |
| **Kilo Code** | ✅ Strong | ✅ Strong | ✅ Strong | `AGENTS.md`, `.kilocode/rules/`, `.kilocode/modes/`, `.kilocode/skills/` | Custom rules, YAML modes, skills system, custom tools, subagents |
| **Antigravity** [UNVERIFIED] | ⚠️ Unverified | ⚠️ Unverified | ⚠️ Unverified | `~/.gemini/GEMINI.md`, Agent Manager UI | [UNVERIFIED] Markdown, UI builder |
| **Claude Code** | ✅ Strong | ✅ Strong | ⚠️ Partial | `CLAUDE.md`, `.claude/skills/`, `.claude/settings.json` | Markdown context files, skills with YAML frontmatter |
| **Codex** | ✅ Strong | ⚠️ Limited | ⚠️ Limited | `~/.codex/config.toml`, `.codex/config.toml` | TOML config, user + project levels |
| **Gemini CLI** | ✅ Strong | ⚠️ Limited | ⚠️ Partial | `~/.gemini/GEMINI.md` | Markdown context files, MCP servers, hierarchical |
| **Aider** | ✅ Strong | ❌ No | ⚠️ Limited | `.aider.conf.yml` | YAML config, CLI flags, custom prompts |

**Legend:**
- ✅ Strong: Full or near-equivalent support
- ⚠️ Partial/Limited: Some support with limitations
- ❌ No: Not supported or very limited

### Quick Migration Guide

| If you need... | Best agent choice | Why |
|----------------|-------------------|-----|
| **Full skills + workflows** | Claude Code, Kilo Code | Similar SKILL.md structure, mode system |
| **Git automation** | Aider | Native git integration, auto-commits |
| **Multi-file editing** | Cursor | Composer mode designed for this |
| **Agent orchestration** | Kilo Code | Subagent system, autonomous modes |
| **MCP extensibility** | Continue, Gemini CLI | Built-in MCP server support |
| **Simple project rules** | Cursor, GitHub Copilot | Single file configuration |
| **Terminal workflows** | Claude Code, Codex | Terminal integration, agentic |

---

## Global Rules & Protocols Mapping

Our global rules define core engineering principles, protocols, and behavioral guidelines for the AI assistant.

### Windsurf/Cascade Configuration

**Location:** `memories/global_rules.md`

**Key Components:**
1. Session Start Protocol
2. Change Management Protocol
3. Configuration Change Protocol
4. Process Requirements
5. Project Law (correctness, performance, architecture)

### Agent Equivalents

| Feature | Windsurf/Cascade | GitHub Copilot | Cursor | Continue | Kilo Code | Antigravity | Claude Code | Codex | Gemini CLI | Aider |
|---------|-----------------|---------------|--------|----------|-----------|-------------|-------------|-------|------------|-------|
| **Custom Instructions** | `memories/global_rules.md` (Custom) | `.github/copilot-instructions.md` | `.cursorrules` | `config.yaml` → `systemMessage` | `AGENTS.md` | `GEMINI.md` | `CLAUDE.md` | `config.toml` → `instructions` | `GEMINI.md` | `.aider.conf.yml` |
| **Repository-level Rules** | `memories/global_rules.md` (Custom) | `.github/copilot-instructions.md` | `.cursorrules` | Project-level `config.yaml` | `AGENTS.md` (root) | `GEMINI.md` (workspace) | `CLAUDE.md` (project root) | `.codex/config.toml` | `GEMINI.md` (workspace) | `.aider.conf.yml` |
| **Global/User Rules** | `memories/global_rules.md` (Custom) | VS Code settings (Workspace/Global) | Cursor Settings → Rules | `~/.continue/config.yaml` | `~/.kilocode/skills/` (global) | `~/.gemini/GEMINI.md` | `~/.claude/skills/` | `~/.codex/config.toml` | `~/.gemini/GEMINI.md` | `~/.aider.conf.yml` |
| **Session Protocol** | ✅ Built-in (Custom) | Not supported | Not supported | Via `systemMessage` | Via `AGENTS.md` | Via agent config | Via skills | Via `instructions` | Via config | Via `--message` |
| **Change Management** | ✅ Built-in (Custom) | Via instructions | Via `.cursorrules` | Via `systemMessage` | Via `AGENTS.md` | Via rules | Via instructions | Via `instructions` | Via config | Via `--message` |
| **Project Law/Principles** | ✅ Built-in (Custom) | Via instructions | Via `.cursorrules` | Via `systemMessage` | Via `AGENTS.md` | Via rules | Via instructions | Via `instructions` | Via config | Via `--message` |

**Key Findings:**
- **All agents support custom instructions** in some form
- **File-based config** is standard (except Antigravity which uses UI)
- **Hierarchy support** varies: most support both global and project-level rules
- **No agent has built-in protocol structure** - must be defined in custom instructions

---

## Skills System Mapping

Our skills system provides 12 specialized capabilities organized into Atomic, Composite, and Orchestration categories.

### Windsurf/Cascade Configuration

**Location:** `skills/` directory (12 subdirectories)

**Skill Categories:**
- **Atomic**: debug, write-tests, write-docs, refactor, optimize, maintain-consistency
- **Composite**: develop-api, create-item, manage-git
- **Orchestration**: design-architecture, recover-design, audit-security

### Agent Equivalents

| Skill Category | Windsurf/Cascade | GitHub Copilot | Cursor | Continue | Kilo Code | Antigravity | Claude Code | Codex | Gemini CLI | Aider |
|----------------|-----------------|---------------|--------|----------|-----------|-------------|-------------|-------|------------|-------|
| **Atomic Skills** | `skills/` (6 custom) | Not supported | File-specific rules in `.cursor/rules/` | Custom slash commands in `config.yaml` | 5 built-in modes + custom modes | Built-in + custom agents | Skills in `.claude/skills/` | Not supported | MCP tools | Not supported |
| **debug** | ✅ `skills/debug/` (Custom) | Built-in | Built-in | Built-in | ✅ Built-in `/debug` mode | Built-in agent | Built-in skill | Built-in | Built-in | Built-in |
| **write-tests** | ✅ `skills/write-tests/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | Custom mode or skill | Custom agent | Custom skill | Via instructions | Via MCP | `--test` flag |
| **write-docs** | ✅ `skills/write-docs/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | Custom mode or skill | Custom agent | Custom skill | Via instructions | Via MCP | Via `--message` |
| **refactor** | ✅ `skills/refactor/` (Custom) | Built-in | Built-in | Built-in | ✅ Built-in `/code` mode | Built-in agent | Built-in skill | Built-in | Built-in | Built-in |
| **optimize** | ✅ `skills/optimize/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | Custom mode or skill | Custom agent | Custom skill | Via instructions | Via MCP | Via `--message` |
| **maintain-consistency** | ✅ `skills/maintain-consistency/` (Custom) | Not supported | Not supported | Not supported | Custom mode | Custom agent | Custom skill | Not supported | Via MCP | Not supported |
| **Composite Skills** | `skills/` (3 custom) | Not supported | Limited | Custom commands | Built-in + custom modes | Custom agents | Custom skills | Not supported | Via MCP | Limited |
| **develop-api** | ✅ `skills/develop-api/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | ✅ Built-in `/code` mode | Custom agent | Custom skill | Via instructions | Via MCP | Via `--message` |
| **create-item** | ✅ `skills/create-item/` (Custom) | Built-in | Built-in | Built-in | ✅ Built-in `/code` mode | Built-in agent | Built-in skill | Built-in | Built-in | Built-in |
| **manage-git** | ✅ `skills/manage-git/` (Custom) | Limited | Limited | Via extension | Custom mode or skill | Built-in agent | Built-in skill | Built-in | Limited | **Native** (core feature) |
| **Orchestration Skills** | `skills/` (3 custom) | Not supported | Not supported | Limited | Built-in + custom modes | **Strong** (agent orchestration) | Custom skills | Not supported | Limited | Not supported |
| **design-architecture** | ✅ `skills/design-architecture/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | ✅ Built-in `/architect` mode | Custom agent | Custom skill | Via instructions | Via MCP | Via `--architect` |
| **recover-design** | ✅ `skills/recover-design/` (Custom) | Not supported | Not supported | Not supported | Custom mode or skill | Custom agent | Custom skill | Not supported | Not supported | Not supported |
| **audit-security** | ✅ `skills/audit-security/` (Custom) | Via instructions | Via `.cursorrules` | Custom command | Custom mode or skill | Custom agent | Custom skill | Via instructions | Via MCP | Via `--message` |

**Configuration Locations:**

| Agent | Skills Config Location | Format | Notes | Custom Options |
|-------|----------------------|--------|-------|----------------|
| **Windsurf/Cascade** | `skills/*/SKILL.md` | Markdown + YAML frontmatter | 12 custom skills, organized by category | Custom: Full skill system with YAML metadata, checklists, pre-submit checks |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Markdown | Define in instructions, no separate skills | Instructions only, no skill structure |
| **Cursor** | `.cursorrules` (project), `.cursor/rules/*.md` (file-specific) | Markdown | Single file or directory-based rules | File-pattern matching rules, agent auto-selects from `.cursor/rules/` |
| **Continue** | `~/.continue/config.yaml` → `slashCommands` | YAML | Custom slash commands act as skills | Define custom commands with prompts, context providers, MCP servers |
| **Kilo Code** | Built-in modes + `.kilocode/modes/*.yaml` + `.kilocode/rules/` | YAML + Markdown | 6 built-in modes + custom modes + custom rules | Built-in: Code, Ask, Architect, Debug, Review, Orchestrator; Custom: YAML modes in `.kilocode/modes/`, skills in `.kilocode/skills/` and `.kilocode/skills-{mode}/`, rules in `.kilocode/rules/` and `.kilocode/rules-{mode}/` |
| **Antigravity** | Agent Manager UI, `.antigravity/agents/` | YAML/UI | Agent-based, each agent is like a skill | Visual agent builder, parallel execution, custom tools |
| **Claude Code** | `.claude/skills/*/SKILL.md` | Markdown + YAML frontmatter | Skill folders with SKILL.md files | Markdown skills with YAML frontmatter, scope definitions, reference files |
| **Codex** | `~/.codex/config.toml`, `.codex/config.toml` | TOML | User + project config, limited skills | Basic instructions in TOML, user and project-level config |
| **Gemini CLI** | `GEMINI.md` files (hierarchical) | Markdown | Context files, not true skills | Hierarchical GEMINI.md files (global, workspace, JIT), MCP servers |
| **Aider** | Command-line flags | CLI args | No skills system, use flags like `--architect` | CLI flags and custom prompts via `--message` |

**Key Findings:**
- **Kilo Code** has 6 built-in modes covering most common workflows (Code, Ask, Architect, Debug, Review, Orchestrator)
- **Kilo Code, Antigravity, Claude Code** have the strongest skills/modes systems
- **Continue** supports custom slash commands (partial equivalent)
- **Cursor** has file-specific rules but no skill orchestration
- **GitHub Copilot, Codex, Gemini CLI, Aider** lack formal skills systems
- **Aider** is git-focused, strongest for version control workflows

---

## Workflows System Mapping

Our workflows system provides 12 execution modes with varying autonomy levels and focus areas.

### Windsurf/Cascade Configuration

**Location:** `global_workflows/` directory (12 custom .md files) + 1 built-in workflow

**Workflow Categories:**
- **Analysis**: analyze, think, dry-run, enhance
- **Execution**: quick
- **Improvement Loops**: loop, turbo, correct, test, tune
- **Control**: stop, validate
- **Built-in**: review (Windsurf native)

### Agent Equivalents

| Workflow | Windsurf/Cascade | GitHub Copilot | Cursor | Continue | Kilo Code | Antigravity | Claude Code | Codex | Gemini CLI | Aider |
|----------|-----------------|---------------|--------|----------|-----------|-------------|-------------|-------|------------|-------|
| **analyze** | ✅ `/analyze` (Custom) | Not supported | Composer mode | Chat mode | ✅ Built-in `/ask` mode | Analysis agent | `/analyze` command | Chat mode | Agent mode | `--message "analyze"` |
| **think** | ✅ `/think` (Custom) | Not supported | Not supported | Not supported | ✅ Built-in `/architect` mode | Reasoning agent | Not supported | Not supported | Not supported | Not supported |
| **dry-run** | ✅ `/dry-run` (Custom) | Not supported | Not supported | Not supported | ✅ Built-in `/architect` mode | Planning agent | `/plan` command | `--dry-run` flag | Not supported | `--dry-run` flag |
| **enhance-prompt** | ✅ `/enhance-prompt` (Custom) | Not supported | Not supported | Not supported | Not supported | Not supported | Not supported | Not supported | Not supported | Not supported |
| **quick** | ✅ `/quick` (Custom) | Inline completion | Inline completion | Autocomplete | ✅ Built-in `/code` mode | Quick agent | Inline | Inline | Inline | Direct mode |
| **loop** | ✅ `/loop` (Custom) | Not supported | Not supported | Not supported | Custom mode or `/code` | Iterative agent | Agent mode | Not supported | Agent mode | Interactive mode |
| **turbo-loop** | ✅ `/turbo-loop` (Custom) | Not supported | Not supported | Not supported | Custom mode | **Autonomous agent** | Agent mode | Not supported | Agent mode | `--yes` flag |
| **fix-correctness** | ✅ `/fix-correctness` (Custom) | Not supported | Not supported | Not supported | Custom mode or `/debug` | QA agent | Not supported | Not supported | Not supported | Not supported |
| **test** | ✅ `/test` (Custom) | Not supported | Not supported | Not supported | Custom mode or skill | Testing agent | `/test` command | Not supported | Testing tools | `--test` flag |
| **tune-performance** | ✅ `/tune-performance` (Custom) | Not supported | Not supported | Not supported | Custom mode or skill | Performance agent | Not supported | Not supported | Not supported | Not supported |
| **stop** | ✅ `/stop` (Custom) | Manual | Manual | Manual | Stop command | Stop agent | Stop command | Manual | Manual | Ctrl+C |
| **validate** | ✅ `/validate` (Custom) | Not supported | Not supported | Not supported | Custom mode or skill | Validation agent | Not supported | Not supported | Not supported | Not supported |
| **review** | ✅ `/review` (Built-in) | Not supported | Not supported | Not supported | ✅ Built-in `/review` mode | Not supported | Not supported | Not supported | Not supported | Not supported |
| **orchestrator** | Not supported | Not supported | Not supported | Not supported | ✅ Built-in `/orchestrator` mode | **Autonomous agent** | Not supported | Not supported | Not supported | Not supported |

**Configuration Locations:**

| Agent | Workflows Config Location | Format | Notes | Custom Options |
|-------|--------------------------|--------|-------|----------------|
| **Windsurf/Cascade** | `global_workflows/*.md` + built-in | Markdown + YAML frontmatter | 12 custom + 1 built-in workflow | Custom: 12 workflows in files; Built-in: `/review` (native to Windsurf) |
| **GitHub Copilot** | Not supported | N/A | No workflow system | None - no workflow concept |
| **Cursor** | Composer mode (built-in) | UI | Limited to Composer vs Chat | Built-in modes only, no custom workflows |
| **Continue** | Not supported | N/A | Chat vs autocomplete only | None - no workflow concept |
| **Kilo Code** | `.kilocode/modes/*.yaml`, `.kilocode/rules/` | YAML + Markdown | Custom modes = workflows, custom rules | Full custom modes with tools, instructions, role definitions; custom rules in `.kilocode/rules/` and mode-specific `.kilocode/rules-{mode}/` |
| **Antigravity** | Agent Manager UI | UI/YAML | Agents can be configured as workflows | Visual agent builder, parallel execution, custom workflows |
| **Claude Code** | `.claude/workflows/` | Markdown | Limited workflow support | Markdown workflow files, command-based invocation |
| **Codex** | Command-line flags | CLI | `--dry-run`, limited | CLI flags only, no workflow structure |
| **Gemini CLI** | Agent mode config | YAML | Agent mode with tools | Agent mode configuration, MCP tool integration |
| **Aider** | Command-line flags | CLI | `--yes`, `--dry-run`, `--test` | CLI flags for behavior modification, no workflow files |

**Key Findings:**
- **Kilo Code and Antigravity** have the strongest workflow/mode systems
- **Most agents** lack formal workflow concepts
- **Autonomous modes** exist in Antigravity, Kilo Code, Aider (`--yes`)
- **Specialized workflows** (correct, tune, validate) are unique to Windsurf
- **CLI agents** (Aider, Codex, Gemini CLI) use flags instead of workflows

---

## Gap Analysis

### Features Unique to Windsurf/Cascade

1. **Structured Skills System** - 12 well-defined, documented skills with clear categories
2. **Comprehensive Workflows** - 12 execution modes covering analysis, loops, and control
3. **maintain-consistency Skill** - No equivalent in other agents
4. **Validation Workflow** - Systematic consistency checking
5. **SKILLS_MAP.md** - Explicit skill relationship documentation
6. **CHANGE_CHECKLISTS.md** - Change impact tracking

### Features Other Agents Have That We Lack

1. **Kilo Code:**
   - AGENTS.md support (cross-tool standard, not Kilo-originated)
   - Visual mode builder UI
   - Subagent system

2. **Antigravity:** [UNVERIFIED]
   - [UNVERIFIED] Mission Control UI for agent orchestration
   - [UNVERIFIED] Parallel agent execution
   - [UNVERIFIED] Web browsing capability
   - [UNVERIFIED] Artifact generation

3. **Claude Code:**
   - Terminal integration
   - Git workflow automation
   - PR review automation

4. **Continue:**
   - MCP (Model Context Protocol) server support
   - Extensive model provider support
   - Context providers system

5. **Aider:**
   - Native git integration (commits, diffs)
   - Repository map generation
   - Automatic commit messages

6. **Cursor:**
   - Composer mode (multi-file editing)
   - @-mentions for context
   - Tab autocomplete

### Agents by Customization Strength

**Tier 1 (Strongest Customization):**
- Kilo Code - Custom modes, AGENTS.md, subagents
- Antigravity - Agent orchestration, parallel execution
- Claude Code - Skills, workflows, terminal integration
- Continue - Slash commands, MCP servers, providers

**Tier 2 (Moderate Customization):**
- Cursor - .cursorrules, file-specific rules
- Aider - YAML config, command flags
- Gemini CLI - Config files, MCP tools

**Tier 3 (Limited Customization):**
- GitHub Copilot - Instructions only
- Codex - Basic config.toml

---

## Key Findings

### 1. Configuration Approaches

**File-Based (Most Common):**
- Markdown: GitHub Copilot, Cursor, Kilo Code, Claude Code
- YAML: Continue, Kilo Code, Antigravity, Aider, Gemini CLI
- TOML: Codex

**UI-Based:**
- Antigravity (Agent Manager)
- Kilo Code (Mode Builder)

### 2. Skills/Modes Support

**Strong Support:**
- Kilo Code (custom modes with full config)
- Antigravity (agent-based system)
- Claude Code (skill files)
- Continue (slash commands)

**Limited/No Support:**
- GitHub Copilot (instructions only)
- Cursor (file-specific rules)
- Codex (instructions only)
- Gemini CLI (MCP tools, not skills)
- Aider (no skills system)

### 3. Workflow/Autonomy Support

**Autonomous Modes:**
- Antigravity (autonomous agents)
- Kilo Code (autonomous mode)
- Aider (`--yes` flag)
- Gemini CLI (agent mode)

**Limited Workflows:**
- Most agents lack structured workflow systems
- Windsurf's 12 workflows are more comprehensive than any competitor

### 4. Migration Considerations

**Easiest to Migrate To:**
1. **Kilo Code** - AGENTS.md standard, custom modes map well to our skills/workflows
2. **Antigravity** - Agent system can replicate skills, strong orchestration
3. **Claude Code** - Skills and workflows partially supported

**Hardest to Migrate To:**
1. **GitHub Copilot** - Limited to instructions, no skills/workflows
2. **Codex** - Basic config only
3. **Aider** - CLI-focused, no skills system

**Best for Specific Use Cases:**
- **Git workflows**: Aider (native git integration)
- **Multi-file editing**: Cursor (Composer mode)
- **Agent orchestration**: Antigravity (parallel agents)
- **Customization**: Kilo Code (most flexible)
- **Terminal workflows**: Claude Code (terminal integration)

---

## Recommendations

### For Our Configuration

1. **Adopt AGENTS.md Standard** - Cross-tool standard for compatibility (supported by multiple agents)
2. **Add Web Browsing** - [UNVERIFIED] Capability mentioned in Antigravity documentation
3. **Improve Git Integration** - Learn from Aider's native git workflows
4. **Add MCP Support** - Continue's Model Context Protocol for extensibility
5. **Create Visual Builder** - Kilo Code's UI for easier skill/workflow creation

### For Migration

1. **To Kilo Code**: Map skills → modes, workflows → modes, use AGENTS.md standard
2. **To Antigravity**: [UNVERIFIED] Map skills → agents, workflows → agent configs
3. **To Claude Code**: Map skills → `.claude/skills/*/SKILL.md`, workflows → commands (most similar structure)
4. **To Continue**: Map skills → slash commands, global rules → systemMessage
5. **To Cursor**: Consolidate all rules into .cursorrules (limited skills/workflows)

### Feature Parity Priorities

**P0 (Critical Gaps):**
- None identified

**P1 (Nice to Have):**
- AGENTS.md standard support
- MCP server integration
- Visual configuration builder
- Web browsing capability

**P2 (Future Enhancements):**
- Parallel skill execution
- PR review automation
- Repository map generation

---

## Agent-Specific Notes

### Windsurf/Cascade (Reference)
- **Type**: Mostly custom configuration + 1 built-in workflow
- **Strengths**: Most comprehensive skills (12 custom), workflows (12 custom + 1 built-in), structured documentation
- **Unique Features**: maintain-consistency skill, validation workflow, SKILLS_MAP, CHANGE_CHECKLISTS
- **Best For**: Rigorous engineering discipline, project-wide consistency
- **Config**: `memories/global_rules.md`, `skills/*/SKILL.md`, `global_workflows/*.md`
- **Custom Options**: Full YAML frontmatter system, Markdown-based skills/workflows, pre-submit checklists
- **Built-in**: `/review` workflow (native to Windsurf)
- **Note**: All 12 skills and 12 workflows are custom-created; `/review` is built into Windsurf

### GitHub Copilot
- **Strengths**: Ubiquitous, well-documented, simple, IDE-integrated, Copilot Chat with built-in modes (explain, fix, test, review)
- **Limitations**: Limited custom skills/workflows; Copilot Workspace is separate product
- **Best For**: Basic custom instructions, simple rules, team-wide standards, inline assistance
- **Config**: `.github/copilot-instructions.md` (repo), VS Code settings (global/workspace)
- **Note**: Copilot Chat provides explain, fix, test, and review modes; Copilot Workspace adds workflow-like capabilities

### Cursor
- **Strengths**: .cursorrules standard, Composer mode, @-mentions, file-specific rules, AGENTS.md support
- **Limitations**: No formal skills/workflows system
- **Best For**: Project-specific rules, multi-file editing, file-pattern rules
- **Config**: `.cursorrules` (project-wide), `.cursor/rules/*.md` (file-specific), `AGENTS.md` (project root), User Rules in Cursor Settings

### Continue
- **Strengths**: Highly customizable, MCP support, open-source, model-agnostic
- **Limitations**: No built-in skills, workflows limited
- **Best For**: Custom slash commands, model flexibility, MCP server integration
- **Config**: `~/.continue/config.yaml` (config.json deprecated)

### Kilo Code
- **Strengths**: 6 built-in modes (Code, Ask, Architect, Debug, Review, Orchestrator), custom modes, AGENTS.md support (cross-tool standard, not Kilo-originated), skills system, custom rules system, subagents
- **Built-in Modes**: `/code` (default), `/ask`, `/architect`, `/debug`, `/review`, `/orchestrator`
- **Limitations**: Newer tool, smaller community
- **Best For**: Strong built-in mode coverage, extensible with custom modes, skills, and rules
- **Config**: `AGENTS.md`, `~/.config/kilo/opencode.json` (global config), `~/.kilocode/rules/` (global rules), `.kilocode/rules/` (project rules), `.kilocode/rules-{mode}/` (mode-specific rules), `~/.kilocode/modes/` (global custom modes), `.kilocode/modes/` (project custom modes), `~/.kilocode/skills/` (global skills), `.kilocode/skills/` (project skills), `.kilocode/skills-{mode}/` (mode-specific skills)

### Antigravity [UNVERIFIED]

> ⚠️ **"Antigravity" is not a widely documented AI coding agent as of 2025.** The following claims are unverified and may refer to an internal, beta, or differently-named product.

- **Strengths**: [UNVERIFIED] Agent orchestration, parallel execution, UI, shares GEMINI.md with Gemini CLI
- **Limitations**: [UNVERIFIED] Google ecosystem, shares config with Gemini CLI (potential conflicts)
- **Best For**: [UNVERIFIED] Complex multi-agent workflows, visual agent building
- **Config**: [UNVERIFIED] `~/.gemini/GEMINI.md` (global), Agent Manager UI
- **Note**: Claims could not be verified against official documentation

### Claude Code
- **Strengths**: CLAUDE.md context files, skills system (similar to Windsurf), terminal integration, git automation, subagents
- **Limitations**: Anthropic ecosystem, newer tool
- **Best For**: Terminal-based workflows, PR reviews, agentic development
- **Config**: `CLAUDE.md` (project context), `.claude/skills/*/SKILL.md` (project), `~/.claude/skills/*/SKILL.md` (global), `~/.claude/settings.json` (settings)
- **Note**: CLAUDE.md for context, skills for specialized capabilities, settings.json for configuration

### Codex (OpenAI)
- **Strengths**: OpenAI model integration (model version depends on OpenAI's current offering), terminal-based, agentic workflows, user + project config
- **Limitations**: Limited customization compared to Claude Code/Kilo Code
- **Best For**: OpenAI ecosystem, terminal workflows, agent-driven development
- **Config**: `~/.codex/config.toml` (user), `.codex/config.toml` (project)
- **Note**: Different from GitHub Copilot; Codex is OpenAI's standalone CLI agent

### Gemini CLI
- **Strengths**: Hierarchical GEMINI.md context system, MCP tools, Google AI integration
- **Limitations**: Limited skills/workflows, CLI-only, context files not true skills
- **Best For**: CLI automation, MCP tool integration, hierarchical project context
- **Config**: `~/.gemini/GEMINI.md` (global), `GEMINI.md` (workspace/JIT)

### Aider
- **Strengths**: Native git integration, repository maps, commit automation, CLI-focused
- **Limitations**: No skills/workflows, CLI-only
- **Best For**: Git-focused development, commit workflows, automated commits
- **Config**: `.aider.conf.yml` (home dir, git root, or current dir)

---

## Conclusion

Our Windsurf/Cascade configuration provides broad coverage across:
- Structured skills system (12 custom skills)
- Workflow variety (12 custom + 1 built-in = 13 total execution modes)
- Documentation and organization (SKILLS_MAP, CHANGE_CHECKLISTS)

**Closest Equivalents:**
1. **Claude Code** - Most similar: skills with SKILL.md + YAML frontmatter, similar structure
2. **Kilo Code** - Best match for custom modes/workflows system
3. **Antigravity** - [UNVERIFIED] Listed for agent orchestration and autonomy

**Unique Strengths:**
- maintain-consistency skill
- Comprehensive validation workflow
- Explicit skill relationship mapping
- Change impact tracking

**Areas for Improvement:**
- Cross-tool compatibility (AGENTS.md standard)
- MCP server support
- Visual configuration tools
- Web browsing capability

This mapping serves as both a reference for understanding our configuration's position in the ecosystem and a guide for potential migrations or feature additions.

**Summary:**
- **10 agents compared**: Windsurf/Cascade (reference) + 9 others
- **3 feature categories mapped**: Global Rules, Skills (12 custom), Workflows (12 custom + 1 built-in)
- **Custom configuration options documented** for each agent
- **Windsurf/Cascade coverage**: 13 total workflows, 12 skills
- **Most similar structure**: Claude Code (skills with SKILL.md + YAML)
- **Comparable agents**: Claude Code, Kilo Code; Antigravity [UNVERIFIED]
