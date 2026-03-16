# Porting Guide: Windsurf → Kilo Code (Hybrid Process)

This guide documents the recommended process for generating Kilo Code configuration from the Windsurf/Cascade source. It uses a **hybrid approach**: a bash script handles the mechanical transformations, then an AI agent validates and fixes what the script can't.

> **Note:** Windsurf is the primary tool. All changes originate in `.codeium/windsurf/` first, then are ported to supported tools.

---

## Why Hybrid?

| Layer | Script handles | AI handles |
|-------|---------------|------------|
| **Structure** | Directory creation, file copying | — |
| **Format conversion** | Workflow MD → Mode YAML | — |
| **Literal references** | `global_rules.md` → `AGENTS.md` | — |
| **Contextual references** | — | Prose that says "workflow" meaning "mode" |
| **Content curation** | Raw section extraction | Reorganize, condense, rewrite |
| **Edge cases** | — | YAML special chars, ambiguous replacements |
| **Validation** | File counts, existence checks | Cross-reference accuracy, semantic correctness |

The script gets ~70% right in seconds. The AI review pass catches the remaining ~30% that requires semantic understanding.

---

## Prerequisites

- **bash 4+**, `sed`, `awk`, `find` — On Windows, use Git Bash or WSL
- Windsurf config present at `.codeium/windsurf/`
- An AI coding agent (Kilo Code, Windsurf/Cascade, Claude Code, Cursor, etc.)

---

## Process

### Phase 1: Script Generation (~10 seconds)

Run the script from the repository root:

```bash
bash scripts/generate-kilocode.sh
```

**What it produces:**

| Artifact | Source | Method |
|----------|--------|--------|
| `AGENTS.md` | `memories/global_rules.md` | Copy + header + sed replacements |
| `.kilocode/rules/*.md` | `memories/global_rules.md` | Section extraction via awk |
| `.kilocode/skills/*/SKILL.md` | `skills/*/SKILL.md` | Copy + reference fixes |
| `.kilocode/modes/*.yaml` | `global_workflows/*.md` | Parse frontmatter → YAML conversion |
| `.kilocode/README.md` | — | Generated from artifact metadata |
| Shared docs | `docs/*.md` | Not copied — referenced in place |

**Expected output:**

```
=== Generating Kilo Code from Windsurf ===
  Source: ./.codeium/windsurf
  Target: ./.kilocode

[1/7] Creating directory structure...
[2/7] Generating AGENTS.md...
  → AGENTS.md
[3/7] Extracting rules...
  → rules/engineering-principles.md
  → rules/secrets-management.md
  → rules/improvement-loop.md
[4/7] Copying skills...
  → skills/audit-security/
  → skills/create-item/
  ...
[5/7] Converting workflows to modes...
  → modes/analyze.yaml
  → modes/dry-run.yaml
  ...
[6/7] Copying documentation...
  → SKILLS_MAP.md
  → CHANGE_CHECKLISTS.md
  → MAINTENANCE_GUIDE.md
[7/7] Generating README.md...
  → README.md

=== Generation Complete ===
  Skills:  14
  Modes:   12
  Rules:   3
  Docs:    3
  AGENTS:  1
```

### Phase 2: AI Validation Pass (~5 minutes)

Open the project in your AI coding agent and run:

```
/validate
```

Or prompt manually:

```
Validate the .kilocode/ directory against the source .codeium/windsurf/ config.
Check for:
1. Stale references to global_rules.md that should be AGENTS.md
2. Stale references to global_workflows/ that should be modes/
3. Windsurf-specific terminology that should be Kilo Code
4. YAML syntax validity in all mode files
5. Skill YAML frontmatter completeness
6. Cross-references between docs (CHANGE_CHECKLISTS.md, MAINTENANCE_GUIDE.md, SKILLS_MAP.md)
7. README accuracy (file counts, directory tree, mode/skill lists)
Do NOT make changes — report findings only.
```

### Phase 3: AI Fix Pass (~5 minutes)

Review the validation findings. Then prompt:

```
Fix all issues found in the validation report.
Priority order:
1. Broken references (P0)
2. Stale terminology (P1)
3. YAML issues (P1)
4. Documentation drift (P2)
```

### Phase 4: Manual Review (~5 minutes)

Check these items that neither script nor AI reliably catches:

- [ ] `AGENTS.md` cross-tool header is accurate and current
- [ ] Agent compatibility table in README matches current tool versions
- [ ] Rules files read naturally (not raw dumps)
- [ ] Mode YAML `tools` lists match intended permissions
- [ ] No sensitive information leaked into committed files

### Phase 5: Commit

```bash
git add AGENTS.md .kilocode/
git commit -m "feat: port Windsurf/Cascade config to Kilo Code"
```

---

## Known Script Limitations

These are things the script cannot do — the AI pass must handle them:

1. **Contextual prose rewording** — The script replaces literal strings (`global_rules.md` → `AGENTS.md`) but can't reword prose like "Follow the workflow protocol" → "Follow the mode protocol" when the word "workflow" is used generically.

2. **Rules curation** — The script extracts raw sections from `global_rules.md` by H1 header boundaries. The hand-curated versions reorganize content under clearer headings. If you want curated rules files, ask the AI to rewrite them.

3. **AGENTS.md sed brittleness** — The script matches specific sentences in `global_rules.md` for replacement. If the source text changes, the sed patterns may silently fail (no error, just no replacement). Always validate after running.

4. **New artifact types** — If Windsurf adds new config types beyond `skills/`, `global_workflows/`, and `memories/`, the script won't know about them. Update the script or handle manually.

---

## Re-syncing After Source Changes

When the Windsurf config changes:

```bash
# 1. Re-run the script (overwrites .kilocode/)
bash scripts/generate-kilocode.sh

# 2. Review diff
git diff .kilocode/ AGENTS.md

# 3. Run AI validation
#    /validate

# 4. Fix issues
#    (AI or manual)

# 5. Commit
git add AGENTS.md .kilocode/
git commit -m "chore: re-sync Kilo Code config from Windsurf"
```

---

## Troubleshooting

### Script fails immediately

Check that `.codeium/windsurf/memories/global_rules.md` exists. The script validates this on startup.

### YAML parse errors in mode files

Check for unescaped special characters in workflow descriptions. The script quotes descriptions, but if the source contains nested quotes, manual escaping may be needed.

### Missing references after script run

The `fix_references()` function handles common patterns but not all. Run the AI validation pass — it will catch contextual references the script missed.

### Rules files look like raw dumps

Expected. The script extracts sections verbatim. Ask the AI to curate them:

```
Review .kilocode/rules/engineering-principles.md.
Reorganize under clear headings, condense redundancy,
and make it read as a standalone document.
Keep all rules — just improve structure.
```

---

## File Reference

| File | Purpose |
|------|---------|
| `scripts/generate-kilocode.sh` | Bash script — Phase 1 |
| `.kilocode/PORTING_MANIFEST.md` | Documents source → target mapping |
| `.kilocode/README.md` | Generated README with agent compatibility |
| `docs/CHANGE_CHECKLISTS.md` | What to update when changing config (shared) |
| `docs/MAINTENANCE_GUIDE.md` | Ongoing maintenance procedures (shared) |
| `docs/SKILLS_MAP.md` | Skill relationships and patterns (shared) |
