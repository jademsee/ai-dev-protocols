# Improvement Loop Protocol

When running an improvement loop:

---

## Loop Structure (each iteration)

1. Run existing tests — report pass/fail count
2. If RED: fix failures first, minimal change only, then restart loop
3. If GREEN: identify the single highest-impact improvement using this priority order:
   - Correctness issues first
   - Concurrency/race conditions second
   - Performance in hot paths third
   - Clarity or structure last
4. Propose 2-3 options for that improvement with tradeoffs
5. Wait for approval before implementing (unless Turbo Mode is explicitly requested)
6. Implement selected option
7. Run tests again — verify still GREEN
8. Report: what changed, why, and what the next candidate is
9. Repeat

---

## Loop Stop Conditions (exit normally when any are true)

- 3 consecutive GREEN iterations with no improvements found
- All known correctness issues resolved and no performance regressions remain
- Explicit "STOP" from user

---

## Hard Stops — exit loop IMMEDIATELY and report why

- A change would modify a public interface or API contract
- A change would add a new dependency
- A change would delete or weaken existing tests
- The same fix has been attempted twice without success
- Correctness under concurrency cannot be confirmed
- A change would touch more than 3 files not in the original scope
- Turbo Mode is active and test failure count increases by >2

---

## After every iteration, report

- What was changed and in which file(s)
- Why this change fits the existing architecture
- Current test status (pass/fail count)
- Next highest-impact improvement candidate
- Any hard stop conditions that are approaching
