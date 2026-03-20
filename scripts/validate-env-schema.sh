#!/bin/bash
# validate-env-schema.sh
# Validates .env against .env.schema to ensure all required variables are present
#
# Usage:
#   ./scripts/validate-env-schema.sh [env-file]
#   ./scripts/validate-env-schema.sh .env.local

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

SCHEMA="${PROJECT_ROOT}/.env.schema"
ENV_FILE="${1:-${PROJECT_ROOT}/.env}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Environment Schema Validation ==="
echo "Schema: $SCHEMA"
echo "Env:    $ENV_FILE"
echo ""

# Check schema exists
if [[ ! -f "$SCHEMA" ]]; then
    echo -e "${RED}ERROR: .env.schema not found at $SCHEMA${NC}"
    echo "Create a .env.schema file to define required variables."
    exit 1
fi

# Check env file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo -e "${YELLOW}WARNING: .env file not found at $ENV_FILE${NC}"
    echo "This is expected if you haven't set up local environment yet."
    echo "Copy .env.schema to .env and fill in values."
    exit 0
fi

# Parse required variables from schema
# Looks for lines like "VARIABLE_NAME:" followed by "required: true"
parse_required_vars() {
    local in_var_block=false
    local current_var=""
    local is_required=false
    
    while IFS= read -r line; do
        # Detect variable name (indented, ends with colon)
        if [[ "$line" =~ ^[[:space:]]{2}([A-Z_]+):$ ]]; then
            current_var="${BASH_REMATCH[1]}"
            in_var_block=true
            is_required=false
        # Check for required: true in the same block
        elif [[ "$in_var_block" == true ]]; then
            if [[ "$line" =~ required:[[:space:]]*true ]]; then
                is_required=true
            fi
            # End of variable block (next variable or empty line)
            if [[ "$line" =~ ^[[:space:]]{2}[A-Z_]+:$ ]] || [[ -z "$line" ]]; then
                if [[ "$is_required" == true && -n "$current_var" ]]; then
                    echo "$current_var"
                fi
                if [[ "$line" =~ ^[[:space:]]{2}([A-Z_]+):$ ]]; then
                    current_var="${BASH_REMATCH[1]}"
                    is_required=false
                else
                    in_var_block=false
                fi
            fi
        fi
    done < "$SCHEMA"
}

# Get list of required variables
REQUIRED_VARS=$(parse_required_vars)

if [[ -z "$REQUIRED_VARS" ]]; then
    echo -e "${GREEN}No required variables defined in schema.${NC}"
    echo "All variables are optional or schema has no variables defined yet."
    exit 0
fi

# Check each required variable exists in .env
MISSING=0
FOUND=0

for var in $REQUIRED_VARS; do
    if grep -q "^${var}=" "$ENV_FILE" 2>/dev/null; then
        # Check it's not empty
        value=$(grep "^${var}=" "$ENV_FILE" | cut -d'=' -f2-)
        if [[ -n "$value" && "$value" != '""' && "$value" != "''" ]]; then
            echo -e "${GREEN}✓${NC} $var is set"
            FOUND=$((FOUND + 1))
        else
            echo -e "${YELLOW}⚠${NC} $var is empty"
            MISSING=$((MISSING + 1))
        fi
    else
        echo -e "${RED}✗${NC} $var is missing"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
echo "=== Summary ==="
echo "Found:   $FOUND"
echo "Missing: $MISSING"

if [[ $MISSING -gt 0 ]]; then
    echo -e "${RED}Schema validation FAILED${NC}"
    echo "Add missing variables to $ENV_FILE"
    exit 1
else
    echo -e "${GREEN}Schema validation PASSED${NC}"
    exit 0
fi
