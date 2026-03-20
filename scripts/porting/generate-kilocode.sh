#!/usr/bin/env bash
# ===================================================================
# generate-kilocode.sh
# Generate .kilocode/ artifacts from .codeium/windsurf/ configuration
#
# Usage:
#   bash scripts/porting/generate-kilocode.sh [REPO_ROOT]
#
# Requirements:
#   - bash 4+, sed
#   - On Windows: run in Git Bash or WSL
#
# What it does:
#   1. Creates .kilocode/ directory structure
#   2. Copies rules.md (direct copy, no transformation)
#   3. Copies all skills (with reference fixes)
#   4. Copies workflows (direct copy)
#   5. Generates AGENTS.md and README.md
#
# Source of truth: .codeium/windsurf/ (Windsurf is primary tool)
# Idempotent: safe to re-run. Overwrites existing output.
# ===================================================================
set -euo pipefail

# ----- Configuration -----
REPO_ROOT="${1:-.}"
WINDSURF_DIR="$REPO_ROOT/.codeium/windsurf"
KILOCODE_DIR="$REPO_ROOT/.kilocode"
AGENTS_MD="$REPO_ROOT/AGENTS.md"
GLOBAL_RULES="$WINDSURF_DIR/memories/rules.md"

# ----- Validation -----
if [[ ! -d "$WINDSURF_DIR" ]]; then
    echo "ERROR: Windsurf config not found at $WINDSURF_DIR" >&2
    exit 1
fi
if [[ ! -f "$GLOBAL_RULES" ]]; then
    echo "ERROR: rules.md not found at $GLOBAL_RULES" >&2
    exit 1
fi

echo "=== Generating Kilo Code from Windsurf ==="
echo "  Source: $WINDSURF_DIR"
echo "  Target: $KILOCODE_DIR"
echo ""

# ===================================================================
# Helper: Fix references in files
# ===================================================================
fix_references() {
    local input="${1:--}"
    sed \
        -e 's/\.codeium\/windsurf\//.kilocode\//g' \
        -e 's/global_workflows\//workflows\//g' \
        -e 's/memories\/rules\.md/rules\/rules.md/g' \
        -e 's/global_rules\.md/AGENTS.md/g' \
        -e 's/Windsurf\/Cascade/Kilo Code/g' \
        "$input"
}

# ===================================================================
# Step 1: Directory structure
# ===================================================================
echo "[1/5] Creating directory structure..."
mkdir -p "$KILOCODE_DIR"/{rules,workflows,skills}

# ===================================================================
# Step 2: Copy rules.md (direct copy)
# ===================================================================
echo "[2/5] Copying rules..."
cp "$GLOBAL_RULES" "$KILOCODE_DIR/rules/rules.md"
echo "  → rules/rules.md"

# ===================================================================
# Step 3: Copy skills
# ===================================================================
echo "[3/5] Copying skills..."
skill_count=0
for skill_dir in "$WINDSURF_DIR"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    
    # Skip non-skill files (e.g., .tmp files)
    [[ "$skill_name" == *.tmp ]] && continue
    
    mkdir -p "$KILOCODE_DIR/skills/$skill_name"
    for sf in "$skill_dir"/*; do
        [[ -f "$sf" ]] || continue
        fix_references "$sf" > "$KILOCODE_DIR/skills/$skill_name/$(basename "$sf")"
    done
    echo "  → skills/$skill_name/"
    skill_count=$((skill_count + 1))
done

# ===================================================================
# Step 4: Copy workflows
# ===================================================================
echo "[4/5] Copying workflows..."
workflow_count=0
for wf in "$WINDSURF_DIR"/global_workflows/*.md; do
    [[ -f "$wf" ]] || continue
    name="$(basename "$wf" .md)"
    fix_references "$wf" > "$KILOCODE_DIR/workflows/$name.md"
    echo "  → workflows/$name.md"
    workflow_count=$((workflow_count + 1))
done

# ===================================================================
# Step 5: Generate AGENTS.md and README.md
# ===================================================================
echo "[5/5] Generating AGENTS.md and README.md..."

# Generate AGENTS.md (pointer file)
cat > "$AGENTS_MD" << 'HEADER'
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
HEADER
echo "  → AGENTS.md"

# Build dynamic skill list
skill_list=""
for d in "$KILOCODE_DIR"/skills/*/; do
    [[ -d "$d" ]] || continue
    skill_list+="- $(basename "$d")/\n"
done

# Build dynamic workflow list
workflow_list=""
for f in "$KILOCODE_DIR"/workflows/*.md; do
    [[ -f "$f" ]] || continue
    workflow_list+="- $(basename "$f")\n"
done

# Generate README.md
cat > "$KILOCODE_DIR/README.md" << READMEEOF
# Kilo Code Configuration

This directory contains the Kilo Code AI coding assistant configuration, ported from Windsurf/Cascade.

## Directory Structure

\`\`\`
.kilocode/
├── rules/                    # Project-level rules
│   └── rules.md              # Complete rules (single source of truth)
├── workflows/                # Custom workflows (slash commands)
$(echo -e "$workflow_list" | head -20)
├── skills/                   # Specialized skills
$(echo -e "$skill_list" | head -20)
└── README.md                 # This file
\`\`\`

## AGENTS.md — Global Rules File

\`AGENTS.md\` lives at the **repository root** and points to [rules/rules.md](rules/rules.md).

See [AGENTS.md](../AGENTS.md) for cross-tool compatibility instructions.

## Usage

### Workflows

Invoke workflows using slash commands (e.g., \`/validate\`, \`/diagnose\`, \`/test\`).

### Skills

Skills are automatically invoked based on trigger conditions. You can also explicitly invoke them:

\`\`\`
use the [skill-name] skill
\`\`\`

## Porting Source

This configuration was generated from \`.codeium/windsurf/\` using:

\`\`\`
bash scripts/porting/generate-kilocode.sh
\`\`\`
READMEEOF
echo "  → README.md"

# ===================================================================
# Summary
# ===================================================================
echo ""
echo "=== Generation Complete ==="
echo "  Skills:    $skill_count"
echo "  Workflows: $workflow_count"
echo "  Rules:     1 (rules.md)"
echo "  AGENTS:    1"
echo ""
echo "Next steps:"
echo "  1. Review generated files for accuracy"
echo "  2. Run /validate to check consistency"
echo "  3. Commit the .kilocode/ directory and AGENTS.md"
