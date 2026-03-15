# Change Impact Checklists

This document provides systematic checklists for different types of changes to ensure all related components are updated consistently.

---

## Checklist 1: Modifying a Skill

### When You Change a Skill File

**Files to Review:**
- [ ] `SKILLS_MAP.md` - Update skill description, dependencies, or patterns
- [ ] `global_rules.md` - Check if change affects global rules or examples
- [ ] All workflow files in `global_workflows/` - Check for references to this skill
- [ ] Other skills that may reference this one (check SKILLS_MAP.md for relationships)
- [ ] Any project-specific `ARCHITECTURE.md` or custom rules that reference the skill

**Specific Updates:**

If you **add a new skill**:
- [ ] Add to SKILLS_MAP.md in appropriate category (Atomic/Composite/Orchestration)
- [ ] Add to dependency matrix in SKILLS_MAP.md
- [ ] Add to skill selection guide in SKILLS_MAP.md
- [ ] Update skill count in any overview documentation
- [ ] Consider if any workflows should invoke it

If you **rename a skill**:
- [ ] Update all references in SKILLS_MAP.md
- [ ] Search all workflow files for old skill name
- [ ] Update any checklist references in other skills
- [ ] Update the skill's own YAML frontmatter

If you **change skill process or hard rules**:
- [ ] Review if SKILLS_MAP.md patterns need updating
- [ ] Check if global_rules.md examples reference this skill
- [ ] Verify no conflicts with other skills' processes

If you **add language-specific guidance** (tools, patterns):
- [ ] Check if other skills need the same language added for consistency
  - design-architecture.md (dependency tools)
  - optimize.md (profiling tools)
  - audit-security.md (security tools)
  - write-tests.md (testing frameworks)
- [ ] Ensure language coverage is consistent across all relevant skills

**Validation:**
- [ ] No broken cross-references to other skills
- [ ] Skill category in SKILLS_MAP.md is correct
- [ ] Hard rules don't conflict with global_rules.md
- [ ] Pre-submit checklist is complete and actionable
- [ ] Run `/validate` workflow and fix all issues

---

## Checklist 2: Modifying a Workflow

### When You Change a Workflow File

**Files to Review:**
- [ ] `SKILLS_MAP.md` - Update workflow integration section if needed
- [ ] `global_rules.md` - Check if workflow references or contradicts global rules
- [ ] Other workflows - Check for similar patterns that should be consistent

**Specific Updates:**

If you **add a new workflow**:
- [ ] Document it in a workflows overview (create WORKFLOWS_MAP.md if needed)
- [ ] Add to SKILLS_MAP.md workflow integration section
- [ ] Ensure naming follows convention (verb.md or mode.md)

If you **change workflow behavior**:
- [ ] Update SKILLS_MAP.md if workflow-skill integration changed
- [ ] Check if global_rules.md IMPROVEMENT LOOP PROTOCOL needs updating
- [ ] Verify consistency with similar workflows (e.g., loop.md vs turbo.md)

