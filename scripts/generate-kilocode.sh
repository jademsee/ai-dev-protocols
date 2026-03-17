#!/usr/bin/env bash
# ===================================================================
# generate-kilocode.sh
# Generate .kilocode/ artifacts from .codeium/windsurf/ configuration
#
# Usage:
#   bash scripts/generate-kilocode.sh [REPO_ROOT]
#
# Requirements:
#   - bash 4+, sed, awk, find
#   - On Windows: run in Git Bash or WSL
#
# What it does:
#   1. Creates .kilocode/ directory structure
#   2. Generates AGENTS.md from global_rules.md (with cross-tool header)
#   3. Extracts rule files from global_rules.md sections
#   4. Copies all skills (with reference fixes)
#   5. Converts workflows (MD) to modes (YAML)
#   6. Links to shared docs in docs/ (CHANGE_CHECKLISTS, MAINTENANCE_GUIDE, SKILLS_MAP)
#   7. Generates .kilocode/README.md
#
# Source of truth: .codeium/windsurf/ (Windsurf is primary tool)
# Shared docs: docs/ (used by all tool configs)
#
# Idempotent: safe to re-run. Overwrites existing output.
# ===================================================================
set -euo pipefail

# ----- Configuration -----
REPO_ROOT="${1:-.}"
WINDSURF_DIR="$REPO_ROOT/.codeium/windsurf"
KILOCODE_DIR="$REPO_ROOT/.kilocode"
DOCS_DIR="$REPO_ROOT/docs"
AGENTS_MD="$REPO_ROOT/AGENTS.md"
GLOBAL_RULES="$WINDSURF_DIR/memories/global_rules.md"

# ----- Validation -----
if [[ ! -d "$WINDSURF_DIR" ]]; then
    echo "ERROR: Windsurf config not found at $WINDSURF_DIR" >&2
    exit 1
fi
if [[ ! -f "$GLOBAL_RULES" ]]; then
    echo "ERROR: global_rules.md not found at $GLOBAL_RULES" >&2
    exit 1
fi

echo "=== Generating Kilo Code from Windsurf ==="
echo "  Source: $WINDSURF_DIR"
echo "  Target: $KILOCODE_DIR"
echo ""

# ===================================================================
# Helpers
# ===================================================================

# Extract lines between two H1-level heading patterns.
# Usage: extract_section FILE 'START_REGEX' 'STOP_REGEX'
#   STOP_REGEX can be "EOF" to read to end of file.
#   Includes the START line, excludes the STOP line.
extract_section() {
    local file="$1" start="$2" stop="$3"
    if [[ "$stop" == "EOF" ]]; then
        awk -v s="$start" '$0 ~ s { f=1 } f { print }' "$file"
    else
        awk -v s="$start" -v e="$stop" \
            '$0 ~ s { f=1 } f && $0 ~ e { exit } f { print }' "$file"
    fi
}

# Return space-separated tool names for a given mode.
get_mode_tools() {
    case "$1" in
        analyze|think|dry-run)
            echo "read grep listDir" ;;
        enhance-prompt|stop)
            echo "read" ;;
        quick)
            echo "read edit write run" ;;
        validate)
            echo "read run grep listDir" ;;
        *)  # loop, turbo-loop, improve-correctness, test, tune-performance
            echo "read edit write run grep" ;;
    esac
}

# Replace stale Windsurf references with Kilo Code equivalents.
# Works on a file path (reads file) or stdin if "-" is passed.
fix_references() {
    local input="${1:--}"
    sed \
        -e 's/global_rules\.md/AGENTS.md/g' \
        -e 's|global_workflows/|modes/|g' \
        -e 's/global_workflows/modes/g' \
        -e 's/Windsurf\/Cascade/Kilo Code/g' \
        -e 's/`\/validate` workflow/`\/validate` mode/g' \
        -e 's/\/validate workflow/\/validate mode/g' \
        -e 's/workflow files/mode files/g' \
        "$input"
}

# ===================================================================
# Step 1: Directory structure
# ===================================================================
echo "[1/7] Creating directory structure..."
mkdir -p "$KILOCODE_DIR"/{rules,modes,skills}

