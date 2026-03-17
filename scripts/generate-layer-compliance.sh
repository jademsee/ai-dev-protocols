#!/bin/bash
# Generate architecture layer compliance visualization in Mermaid format
# Usage: ./generate-layer-compliance.sh [config_file]
# Output: Mermaid graph to stdout

set -e

CONFIG_FILE="${1:-.dependency-cruiser.js}"

# Default layer rules if no config exists
# Format: "layer_name:allowed_dependencies"
DEFAULT_RULES=(
    "domain:none"
    "application:domain"
    "infrastructure:application,domain"
    "presentation:application,infrastructure"
)

# Detect if dependency-cruiser is available
if [ -f "$CONFIG_FILE" ] && command -v npx &> /dev/null; then
    # Use dependency-cruiser for compliance check
    npx dependency-cruiser --validate --output-type mmd "$CONFIG_FILE" 2>/dev/null
    exit $?
fi

# Fallback: manual layer detection based on directory structure
echo "graph TD"

# Detect layers from directory structure
LAYERS=$(find . -maxdepth 2 -type d \( -name "domain" -o -name "application" -o -name "infrastructure" -o -name "presentation" -o -name "core" -o -name "api" -o -name "services" -o -name "web" -o -name "cli" \) 2>/dev/null | sort)

# Map directories to layers
declare -A layer_modules

for layer_path in $LAYERS; do
    layer_name=$(basename "$layer_path")
    layer_modules[$layer_name]="$layer_path"
done

# Output layer subgraphs
for layer_path in $LAYERS; do
    layer_name=$(basename "$layer_path")
    echo "    subgraph \"${layer_name^} Layer\""
    
    # List modules in this layer
    find "$layer_path" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" \) 2>/dev/null | head -5 | while read -r file; do
        module=$(basename "$file" | sed 's/\.[^.]*$//')
        echo "        ${layer_name}_${module}[$module]"
    done
    
    echo "    end"
done

# Check for violations (imports that break layer rules)
echo ""
echo "    %% Checking for layer violations..."

# Simple violation detection
# This is a basic implementation - use dependency-cruiser for comprehensive checks
while IFS= read -r file; do
    module_dir=$(dirname "$file" | sed 's|.*/||')
    
    case "$module_dir" in
        domain)
            # Domain should not import from infrastructure or presentation
            if grep -qE "import.*(infrastructure|presentation|api|web)" "$file" 2>/dev/null; then
                echo "    DOMAIN_MODULE -.->|❌ VIOLATION| INFRA_MODULE"
            fi
            ;;
        application)
            # Application should not import from presentation
            if grep -qE "import.*(presentation|web|api)" "$file" 2>/dev/null; then
                echo "    APP_MODULE -.->|❌ VIOLATION| PRES_MODULE"
            fi
            ;;
    esac
done < <(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) 2>/dev/null | head -20)

echo ""
echo "    %% Legend: Solid lines = allowed, Dashed red = violations"
