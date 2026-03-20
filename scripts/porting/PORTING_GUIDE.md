# Porting Guide: Windsurf → Kilo Code

This guide documents the process for generating Kilo Code configuration from the Windsurf/Cascade source.

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

---

## What the Script Does

| Layer | Script handles |
|-------|---------------|
| **Structure** | Directory creation, file copying |
| **Reference fixes** | Path and terminology replacements via sed |
| **AGENTS.md** | Generates pointer file to `.kilocode/rules/rules.md` |
| **README.md** | Generates directory listing |

The script handles ~90% of the work. Run `/validate` to catch any remaining issues.

---

## Prerequisites

- **bash 4+**, `sed` — On Windows, use Git Bash or WSL
- Windsurf config present at `.codeium/windsurf/`

---

## Process

### Step 1: Run Script (~5 seconds)

```bash
bash scripts/porting/generate-kilocode.sh
```

**What it produces:**

| Artifact | Source | Method |
|----------|--------|--------|
| `AGENTS.md` | — | Generated pointer file |
| `.kilocode/rules/rules.md` | `memories/rules.md` | Direct copy |
| `.kilocode/skills/*/SKILL.md` | `skills/*/SKILL.md` | Copy + reference fixes |
| `.kilocode/workflows/*.md` | `global_workflows/*.md` | Copy + reference fixes |
| `.kilocode/README.md` | — | Generated directory listing |

**Expected output:**

```
=== Generating Kilo Code from Windsurf ===
  Source: ./.codeium/windsurf
  Target: ./.kilocode

[1/5] Creating directory structure...
[2/5] Copying rules...
  → rules/rules.md
[3/5] Copying skills...
  → skills/audit-security/
  → skills/create-item/
  ...
[4/5] Copying workflows...
  → workflows/diagnose.md
  → workflows/prescribe.md
  ...
[5/5] Generating AGENTS.md and README.md...
  → AGENTS.md
  → README.md

=== Generation Complete ===
  Skills:    16
  Workflows: 10
  Rules:     1 (rules.md)
  AGENTS:    1
```

### Step 2: Validate (~1 minute)

Run `/validate` to check for any remaining issues:

```
/validate
```

### Step 3: Commit

```bash
git add AGENTS.md .kilocode/
git commit -m "feat: port Windsurf/Cascade config to Kilo Code"
```

---

## Re-syncing After Source Changes

When the Windsurf config changes:

```bash
# 1. Re-run the script (overwrites .kilocode/)
bash scripts/porting/generate-kilocode.sh

# 2. Review diff
git diff .kilocode/ AGENTS.md

# 3. Run /validate

# 4. Commit
git add AGENTS.md .kilocode/
git commit -m "chore: re-sync Kilo Code config from Windsurf"
```

---

## Troubleshooting

### Script fails immediately

Check that `.codeium/windsurf/memories/rules.md` exists. The script validates this on startup.

### Missing references after script run

The `fix_references()` function handles common patterns. Run `/validate` to catch any remaining issues.

---

## File Reference

| File | Purpose |
|------|---------|
| `scripts/porting/generate-kilocode.sh` | Bash script for porting |
| `.kilocode/README.md` | Generated README |
| `AGENTS.md` | Cross-tool pointer file | |
