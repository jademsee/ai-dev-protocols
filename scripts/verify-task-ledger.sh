#!/bin/bash
# verify-task-ledger.sh
# Validates a task ledger against the standard in docs/TASK_LEDGER.md
#
# Usage: ./scripts/verify-task-ledger.sh [path/to/task-ledger.md]
#        (default: docs/process/task-ledger.md)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

LEDGER="${1:-$PROJECT_ROOT/docs/process/task-ledger.md}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
ROWS=0
HEADER_OK=false
SEEN_TASKS=""

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    PASS=$((PASS + 1))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    FAIL=$((FAIL + 1))
}

trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

echo -e "${BLUE}=== Task Ledger Verification ===${NC}"
echo "Ledger: $LEDGER"
echo ""

if [[ ! -f "$LEDGER" ]]; then
    check_fail "Ledger not found: $LEDGER"
    echo ""
    echo -e "${RED}ACTION REQUIRED: Create the ledger or pass its path${NC}"
    exit 1
fi

while IFS= read -r raw || [[ -n "$raw" ]]; do
    # Normalize CRLF line endings
    line="$(printf '%s' "$raw" | tr -d '\r')"

    # Only table rows matter
    if [[ "${line:0:1}" != "|" ]]; then
        continue
    fi

    # Header row: | Task | Status | Note | Evidence |
    compact="$(printf '%s' "$line" | tr -d ' ')"
    if [[ "$compact" == "|Task|Status|Note|Evidence|" ]]; then
        HEADER_OK=true
        continue
    fi

    # Separator row: | --- | --- | ...
    if [[ "$line" =~ ^\|[[:space:]:|-]+\|[[:space:]]*$ ]]; then
        continue
    fi

    # Data row: split into columns
    IFS='|' read -r _ task status note evidence _ <<< "$line"
    task="$(trim "$task")"
    status="$(trim "$status")"
    note="$(trim "$note")"
    evidence="$(trim "$evidence")"
    ROWS=$((ROWS + 1))

    if [[ -z "$task" ]]; then
        check_fail "Row $ROWS: missing task ID"
        continue
    fi

    if [[ -n "$SEEN_TASKS" ]] \
        && printf '%s\n' "$SEEN_TASKS" | grep -Fqx "$task"; then
        check_fail "Row $ROWS: duplicate task ID '$task'"
    else
        SEEN_TASKS+="$task"$'\n'
    fi

    case "$status" in
        in-progress|blocked|done) ;;
        *)
            check_fail "Row $ROWS ($task): invalid status '$status'\
 (must be in-progress, blocked, or done)"
            ;;
    esac

    if [[ "$status" == "done" && -z "$evidence" ]]; then
        check_fail "Row $ROWS ($task): done without evidence"
    fi

    if [[ "$status" != "done" && -z "$note" ]]; then
        check_fail "Row $ROWS ($task): open row without note"
    fi
done < "$LEDGER"

echo ""

if [[ "$HEADER_OK" != true ]]; then
    check_fail "Table header '| Task | Status | Note | Evidence |' not found"
else
    check_pass "Header format is correct"
fi

if [[ $ROWS -eq 0 ]]; then
    echo -e "${YELLOW}⚠${NC} Ledger has no task rows (sparse: no task started)"
else
    check_pass "$ROWS task row(s) checked for vocabulary, evidence, and notes"
fi

echo ""
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"

if [[ $FAIL -gt 0 ]]; then
    echo ""
    echo -e "${RED}ACTION REQUIRED: Fix ledger drift before continuing work${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Task ledger is valid.${NC}"
exit 0
