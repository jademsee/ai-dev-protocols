---
name: manage-git
description: Manage the full Git lifecycle, including initializing repositories, staging changes, creating descriptive commits, and resolving merge conflicts
---

# SKILL: Git

## Trigger
When asked to commit, branch, merge, rebase, tag, resolve
conflicts, write commit messages, prepare a PR, clean up
history, or perform any git operation.

## Core Principle
Git history is a first-class artifact. Every commit must be:
- **Atomic** — one logical change per commit
- **Correct** — tests pass at every commit
- **Readable** — future developers can understand WHY from
  the message alone
- **Reversible** — every commit can be safely reverted

---

## MODE 1: Commit

### Trigger phrase
"Commit...", "Stage and commit...", "Write a commit message..."

### Process
1. Run `git diff --staged` and `git status` — read the full diff
2. Verify the change is atomic — one logical concern only
3. Verify tests pass before committing
4. Write the commit message (see format below)
5. WAIT for approval on the message before committing
6. Stage exactly the right files — never use `git add .`
   without reviewing what's being staged
7. Commit

### Quick Commit Message Generation

**Trigger:** "Generate a commit message", "One line commit message", "Git message"

**Process:**
1. Run `git diff --staged` and `git status` — read the full diff
2. Detect the project's commit convention from last 20 commits
3. Generate ONE line following the detected convention
4. Output ONLY the commit message — no explanations

**Output Format:**
```
<type>(<scope>): <subject>
```

**Rules:**
- 50 characters max for subject
- Imperative mood: "add", "fix", "remove" — not "added", "fixes"
- No period at the end
- Lowercase after the colon
- Infer type from change:
  - New functionality → `feat`
  - Bug fix → `fix`
  - Performance → `perf`
  - Restructuring → `refactor`
  - Tests → `test`
  - Documentation → `docs`
  - Build/deps/tooling → `chore`
  - CI/CD → `ci`
- Infer scope from affected module/directory

**Examples:**
```
feat(auth): add refresh token rotation
fix(payments): prevent double-charge on retry
refactor(skills): add Related Skills sections to all skills
docs(readme): update workflow count to 9
chore(deps): update dependencies to latest versions
test(api): add endpoint tests for user service
```

### Commit Message Format

**FIRST: Detect the project's existing convention**
Read the last 20 commits (`git log --oneline -20`) to identify the existing commit message pattern:
- Conventional Commits: `type(scope): subject`
- Ticket-first: `PROJ-123: subject` or `[PROJ-123] subject`
- Simple: Just a subject line
- Squash-merge workflow: May use any format if commits are squashed

**Use the detected convention. If no convention is established, default to Conventional Commits:**

```
<type>(<scope>): <subject>

[body — required if change is non-obvious]

[footer — required for breaking changes or issue refs]
```

**Types (for Conventional Commits):**
- `feat` — new feature (triggers minor version bump)
- `fix` — bug fix (triggers patch version bump)
- `perf` — performance improvement
- `refactor` — code change that neither fixes a bug nor adds a feature
- `test` — adding or correcting tests
- `docs` — documentation only
- `chore` — build process, tooling, dependencies
- `ci` — CI/CD configuration
- `revert` — reverts a previous commit

**Subject line rules:**
- 50 characters max
- Imperative mood: "add", "fix", "remove" — not "added", "fixes"
- No period at the end
- Lowercase after the colon

**Body rules:**
- Wrap at 72 characters
- Explain WHAT changed and WHY — not HOW (the diff shows how)
- Required when: the change is non-obvious, there are tradeoffs,
  or context will be lost without it

**Footer rules:**
- Breaking changes: `BREAKING CHANGE: <description>`
- Issue references: `Closes #123`, `Fixes #456`
- Co-authors: `Co-authored-by: Name <email>`

**Good examples:**
```
feat(auth): add refresh token rotation

Rotating refresh tokens on each use prevents token theft from
going undetected. Old token is invalidated immediately on use.

Closes #234
```

```
fix(payments): prevent double-charge on retry

Race condition between retry logic and webhook handler caused
duplicate charges when network timed out. Added idempotency
key check before processing.

Fixes #891
```

```
perf(query): replace N+1 with single JOIN in user feed

Feed was issuing one query per post to load author data.
Replaced with eager load via LEFT JOIN. Reduces queries from
O(n) to O(1) for typical feed sizes.
```

