#!/bin/bash
# verify-secret-protection.sh
# Verifies that secret protection measures are properly configured
#
# Usage: ./scripts/verify-secret-protection.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
WARN=0

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    PASS=$((PASS + 1))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    FAIL=$((FAIL + 1))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARN=$((WARN + 1))
}

echo -e "${BLUE}=== Secret Protection Verification ===${NC}"
echo "Project: $PROJECT_ROOT"
echo ""

# 1. Check .gitignore has secret patterns
echo -e "${BLUE}[1] .gitignore Configuration${NC}"
if grep -q "^\.env$" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
    check_pass ".env is in .gitignore"
else
    check_fail ".env is NOT in .gitignore"
fi

if grep -q "\.pem" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
    check_pass "*.pem pattern in .gitignore"
else
    check_fail "*.pem pattern missing from .gitignore"
fi

if grep -q "\.env\.schema" "$PROJECT_ROOT/.gitignore" 2>/dev/null && grep -q "!\.env\.schema" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
    check_pass ".env.schema is allowed (not ignored)"
else
    check_warn ".env.schema allow pattern may be missing"
fi

echo ""

# 2. Check schema file exists
echo -e "${BLUE}[2] Schema File${NC}"
if [[ -f "$PROJECT_ROOT/.env.schema" ]]; then
    check_pass ".env.schema exists"
else
    check_fail ".env.schema does not exist"
fi

echo ""

# 3. Check gitleaks configuration
echo -e "${BLUE}[3] Gitleaks Configuration${NC}"
if [[ -f "$PROJECT_ROOT/.gitleaks.toml" ]]; then
    check_pass ".gitleaks.toml exists"
else
    check_warn ".gitleaks.toml not found (using default rules)"
fi

if command -v gitleaks &> /dev/null; then
    check_pass "gitleaks is installed"
    
    # Run gitleaks detection
    cd "$PROJECT_ROOT"
    if gitleaks detect --no-git -q 2>/dev/null; then
        check_pass "No secrets detected by gitleaks"
    else
        check_fail "Gitleaks detected potential secrets"
    fi
else
    check_warn "gitleaks not installed - run: brew install gitleaks"
fi

echo ""

# 4. Check pre-commit configuration
echo -e "${BLUE}[4] Pre-commit Hooks${NC}"
if [[ -f "$PROJECT_ROOT/.pre-commit-config.yaml" ]]; then
    check_pass ".pre-commit-config.yaml exists"
else
    check_warn ".pre-commit-config.yaml not found"
fi

if [[ -f "$PROJECT_ROOT/.git/hooks/pre-commit" ]]; then
    check_pass "pre-commit hook is installed"
else
    check_warn "pre-commit hook not installed - run: pre-commit install"
fi

echo ""

# 5. Check file permissions (Unix only)
echo -e "${BLUE}[5] File Permissions${NC}"
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" ]]; then
    if [[ -f "$PROJECT_ROOT/.env" ]]; then
        perms=$(stat -c %a "$PROJECT_ROOT/.env" 2>/dev/null || stat -f %OLp "$PROJECT_ROOT/.env" 2>/dev/null)
        if [[ "$perms" == "600" || "$perms" == "400" ]]; then
            check_pass ".env permissions are restrictive ($perms)"
        else
            check_warn ".env permissions ($perms) should be 600 or stricter"
        fi
    else
        echo "  .env not found (expected for new projects)"
    fi
else
    echo "  Skipped on Windows"
fi

echo ""

# 6. Check for actual secret files (should not exist or be ignored)
echo -e "${BLUE}[6] Secret File Check${NC}"
if [[ -f "$PROJECT_ROOT/.env" ]]; then
    if git -C "$PROJECT_ROOT" check-ignore .env 2>/dev/null; then
        check_pass ".env exists and is gitignored"
    else
        check_fail ".env exists but is NOT gitignored!"
    fi
else
    echo "  .env not found (OK for new projects)"
fi

# Check for secrets in tracked files
TRACKED_SECRETS=$(git -C "$PROJECT_ROOT" ls-files 2>/dev/null | grep -E "(secrets\.|\.pem$|\.key$)" || true)
if [[ -n "$TRACKED_SECRETS" ]]; then
    check_fail "Secret files are tracked: $TRACKED_SECRETS"
else
    check_pass "No secret files tracked in git"
fi

echo ""

# 7. Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "Passed:   ${GREEN}$PASS${NC}"
echo -e "Failed:   ${RED}$FAIL${NC}"
echo -e "Warnings: ${YELLOW}$WARN${NC}"

if [[ $FAIL -gt 0 ]]; then
    echo ""
    echo -e "${RED}ACTION REQUIRED: Fix failed checks before committing${NC}"
    exit 1
elif [[ $WARN -gt 0 ]]; then
    echo ""
    echo -e "${YELLOW}RECOMMENDED: Address warnings to improve security${NC}"
    exit 0
else
    echo ""
    echo -e "${GREEN}All checks passed! Secret protection is properly configured.${NC}"
    exit 0
fi