# ===================================================================
# Step 2: Generate AGENTS.md from global_rules.md
# ===================================================================
echo "[2/7] Generating AGENTS.md..."
{
    cat <<'HEADER'
# AI Development Protocols

This document defines the core engineering principles and protocols for AI-assisted development.

> **Cross-Tool Standard:** This file is read natively by Kilo Code and Cursor. For other AI coding agents (Claude Code, GitHub Copilot, Gemini CLI, etc.), copy this content to their expected config file. See `.kilocode/README.md` for per-agent instructions.

---

HEADER
    sed \
        -e 's/Windsurf\/Cascade configuration files (skills\/, global_workflows\/, \*\.md)/Kilo Code configuration files (skills\/, modes\/, *.md)/g' \
        -e 's/skills, workflows, or documentation/skills, modes, or documentation/g' \
        -e 's/skill\/workflow names/skill\/mode names/g' \
        -e 's/Changing global_rules\.md/Changing this file/g' \
        -e 's/Execute `\/validate` workflow/Execute `\/validate` mode/g' \
        "$GLOBAL_RULES"
} > "$AGENTS_MD"
echo "  → AGENTS.md"

# ===================================================================
# Step 3: Extract rules from global_rules.md
# ===================================================================
echo "[3/7] Extracting rules..."

# --- engineering-principles.md ---
# Combines: PROJECT LAW, DEPENDENCIES, CODING STANDARDS, PRE-SUBMIT CHECKLIST
{
    echo "# Engineering Principles"
    echo ""
    echo "These rules define the core engineering discipline for all development work."
    echo ""
    echo "---"
    echo ""
    extract_section "$GLOBAL_RULES" "^# PROJECT LAW" "^# DEPENDENCIES" \
        | sed 's/^# /## /'
    echo ""
    echo "---"
    echo ""
    extract_section "$GLOBAL_RULES" "^# DEPENDENCIES" "^# CODING STANDARDS" \
        | sed 's/^# /## /'
    echo ""
    echo "---"
    echo ""
    extract_section "$GLOBAL_RULES" "^# CODING STANDARDS" "^# IMPROVEMENT LOOP" \
        | sed 's/^# /## /'
    echo ""
    echo "---"
    echo ""
    extract_section "$GLOBAL_RULES" "^# PRE-SUBMIT CHECKLIST" "EOF" \
        | sed 's/^# /## /'
} > "$KILOCODE_DIR/rules/engineering-principles.md"
echo "  → rules/engineering-principles.md"

# --- secrets-management.md ---
{
    echo "# Secrets Management Rules"
    echo ""
    extract_section "$GLOBAL_RULES" "^# SECRETS MANAGEMENT" "^# PROCESS REQUIREMENT" \
        | tail -n +3 \
        | sed 's/^# /## /'
} > "$KILOCODE_DIR/rules/secrets-management.md"
echo "  → rules/secrets-management.md"

# --- improvement-loop.md ---
{
    echo "# Improvement Loop Protocol"
    echo ""
    extract_section "$GLOBAL_RULES" "^# IMPROVEMENT LOOP" "^# PRE-SUBMIT" \
        | tail -n +3 \
        | sed 's/^# /## /'
} > "$KILOCODE_DIR/rules/improvement-loop.md"
echo "  → rules/improvement-loop.md"

