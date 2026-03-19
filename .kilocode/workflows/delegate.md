---
description: Delegate a task to a specialized sub-agent
---

# /delegate

Explicitly delegate a well-defined task to a sub-agent for isolated execution.

## When to Use

- Task is well-defined with clear input/output
- Task benefits from context isolation
- Parallel execution would improve efficiency
- Specialized prompting would improve quality

## Steps

1. **Analyze task suitability**
   - Is the task self-contained?
   - Does it require user interaction?
   - Is context isolation beneficial?

2. **Identify target sub-agent type**
   - Search: File/content location
   - Validation: Code review, security check
   - Generation: Tests, docs, boilerplate
   - Analysis: Impact, dependencies, architecture

3. **Prepare delegation context**
   - State clear objective
   - Provide minimal necessary files
   - Specify expected output format

4. **Invoke sub-agent**
   - Execute with isolated context
   - Monitor for timeout or failure

5. **Synthesize result**
   - Integrate findings into main context
   - Verify output completeness
   - Fall back to main agent if needed

## Output Format

```markdown
## Delegation Report

**Task:** [delegated task description]
**Sub-Agent:** [search/validation/generation/analysis]
**Input:** [files/context provided]
**Output:** [summary of findings/result]
**Status:** [success/partial/failed]
```

## Failure Recovery

- Timeout → Fall back to main agent
- Incomplete → Re-invoke with clearer objective
- Context mismatch → Enrich prompt and retry
