# Skills Relationship Map

This document maps the relationships between skills, their dependencies, and typical invocation patterns.

---

## Skill Categories

### Atomic Skills (No dependencies on other skills)
Skills that operate independently and can be invoked without requiring other skills.

- **debug** - Diagnose and fix software issues
- **write-tests** - Write tests for code
- **write-docs** - Write or update documentation
- **refactor** - Restructure existing code
- **optimize** - Profile and improve performance
- **maintain-consistency** - Ensure all related files, tests, docs, and dependencies stay synchronized
- **manage-dependencies** - Manage project dependencies across their full lifecycle
- **manage-secrets** - Establish secrets management architecture and best practices
- **visualize-project** - Generate visualizations for understanding codebase structure, dependencies, ownership, and architecture
- **analyze-metrics** - Design and implement visualizations for performance, CI/CD health, dev velocity, and user analytics

### Composite Skills (Reference atomic skills in checklists)
Skills that may reference other skills in their pre-submit checklists but don't invoke them directly.

- **develop-api** - Create API endpoints
  - References: write-tests (checklist item)
  - Pattern: Implement endpoint → verify tests exist
  
- **create-item** - Create new modules/files
  - References: write-tests (checklist item)
  - Pattern: Create module → verify tests exist

- **manage-git** - Manage Git operations
  - References: write-tests (verify tests pass before commit)
  - Pattern: Stage changes → verify tests GREEN → commit

### Orchestration Skills (Design and planning)
Skills that analyze, plan, and may recommend other skills in their output.

- **design-architecture** - Design and governance
  - May recommend: Any skill in remediation plans or implementation phases
  - Pattern: Analyze → recommend skill sequence → wait for approval
  
- **recover-design** - Reverse engineer codebase
  - May recommend: write-docs (for missing documentation)
  - Pattern: Analyze → identify gaps → suggest documentation work

- **audit-security** - Security analysis
  - May recommend: refactor, debug (for fixing vulnerabilities)
  - References: manage-secrets (for proactive secrets infrastructure)
  - Pattern: Audit → report findings → propose fixes

---

## Skill Invocation Patterns

### Pattern 1: New Feature Development
```
1. design-architecture (if complex) - Design the feature
2. create-item - Create new modules
3. develop-api (if needed) - Add API endpoints
4. write-tests - Add test coverage
5. write-docs - Document the feature
6. manage-git - Commit the changes
```

### Pattern 2: Bug Fix
```
1. debug - Identify and fix root cause
2. write-tests - Add regression test
3. manage-git - Commit the fix
```

### Pattern 3: Performance Improvement
```
1. optimize - Profile and improve performance
2. write-tests - Verify no correctness regression
3. write-docs - Document performance characteristics
4. manage-git - Commit the optimization
```

### Pattern 4: Refactoring
```
1. refactor - Restructure code
2. write-tests - Verify tests still pass (no new tests needed)
3. manage-git - Commit the refactor
```

### Pattern 5: Security Hardening
```
1. audit-security - Identify vulnerabilities
2. debug or refactor - Fix issues
3. write-tests - Add security regression tests
4. write-docs - Document security measures
5. manage-git - Commit the fixes
```

### Pattern 6: Codebase Onboarding
```
1. recover-design - Understand existing architecture
2. design-architecture - Review coherence (if needed)
3. write-docs - Fill documentation gaps
```

### Pattern 7: API Development
```
1. develop-api - Create endpoint following patterns
2. write-tests - Add endpoint tests
3. write-docs - Document API contract
4. manage-git - Commit the endpoint
```

### Pattern 8: Secrets Management
```
1. manage-secrets - Setup secrets infrastructure
2. audit-security - Verify no leaks remain
3. write-docs - Document procedures and runbooks
4. manage-git - Commit the changes
```

### Pattern 9: Dependency Management
```
1. manage-dependencies - Audit and update dependencies
2. audit-security - Verify no vulnerabilities remain
3. write-tests - Verify no regressions
4. manage-git - Commit the changes
```

---

## Skill Dependencies Matrix