**Bad examples (never do these):**
```
fix stuff           ← no scope, no description
WIP                 ← never commit WIP to shared branches
Fixed the bug       ← past tense, no context
Update files        ← meaningless
```

### Hard Rules
- NEVER commit with `--no-verify` (skips hooks)
- NEVER commit directly to `main` or `master`
- NEVER include unrelated changes in a single commit
- NEVER commit secrets, tokens, credentials, or `.env` files
- NEVER commit generated files that belong in `.gitignore`
- NEVER use `git add .` without reviewing the staged diff first

---

## MODE 2: Branch

### Trigger phrase
"Create a branch...", "Branch for...", "Start work on..."

### Process
1. Confirm the base branch (usually `main` or `develop`)
2. Pull latest from base before branching
3. Name the branch following convention (see below)
4. Create and check out the branch
5. Confirm clean working state before starting work

### Branch Naming Convention
```
<type>/<ticket-id>-<short-description>
```
- `feat/AUTH-123-refresh-token-rotation`
- `fix/PAY-891-double-charge-on-retry`
- `chore/update-node-20`
- `release/v2.3.0`
- `hotfix/critical-auth-bypass`

Rules:
- All lowercase, hyphens only (no underscores, no spaces)
- Include ticket/issue ID when one exists
- Description must be readable without context
- Max 60 characters total

### Branch Lifetime Rules
- Feature branches: delete after merge
- Release branches: tag then delete after merge
- Hotfix branches: merge to both `main` and `develop`, then delete
- Never let branches live longer than one sprint without merging
  or rebasing

---

## MODE 3: Merge & Rebase

### Trigger phrase
"Merge...", "Rebase...", "Integrate...", "Update my branch..."

### Decision: Merge vs Rebase

**Use rebase when:**
- Updating a feature branch with latest from main
- Cleaning up local commits before opening a PR
- History should be linear

**Use merge when:**
- Merging a completed feature into main/develop
- Preserving the exact history of a branch is important
- Resolving conflicts on a shared branch