# ===================================================================
# Step 4: Copy skills
# ===================================================================
echo "[4/7] Copying skills..."
skill_count=0
for skill_dir in "$WINDSURF_DIR"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    mkdir -p "$KILOCODE_DIR/skills/$skill_name"
    # Copy skill files, fixing internal references
    for sf in "$skill_dir"/*; do
        [[ -f "$sf" ]] || continue
        fix_references "$sf" > "$KILOCODE_DIR/skills/$skill_name/$(basename "$sf")"
    done
    echo "  → skills/$skill_name/"
    skill_count=$((skill_count + 1))
done

# ===================================================================
# Step 5: Convert workflows → modes
# ===================================================================
echo "[5/7] Converting workflows to modes..."
mode_count=0
for wf in "$WINDSURF_DIR"/global_workflows/*.md; do
    [[ -f "$wf" ]] || continue
    name="$(basename "$wf" .md)"
    target="$KILOCODE_DIR/modes/$name.yaml"

    # Extract description from YAML frontmatter (between --- markers)
    description=$(awk '
        /^---$/ { n++; next }
        n==1 && /^description:/ { sub(/^description: */, ""); print; exit }
    ' "$wf")

    # Extract body: everything after the ## /name header line
    body=$(awk '/^## \// { found=1; next } found { print }' "$wf" \
        | sed 's/global_rules\.md/AGENTS.md/g')

    # Get tool list for this mode
    tools=$(get_mode_tools "$name")

    # Write YAML mode file
    {
        echo "name: $name"
        echo "description: \"$description\""
        echo "instructions: |"
        # Indent body by 2 spaces for YAML block scalar
        echo "$body" | sed 's/^/  /'
        echo "tools:"
        for tool in $tools; do
            echo "  - $tool"
        done
    } > "$target"

    echo "  → modes/$name.yaml"
    mode_count=$((mode_count + 1))
done

# ===================================================================
# Step 6: Note shared documentation location
# ===================================================================
echo "[6/7] Documentation (shared in docs/)..."
doc_count=0
for doc in SKILLS_MAP.md CHANGE_CHECKLISTS.md MAINTENANCE_GUIDE.md; do
    src="$DOCS_DIR/$doc"
    if [[ -f "$src" ]]; then
        echo "  → $doc (shared at docs/$doc)"
        doc_count=$((doc_count + 1))
    else
        echo "  ⚠ $doc not found in docs/, skipping"
    fi
done

# ===================================================================
# Step 7: Generate README.md
# ===================================================================
echo "[7/7] Generating README.md..."

# Build dynamic skill tree for README
skill_tree=""
skills=()
for d in "$KILOCODE_DIR"/skills/*/; do
    [[ -d "$d" ]] || continue
    skills+=("$(basename "$d")")
done
for ((i=0; i<${#skills[@]}; i++)); do
    if (( i == ${#skills[@]} - 1 )); then
        skill_tree+="│   └── ${skills[$i]}/"
    else
        skill_tree+="│   ├── ${skills[$i]}/
"
    fi
done

# Build dynamic mode tree for README
mode_tree=""
modes=()
for f in "$KILOCODE_DIR"/modes/*.yaml; do
    [[ -f "$f" ]] || continue
    modes+=("$(basename "$f")")
done
for ((i=0; i<${#modes[@]}; i++)); do
    if (( i == ${#modes[@]} - 1 )); then
        mode_tree+="│   └── ${modes[$i]}"
    else
        mode_tree+="│   ├── ${modes[$i]}
"
    fi
done

# Build mode usage list (name + description from YAML)
mode_usage=""
for f in "$KILOCODE_DIR"/modes/*.yaml; do
    [[ -f "$f" ]] || continue
    mname=$(awk '/^name:/{sub(/^name: */, ""); print; exit}' "$f")
    mdesc=$(awk '/^description:/{sub(/^description: */, ""); print; exit}' "$f")
    mode_usage+="- \`/$mname\` — $mdesc
"
done

# Build skill usage list (name + description from YAML frontmatter)
skill_usage=""
for d in "$KILOCODE_DIR"/skills/*/; do
    [[ -f "$d/SKILL.md" ]] || continue
    sname=$(awk '/^---$/{n++; next} n==1 && /^name:/{sub(/^name: */, ""); print; exit}' "$d/SKILL.md")
    sdesc=$(awk '/^---$/{n++; next} n==1 && /^description:/{sub(/^description: */, ""); print; exit}' "$d/SKILL.md")
    skill_usage+="- \`use the $sname skill\` — $sdesc
"
done

cat > "$KILOCODE_DIR/README.md" << READMEEOF
# Kilo Code Configuration

This directory contains the Kilo Code AI coding assistant configuration, ported from Windsurf/Cascade.

## Directory Structure

