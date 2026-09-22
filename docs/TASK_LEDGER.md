# Task Ledger Standard

<!-- Enforced by: scripts/verify-task-ledger.sh -->

## Purpose

A task ledger is the durable, cross-session record of plan-driven work.
It serves three purposes:

1. **Write-ahead intent** — an `in-progress` row exists before files
   are touched, so a sudden interruption is discoverable, never silent
   (rules.md → `[IF autonomous]`).
2. **Recovery point** — open rows plus `git diff` establish exactly
   what was in flight when resuming (rules.md → On Recovery).
3. **Audit trail** — `done` rows with evidence survive as history;
   rows are never deleted.

## Location and Adoption

- Path (per adopting project): `docs/process/task-ledger.md`
- A project *defines* a ledger by creating this file alongside an
  implementation plan; agents then follow it per rules.md →
  On Task Start (item 5).
- The table is sparse: a task with no row has not been started.

## Format

```markdown
| Task | Status | Note | Evidence |
|------|--------|------|----------|
| T-P1-B05 | done | | a1b2c3d |
| T-P1-B06 | in-progress | Wiring exit-evidence checks | |
| T-P2-C01 | blocked | Awaiting schema decision from owner | |
```

- One row per plan task; never delete rows.
- No raw `|` inside cells (breaks column parsing).
- Task IDs come from the implementation plan; when the plan does not
  define them, derive as `T-<section>-<n>`.
- Commits and PR titles carry the task ID, so
  `git log --grep "T-P1-B06"` cross-checks the ledger against history.

## Status Vocabulary (closed set)

| Status | Meaning | Required field |
|--------|---------|----------------|
| `in-progress` | work started, in flight | Note: what is in flight |
| `blocked` | cannot proceed | Note: why + what unblocks |
| `done` | completed and validated | Evidence: commit SHA, PR number, or closing artifact |

## Update Semantics

- **Start (write-ahead):** add the `in-progress` row *before* touching
  files, with a Note saying what is in flight.
- **Block:** set status to `blocked`; update the Note with why the task
  is stuck and what would unblock it. Keep the row open.
- **Close:** set status to `done` only after validation passes, with
  Evidence naming the commit SHA, PR, or closing artifact. Never close
  on intent — close on verification.
- **Recover:** on resume, reconcile open rows against the working tree
  and last commit; either complete or revert, then record the outcome.

## Validation

```bash
./scripts/verify-task-ledger.sh [path/to/task-ledger.md]
# default path: docs/process/task-ledger.md
```

Machine-checked (script exits 1 on any failure):
- Header is exactly `| Task | Status | Note | Evidence |`
- Status values are within the closed vocabulary
- `done` rows carry Evidence
- Open rows (`in-progress`, `blocked`) carry a Note
- No duplicate task IDs

Human-reviewed (requires plan context the script lacks):
- Ghost tasks — rows whose IDs do not appear in the plan
- Ordering — work started behind an unfinished earlier task
- Evidence accuracy — the SHA/PR actually closes the task

## Template

```markdown
# Task Ledger

<!-- Source of truth for in-flight plan work. See docs/TASK_LEDGER.md
     for the standard. Validated by scripts/verify-task-ledger.sh. -->

| Task | Status | Note | Evidence |
|------|--------|------|----------|
```
