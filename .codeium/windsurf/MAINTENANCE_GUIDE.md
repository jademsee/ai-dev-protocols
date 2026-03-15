# Windsurf/Cascade Maintenance Guide

This guide provides protocols for maintaining consistency and quality across the Windsurf/Cascade configuration.

---

## Daily/Per-Change Maintenance

### Before Making Any Change

1. **Identify the change type** using CHANGE_CHECKLISTS.md
2. **Review the appropriate checklist** for that change type
3. **Make the change** following the checklist
4. **Validate** using the `/validate` workflow

### After Making Any Change

Run the `/validate` workflow to check for consistency issues.

Fix any errors before committing the change.

---

## Weekly Maintenance

### Every Week

**Cross-Reference Audit:**
- [ ] Run `/validate` workflow
- [ ] Fix any errors or warnings
- [ ] Review recent changes for consistency

**Documentation Review:**
- [ ] Check if any skills have changed without updating SKILLS_MAP.md
- [ ] Check if any workflows have changed without updating documentation
- [ ] Verify language coverage is still consistent

---

## Monthly Maintenance

### Every Month

**Comprehensive Review:**
- [ ] Run `/validate` workflow
- [ ] Review all skills for consistency with global_rules.md
- [ ] Review all workflows for consistency with global_rules.md
- [ ] Check for orphaned files or deprecated content
- [ ] Update tool recommendations if newer versions are available

**Language Coverage Audit:**
- [ ] Verify same languages across: design-architecture, optimize, audit-security, write-tests
- [ ] Check if new popular languages should be added
- [ ] Verify tool recommendations are still current

**Dependency Check:**
- [ ] Review SKILLS_MAP.md dependency matrix
- [ ] Verify no circular dependencies introduced
- [ ] Check that skill categories are still accurate

---

## Quarterly Maintenance

### Every 3 Months

**Major Review:**
- [ ] Review all skills for relevance and accuracy
- [ ] Review all workflows for effectiveness
- [ ] Update tool recommendations based on ecosystem changes
- [ ] Check for deprecated tools that should be replaced
- [ ] Review global_rules.md for updates based on experience

**Tool Updates:**
- [ ] Research new profiling tools (optimize.md)
- [ ] Research new security tools (audit-security.md)
- [ ] Research new dependency analysis tools (design-architecture.md)
- [ ] Research new testing frameworks (write-tests.md)

**Documentation Refresh:**
- [ ] Update examples in skills if patterns have evolved
- [ ] Refresh SKILLS_MAP.md with lessons learned
- [ ] Update CHANGE_CHECKLISTS.md if new patterns emerged

---

## Update Protocols

### Protocol 1: Adding a New Skill

**Step-by-Step:**

1. **Create the skill file**
   ```
   c:\Users\email\.codeium\windsurf\skills\[skill-name]\SKILL.md
   ```

2. **Add YAML frontmatter**
   ```yaml
   ---
   name: skill-name
   description: Brief description
   ---
   ```

3. **Follow skill template structure:**
   - Trigger section
   - Process section (numbered steps)
   - Standards/Framework section
   - Hard Rules section
   - Pre-Submit Check section

4. **Update SKILLS_MAP.md:**
   - Add to appropriate category (Atomic/Composite/Orchestration)
   - Add to dependency matrix
   - Add to skill selection guide
   - Add invocation patterns if applicable

5. **Validate:**
   Run the `/validate` workflow to check for consistency issues.

6. **Document in CHANGE_CHECKLISTS.md** if this is a new pattern

### Protocol 2: Adding Language Support

**Step-by-Step:**

1. **Identify which skills need the language:**
   - design-architecture.md (dependency analysis tools)
   - optimize.md (profiling tools)
   - audit-security.md (security tools)
   - write-tests.md (testing frameworks, if applicable)

2. **Research tools for the language:**
   - Find widely-adopted, production-ready tools
   - Verify tools are actively maintained
   - Get exact command-line usage