\`\`\`
.kilocode/
├── rules/                    # Project-level rules
│   ├── engineering-principles.md
│   ├── secrets-management.md
│   └── improvement-loop.md
├── modes/                    # Custom modes (workflows)
$mode_tree
├── skills/                   # Specialized skills
$skill_tree
├── SKILLS_MAP.md             # Skill relationships and invocation patterns
├── CHANGE_CHECKLISTS.md      # Change management checklists
├── MAINTENANCE_GUIDE.md      # Maintenance protocols
└── README.md                 # This file
\`\`\`

## AGENTS.md — Global Rules File

\`AGENTS.md\` lives at the **repository root** (\`/AGENTS.md\`) and contains the core engineering principles and protocols for this project.

### Location

\`\`\`
<repo-root>/
└── AGENTS.md   ← place here, not inside .kilocode/
\`\`\`

It must be at the root so all AI tools can discover it by walking up from the working directory.

### Which agents read AGENTS.md natively

| Agent | Reads AGENTS.md? | Native config file | Notes |
|-------|------------------|--------------------|-------|
| **Kilo Code** | ✅ Yes | \`AGENTS.md\` | Primary target for this config |
| **Cursor** | ✅ Yes | \`AGENTS.md\` | Also reads \`.cursorrules\` and \`.cursor/rules/\` |
| **Claude Code** | ❌ No | \`CLAUDE.md\` | Copy/rename \`AGENTS.md\` → \`CLAUDE.md\` at repo root |
| **GitHub Copilot** | ❌ No | \`.github/copilot-instructions.md\` | Copy content into that file |
| **Gemini CLI** | ❌ No | \`GEMINI.md\` | Copy/rename \`AGENTS.md\` → \`GEMINI.md\` at repo root |
| **Codex** | ❌ No | \`.codex/config.toml\` | Adapt content into TOML \`instructions\` field |
| **Continue** | ❌ No | \`~/.continue/config.yaml\` | Add content to \`systemMessage\` in config |
| **Aider** | ❌ No | \`.aider.conf.yml\` | Add content to custom prompts via \`--message\` |

### Using this config with other agents

For agents that don't read \`AGENTS.md\` natively, copy the content to their expected file:

**Claude Code** — create \`CLAUDE.md\` at repo root:
\`\`\`
cp AGENTS.md CLAUDE.md
\`\`\`

**GitHub Copilot** — create \`.github/copilot-instructions.md\`:
\`\`\`
cp AGENTS.md .github/copilot-instructions.md
\`\`\`

**Gemini CLI** — create \`GEMINI.md\` at repo root:
\`\`\`
cp AGENTS.md GEMINI.md
\`\`\`

> ⚠️ These copies must be kept in sync manually when \`AGENTS.md\` is updated. See \`CHANGE_CHECKLISTS.md\` for the update protocol.

## Usage

### Modes (Workflows)

Invoke modes using slash commands:

$mode_usage
### Skills

Skills are automatically invoked based on trigger conditions. You can also explicitly invoke them:

$skill_usage
## Supported Languages

All skills and modes support 10 languages:

- JavaScript/TypeScript
- Python
- Go
- Rust
- Java
- C#/.NET
- C/C++
- Swift
- Kotlin
- Dart/Flutter

## Key Features

1. **Engineering Discipline** — Correctness > Performance > Elegance
2. **Architectural Continuity** — Reuse existing patterns and abstractions
3. **Change Management** — Comprehensive synchronization of related components
4. **Multi-Language Support** — Language-specific tools and patterns
5. **Security-First** — Secrets management and security auditing built-in

## Porting Source

This configuration was generated from \`.codeium/windsurf/\` (Windsurf/Cascade) using:

\`\`\`
bash scripts/generate-kilocode.sh
\`\`\`
READMEEOF
echo "  → README.md"

# ===================================================================
# Summary
# ===================================================================
echo ""
echo "=== Generation Complete ==="
echo "  Skills:  $skill_count"
echo "  Modes:   $mode_count"
echo "  Rules:   3"
echo "  Docs:    $doc_count"
echo "  AGENTS:  1"
echo ""
echo "Next steps:"
echo "  1. Review generated files for accuracy"
echo "  2. Run /validate to check consistency"
echo "  3. Commit the .kilocode/ directory and AGENTS.md"