If you **reference a skill in a workflow**:
- [ ] Verify the skill exists
- [ ] Check SKILLS_MAP.md to ensure the invocation pattern is appropriate
- [ ] Avoid creating tight coupling (workflows orchestrate, don't invoke directly)

**Validation:**
- [ ] Workflow doesn't contradict global_rules.md
- [ ] Workflow doesn't create circular dependencies with skills
- [ ] Instructions are clear and actionable
- [ ] Run `/validate` workflow and fix all issues

---

## Checklist 3: Modifying Global Rules

### When You Change global_rules.md

**Files to Review:**
- [ ] **ALL skills** - Verify no conflicts with new/changed rules
- [ ] **ALL workflows** - Verify alignment with new/changed rules
- [ ] `SKILLS_MAP.md` - Update hard rules section if needed

**Specific Updates:**

If you **add a new rule or principle**:
- [ ] Review all skills to ensure compliance
- [ ] Update skills that should enforce the new rule
- [ ] Add to relevant skill pre-submit checklists

If you **change the IMPROVEMENT LOOP PROTOCOL**:
- [ ] Update loop.md workflow
- [ ] Update turbo.md workflow
- [ ] Update correct.md, tune.md, test.md workflows
- [ ] Update stop.md workflow

If you **change coding standards**:
- [ ] Update create-item.md skill
- [ ] Update refactor.md skill
- [ ] Update develop-api skill

If you **change dependency rules**:
- [ ] Update design-architecture.md skill
- [ ] Update create-item.md skill

**Validation:**
- [ ] No skill contradicts the new/changed rules
- [ ] All workflows align with the rules
- [ ] Rules are enforceable and verifiable
- [ ] Run `/validate` workflow and fix all issues

---

## Checklist 4: Adding Language Support

### When You Add a New Language to Any Skill

**Files to Update:**
- [ ] `design-architecture.md` - Add dependency analysis tools
- [ ] `optimize.md` - Add profiling tools (CPU, memory, benchmarking)
- [ ] `audit-security.md` - Add security analysis tools
- [ ] `write-tests.md` - Add testing frameworks and concurrency tools (if applicable)

**Consistency Check:**
- [ ] Language is added to ALL relevant skills, not just one
- [ ] Tool recommendations are current and widely adopted
- [ ] Format matches existing language entries (bold language name, categorized tools)

**Validation:**
- [ ] Tools are production-ready and maintained
- [ ] Commands/usage examples are accurate
- [ ] No duplicate entries across skills
- [ ] Run `/validate` workflow and fix all issues

---

## Checklist 5: Updating SKILLS_MAP.md

### When You Change SKILLS_MAP.md

**Triggers for Update:**
- New skill added
- Skill renamed or removed
- Skill category changed
- New invocation pattern discovered
- Skill dependencies changed

**Verification:**
- [ ] All skills listed actually exist in `skills/` directory
- [ ] Skill categories match actual skill behavior
- [ ] Dependency matrix is accurate (test by tracing references)
- [ ] Invocation patterns match actual workflow usage
- [ ] Skill selection guide is complete

**Cross-Reference Check:**
- [ ] Every skill in `skills/` directory is in SKILLS_MAP.md
- [ ] Every skill referenced in workflows is documented
- [ ] No orphaned or undocumented skills

---

## Checklist 6: Removing or Deprecating Components

### When You Remove a Skill

**Before Removal:**
- [ ] Search all workflows for references
- [ ] Search all other skills for references
- [ ] Search SKILLS_MAP.md for references
- [ ] Search global_rules.md for examples using this skill

**After Removal:**
- [ ] Remove from SKILLS_MAP.md (all sections)
- [ ] Update dependency matrix
- [ ] Update skill count in documentation
- [ ] Remove directory from `skills/`
- [ ] Run `/validate` workflow and fix all issues

### When You Remove a Workflow

**Before Removal:**
- [ ] Check if SKILLS_MAP.md references it
- [ ] Check if global_rules.md references it
- [ ] Check if other workflows reference it

**After Removal:**
- [ ] Remove from SKILLS_MAP.md workflow integration section
- [ ] Remove file from `global_workflows/`
- [ ] Run `/validate` workflow and fix all issues

### When You Deprecate (Not Remove)

**Mark as Deprecated:**
- [ ] Add deprecation notice to top of file
- [ ] Update SKILLS_MAP.md with deprecation status
- [ ] Document replacement skill/workflow
- [ ] Set timeline for removal

---

## Checklist 7: Cross-Reference Integrity

### Periodic Validation (Run Monthly or After Major Changes)

**Skill Cross-References:**
- [ ] Every skill mentioned in SKILLS_MAP.md exists in `skills/` directory
- [ ] Every skill in `skills/` directory is documented in SKILLS_MAP.md
- [ ] No skills reference other skills directly (only in checklists)

**Workflow Cross-References:**
- [ ] Every workflow file is documented
- [ ] Workflows don't create circular dependencies
- [ ] Workflow instructions are consistent with global_rules.md

**Language Coverage:**
- [ ] Same languages covered across design-architecture, optimize, audit-security, write-tests
- [ ] No language has tools in one skill but missing in others

**Documentation Links:**
- [ ] All file paths referenced actually exist
- [ ] All skill names referenced are spelled correctly
- [ ] All workflow names referenced are spelled correctly

---

## Quick Reference: What to Check When...

| You Changed...           | Check These Files...                                      |
|--------------------------|-----------------------------------------------------------|
| A skill                  | SKILLS_MAP.md, workflows, other skills, global_rules.md   |
| A workflow               | SKILLS_MAP.md, global_rules.md, other workflows           |
| global_rules.md          | ALL skills, ALL workflows, SKILLS_MAP.md                  |
| Added a language         | design-architecture.md, optimize.md, audit-security.md, write-tests.md |
| SKILLS_MAP.md            | Verify all references are valid                           |
| Removed something        | Search ALL files for references before removing           |

---

## Validation

All changes to configuration files MUST be validated before committing:

1. **Run `/validate` workflow** after any change
2. **Fix all reported issues** (both errors and warnings)
3. **Verify consistency** across all affected files
4. **Follow CONFIGURATION CHANGE PROTOCOL** in global_rules.md

The `/validate` workflow uses the maintain-consistency skill to:
- Verify all referenced skills/workflows exist
- Ensure language coverage is consistent
- Find broken cross-references
- Detect orphaned files
- Check format consistency
- Validate YAML frontmatter
- Verify naming conventions