**Never rebase:**
- Branches that others are working on
- After a branch has been pushed and a PR is open
  (force-push breaks reviewers' local state)
- `main`, `master`, `develop`

### Rebase Process
```
git fetch origin
git rebase origin/main
# resolve conflicts if any — see MODE 5
git rebase --continue
# verify tests pass
git push --force-with-lease  # not --force
```

### Merge Process
```
git fetch origin
git checkout main
git merge --no-ff feat/AUTH-123-refresh-token-rotation
# --no-ff preserves branch history in a merge commit
```

---

## MODE 4: Pull Request Preparation

### Trigger phrase
"Prepare a PR...", "Get this ready for review...",
"Clean up before PR..."

### Process
1. Run the full test suite — must be GREEN
2. Review own diff: `git diff main...HEAD`
3. Clean up commit history if needed (see MODE 6)
4. Rebase onto latest main
5. Verify CI would pass
6. Write the PR description (see format below)
7. Self-review using code-review.md skill before requesting
   others to review

### PR Description Format
```markdown
## What
[1-2 sentences: what this PR does]

## Why
[Why this change is needed — link to issue/ticket]

## How
[Brief summary of the approach taken and any key decisions]

## Testing
[How this was tested — unit, integration, manual steps]

## Screenshots / Logs
[If UI change or output change — before/after]

## Checklist
- [ ] Tests pass
- [ ] No new lint errors
- [ ] Documentation updated if needed
- [ ] No secrets or debug code committed
- [ ] Breaking changes documented
```

### PR Hard Rules
- Max 400 lines changed per PR — split larger changes
- One concern per PR — no "while I was in there" changes
- Every PR must have at least one test change unless
  it is docs/chore only
- Draft PRs for work-in-progress — never open a ready PR
  for unfinished work

---

## MODE 5: Conflict Resolution

### Trigger phrase
"Resolve conflicts...", "There are merge conflicts..."

### Process
1. List all conflicted files: `git diff --name-only --diff-filter=U`
2. For each conflicted file:
   a. Read the full conflict including both sides and base
   b. Understand WHAT each side was trying to do and WHY
   c. Resolve by preserving the intent of BOTH sides where possible
   d. If one side should win entirely, explain why in a comment
3. After resolving all files, run the full test suite
4. Commit the resolution with a clear message explaining
   any non-obvious choices

### Conflict Resolution Rules
- NEVER blindly accept "ours" or "theirs" — read both sides
- NEVER resolve a conflict without running tests after
- If unsure which side is correct, STOP and ask — do not guess
- Document non-obvious resolutions in the commit message body

---

## MODE 6: History Cleanup (Interactive Rebase)

### Trigger phrase
"Clean up commits...", "Squash...", "Tidy history before PR..."

### Process
1. Count commits to clean: `git log main..HEAD --oneline`
2. Start interactive rebase: `git rebase -i main`
3. Apply these rules to the commit list:
   - `pick` — keep as-is (first commit, or clean commits)
   - `squash` / `fixup` — merge into previous commit
     (WIP, typo fixes, "oops" commits)
   - `reword` — keep change, fix the message
   - `edit` — pause to amend the commit
   - `drop` — remove entirely (dead code, reverted changes)
4. Ensure resulting history is atomic — each commit passes tests
5. Verify final log before force-pushing

### What to Squash
- Commits with messages like "fix", "wip", "oops", "typo"
- Multiple commits that are logically one change
- "Addressed review comments" commits — squash into the
  original commit they fix

### What to Keep Separate
- Refactors that preceded a feature — keep as own commit
- Dependency updates — keep as own commit
- Config changes — keep as own commit
- Each logical feature increment — keep separate

### Hard Rules
- NEVER rebase commits that have been pushed to a shared branch
- NEVER squash commits that are already in main/develop
- Always use `--force-with-lease` not `--force` after rebase

---

## MODE 7: Tagging & Releases

### Trigger phrase
"Tag this release...", "Cut a release...", "Version bump..."

### Process
1. Confirm all tests pass on the release commit
2. Generate changelog from commits since last tag
3. Create an annotated tag (not lightweight):
   ```
   git tag -a v2.3.0 -m "Release v2.3.0
   
   [changelog summary]"
   ```
4. Push tag explicitly: `git push origin v2.3.0`
5. Never push all tags blindly: never `git push --tags`

### Versioning — follow Semantic Versioning (SemVer)
- `MAJOR.MINOR.PATCH`
- PATCH: `fix` commits — backwards-compatible bug fixes
- MINOR: `feat` commits — backwards-compatible new features
- MAJOR: `BREAKING CHANGE` in footer — incompatible API changes
- Pre-release: `v2.3.0-beta.1`, `v2.3.0-rc.1`

---

## Slash Commands

```
/commit         Stage and commit current changes following
                MODE 1. Read the diff first, write a
                Conventional Commit message, wait for approval.

/commit-quick   Commit staged changes with minimal ceremony.
                Still follows message format — just skips
                the options/approval step for trivial changes.

/branch [name]  Create a branch following MODE 2 naming
                convention. Pull latest from main first.

/pr-prep        Run MODE 4. Clean history, rebase onto main,
                write PR description. Do not open the PR —
                present the description for approval.

/history        Show git log --oneline for current branch
                vs main. Identify any commits that should
                be cleaned up before PR.

/cleanup        Run MODE 6 interactive rebase plan.
                List which commits to squash/reword/drop
                and why. Wait for approval before executing.

/conflicts      Run MODE 5. List all conflicted files,
                resolve each one, run tests, then commit.

/tag [version]  Run MODE 7. Generate changelog, create
                annotated tag, confirm before pushing.
```

---

## Related Skills
- **write-tests** — Verify tests pass before committing
- **maintain-consistency** — Ensure all related files updated together
- **debug** — Investigate failing tests before commit

## Pre-Operation Checklist

Before any git operation that modifies shared history:
- [ ] On the correct branch
- [ ] Working tree is clean (or changes are intentionally staged)
- [ ] Latest remote changes have been fetched
- [ ] Tests pass at the current HEAD
- [ ] Not rebasing a branch others are working on

## Hard Rules Summary
- NEVER commit directly to main/master/develop
- NEVER commit secrets or credentials
- NEVER use `--force` — always `--force-with-lease`
- NEVER rebase shared branches
- NEVER commit with failing tests
- NEVER use `git add .` without reviewing the staged diff
- NEVER skip commit hooks with `--no-verify`
- NEVER open a PR larger than 400 lines without splitting it
