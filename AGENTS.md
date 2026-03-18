# AI Development Protocols

> **Cross-Tool Standard:** This file is read natively by Kilo Code and Cursor for cross-tool discovery.

---

## Rules Location

All engineering principles, protocols, and guidelines have been consolidated into:

**[`.kilocode/rules/rules.md`](.kilocode/rules/rules.md)**

This single source of truth contains:

- Project Profile configuration
- Session Start Protocol
- Change Management Protocol
- Configuration Change Protocol
- Secrets Management Protocol
- Process Requirements
- Project Law (Architectural Continuity, Code Quality, Performance Principles)
- Dependencies guidelines
- Coding Standards & Formatting
- Improvement Loop Protocol
- Pre-Submit Checklist

---

## Rule Files

The rules are organized into a single file:

| File | Content |
|------|---------|
| [`rules.md`](.kilocode/rules/rules.md) | Complete rules (single source of truth) |

---

## For Other AI Agents

For agents that don't read `AGENTS.md` natively, copy the content from [`.kilocode/rules/rules.md`](.kilocode/rules/rules.md) to their expected config file:

| Agent | Config File |
|-------|-------------|
| Claude Code | `CLAUDE.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini CLI | `GEMINI.md` |
| Codex | `.codex/config.toml` |
| Continue | `~/.continue/config.yaml` |
| Aider | `.aider.conf.yml` |

See [`.kilocode/README.md`](.kilocode/README.md) for detailed instructions.