| Skill          | Depends On | Referenced By | Typical Next Step |
|----------------|------------|---------------|-------------------|
| debug          | None       | audit-security | write-tests       |
| write-tests    | None       | develop-api, create-item, optimize, refactor, manage-git | manage-git |
| write-docs     | None       | recover-design, develop-api, create-item | manage-git |
| refactor       | None       | audit-security, design-architecture | maintain-consistency |
| optimize       | None       | design-architecture | write-tests       |
| maintain-consistency | None | All skills | - |
| develop-api    | None       | design-architecture | maintain-consistency |
| create-item    | None       | design-architecture | maintain-consistency |
| manage-git     | None       | All skills    | -                 |
| design-architecture | None  | -             | create-item, develop-api, refactor |
| recover-design | None       | -             | write-docs, design-architecture |
| manage-dependencies | None  | design-architecture, create-item | audit-security |
| manage-secrets | None       | audit-security | write-docs        |
| visualize-project | None   | design-architecture | create-item |
| analyze-metrics | None    | optimize | write-docs |
| audit-security | None       | -             | debug, refactor   |

---

## Hard Rules for Skill Composition

1. **No Circular Dependencies**
   - Skills MUST NOT invoke each other in a circular manner
   - Use workflows to orchestrate multiple skills instead

2. **Checklist References Only**
   - Skills may reference other skills in pre-submit checklists
   - Format: "[ ] Tests written (reference: write-tests skill)"
   - NOT: "Write tests using write-tests.md skill"

3. **Workflows Orchestrate, Skills Execute**
   - Complex multi-skill tasks should use workflows
   - Skills remain focused on single responsibility

4. **Atomic Skills First**
   - Always prefer atomic skills over composite ones when possible
   - Composite skills should only add domain-specific context

---

## When to Use Workflows vs Skills

### Use a Workflow When:
- Task requires multiple skills in sequence
- Task has approval gates between steps
- Task has different execution modes (turbo, loop, etc.)
- Task is a common pattern worth codifying

### Use a Skill Directly When:
- Task maps to a single skill's responsibility
- No orchestration needed
- One-time or ad-hoc operation

---

## Skill Selection Guide

**"I need to..."** → **Use this skill:**

- Fix a bug → `debug`
- Add tests → `write-tests`
- Write documentation → `write-docs`
- Clean up code → `refactor`
- Speed up code → `optimize`
- Create new file/module → `create-item`
- Add API endpoint → `develop-api`
- Commit changes → `manage-git`
- Design a feature → `design-architecture`
- Understand codebase → `recover-design`
- Check security → `audit-security`
- Ensure everything stays synchronized → `maintain-consistency`
- Setup or migrate secrets → `manage-secrets`
- Manage or audit dependencies → `manage-dependencies`
- Validate project integrity → `maintain-consistency` + `/validate` workflow
- Design codebase visualizations → `visualize-project`
- Design metrics dashboards → `analyze-metrics`

---

## Integration with Workflows

Workflows can invoke skills explicitly. Example workflow patterns:

### `/loop` workflow + skills
```
Loop iteration:
1. Identify improvement (design-architecture skill mindset)
2. Implement fix (debug/refactor/optimize skill)
3. Verify tests (write-tests skill mindset)
4. Repeat
```

---

## Sub-Agent Delegation by Skill

Some skills benefit from sub-agent delegation for improved quality and context management.

### Skills That Benefit from Delegation

| Skill | Delegate To | Trigger |
|-------|-------------|---------|
| **debug** | Search agent | Locating bug across >3 files |
| **debug** | Validation agent | Verifying fix correctness |
| **write-tests** | Generation agent | Boilerplate test generation |
| **write-docs** | Generation agent | API documentation from signatures |
| **refactor** | Search agent | Finding all references to rename |
| **refactor** | Validation agent | Verifying behavior preservation |
| **audit-security** | Search agent | Scanning for vulnerability patterns |
| **audit-security** | Validation agent | Independent security review |
| **design-architecture** | Analysis agent | Impact analysis across modules |
| **recover-design** | Analysis agent | Pattern extraction from codebase |
| **maintain-consistency** | Search agent | Finding all related files |

### Skills That Should NOT Delegate

| Skill | Reason |
|-------|--------|
| **create-item** | Requires user interaction for decisions |
| **develop-api** | Needs conversation context for requirements |
| **manage-git** | Single-file, user-interactive |
| **manage-secrets** | Security-sensitive, needs main agent oversight |

### Using `/delegate` Workflow

When a task matches delegation criteria, use the `/delegate` workflow:

```
/delegate [task description] to [sub-agent type]
```

Example:
```
/delegate "find all usages of AuthService" to search
```

---

## Maintenance Notes

When adding a new skill:
1. Classify it: Atomic, Composite, or Orchestration
2. Document what it references (if any)
3. Update the dependency matrix
4. Add to the skill selection guide
5. Consider if it needs a workflow companion
6. Follow CHANGE_CHECKLISTS.md → Checklist 1