3. **Add to ALL relevant skills** (not just one):
   - Use consistent formatting (### LanguageName)
   - Categorize tools (CPU Profiling, Memory Profiling, etc.)
   - Include command examples where helpful

4. **Validate consistency:**
   Run the `/validate` workflow to check for language coverage warnings.

5. **Update CHANGE_CHECKLISTS.md** if needed

### Protocol 3: Modifying Global Rules

**Step-by-Step:**

1. **Make the change to global_rules.md**

2. **Identify affected skills:**
   - Which skills enforce this rule?
   - Which skills reference this rule?
   - Which skills might conflict with this rule?

3. **Update each affected skill:**
   - Update process steps if needed
   - Update hard rules if needed
   - Update pre-submit checklists if needed

4. **Identify affected workflows:**
   - Which workflows reference this rule?
   - Which workflows might conflict?

5. **Update each affected workflow**

6. **Update SKILLS_MAP.md** if patterns changed

7. **Validate:**
   Run the `/validate` workflow to check for consistency issues.

8. **Test with a sample task** to verify the rule is enforceable

### Protocol 4: Removing a Component

**Step-by-Step:**

1. **Search for all references:**
   ```powershell
   # Search all files for the component name
   Get-ChildItem -Path "c:\Users\email\.codeium\windsurf" -Recurse -Filter "*.md" | 
       Select-String -Pattern "component-name"
   ```

2. **Update or remove each reference:**
   - SKILLS_MAP.md
   - Other skills
   - Workflows
   - global_rules.md
   - CHANGE_CHECKLISTS.md

3. **Remove the file/directory**

4. **Validate:**
   Run the `/validate` workflow to check for consistency issues.

5. **Verify no broken references remain**

---

## Validation Procedures

### Manual Validation Checklist

Run this checklist monthly or after major changes:

**Skill Validation:**
- [ ] Every skill has YAML frontmatter
- [ ] Every skill has all required sections
- [ ] No skills invoke other skills directly (only checklist references)
- [ ] All skills align with global_rules.md

**Workflow Validation:**
- [ ] All workflows are documented
- [ ] Workflows don't contradict global_rules.md
- [ ] Workflow instructions are clear and actionable

**Cross-Reference Validation:**
- [ ] All skill references point to existing skills
- [ ] All file paths are valid
- [ ] No orphaned files exist

**Language Coverage Validation:**
- [ ] Same languages across design-architecture, optimize, audit-security, write-tests
- [ ] Tool recommendations are current
- [ ] Command examples are accurate

### Automated Validation

Run the `/validate` workflow to perform automated consistency checking.

Expected output:
- 0 errors (required)
- 0 warnings (ideal)

**If errors are found:**
1. Review the error messages
2. Use CHANGE_CHECKLISTS.md to identify what to fix
3. Fix the errors
4. Re-run validation
5. Repeat until clean

**If warnings are found:**
- Warnings indicate potential issues but don't block usage
- Review and fix warnings when convenient
- Some warnings may be acceptable (document why)

---

## Common Maintenance Tasks

### Task: Update Tool Recommendations

**When:** Quarterly, or when a major tool update occurs

**Steps:**
1. Research current best practices for the language/domain
2. Identify if recommended tools have changed
3. Update the relevant skill (design-architecture, optimize, audit-security, write-tests)
4. Verify command examples still work
5. Run `/validate` workflow

### Task: Fix Inconsistent Language Coverage

**When:** Validation script reports language coverage warnings

**Steps:**
1. Identify which language is inconsistently covered
2. Identify which skills are missing the language
3. Research appropriate tools for that language
4. Add to all missing skills
5. Run `/validate` workflow to confirm

### Task: Refactor a Skill

**When:** Skill has grown too complex or patterns have changed

**Steps:**
1. Read the entire skill first
2. Identify what needs to change
3. Check SKILLS_MAP.md for dependencies
4. Make the changes
5. Update SKILLS_MAP.md if patterns changed
6. Update any workflows that reference the skill
7. Run validation script

### Task: Merge Similar Skills

**When:** Two skills have overlapping responsibilities

**Steps:**
1. Identify the overlap
2. Decide which skill should absorb the other
3. Merge content into the surviving skill
4. Update SKILLS_MAP.md (remove old skill, update patterns)
5. Search for references to the removed skill
6. Update all references to point to the surviving skill
7. Remove the old skill directory
8. Run validation script

---

## Troubleshooting

### Problem: Validation script reports missing skill

**Solution:**
1. Check if the skill was renamed or removed
2. Search for references to the old name
3. Update all references to the new name or remove them
4. Run `/validate` workflow again

### Problem: Language coverage warning

**Solution:**
1. Identify which skills are missing the language
2. Add the language to those skills
3. Use the same format as other languages in that skill
4. Run `/validate` workflow again

### Problem: Circular dependency detected

**Solution:**
1. Review SKILLS_MAP.md dependency matrix
2. Identify the circular path
3. Refactor skills to break the cycle (use workflows to orchestrate instead)
4. Update SKILLS_MAP.md
5. Run validation again

### Problem: Skill contradicts global_rules.md

**Solution:**
1. Decide which should change (usually the skill)
2. Update the skill to align with global rules
3. If global rules should change, follow Protocol 3
4. Run `/validate` workflow again

---

## Best Practices

### Do:
- ✓ Run `/validate` workflow before committing changes
- ✓ Use CHANGE_CHECKLISTS.md for every change
- ✓ Keep language coverage consistent
- ✓ Document why when making exceptions
- ✓ Update SKILLS_MAP.md when patterns change
- ✓ Keep skills atomic and focused
- ✓ Use workflows to orchestrate multi-skill tasks

### Don't:
- ✗ Skip validation after changes
- ✗ Add a language to only one skill
- ✗ Create circular dependencies between skills
- ✗ Let skills invoke other skills directly
- ✗ Ignore validation warnings indefinitely
- ✗ Make changes without checking the appropriate checklist
- ✗ Leave orphaned or deprecated files

---

## Emergency Procedures

### If Configuration is Broken

1. **Run validation to identify all errors:**
   Run the `/validate` workflow to identify all consistency issues.

2. **Fix errors in priority order:**
   - P0: Missing core files (global_rules.md, SKILLS_MAP.md)
   - P1: Broken skill references
   - P2: Missing skills or workflows
   - P3: Warnings and inconsistencies

3. **Verify each fix:**
   Run the `/validate` workflow again to verify all issues are resolved.

4. **If stuck, restore from last known good state**



---

## Maintenance Schedule Summary

| Frequency | Tasks |
|-----------|-------|
| **Per Change** | Run `/validate` workflow, follow appropriate checklist |
| **Weekly** | Cross-reference audit, documentation review |
| **Monthly** | Comprehensive review, language coverage audit |
| **Quarterly** | Major review, tool updates, documentation refresh |

---

## Contact & Support

For issues with this configuration:
1. Check CHANGE_CHECKLISTS.md for guidance
2. Run `/validate` workflow to identify problems
3. Review this maintenance guide
4. Consult SKILLS_MAP.md for architecture understanding
