#!/bin/bash
# Generate module coupling heatmap in Mermaid format
# Usage: ./generate-coupling-heatmap.sh [src_dir]
# Output: Mermaid graph to stdout

set -e

SRC_DIR="${1:-src}"

echo "graph TD"

# Collect import data
declare -A imports
declare -A imported_by

# Find all source files and analyze imports
while IFS= read -r file; do
    module=$(dirname "$file" | sed "s|$SRC_DIR/||" | sed 's|/|_|g')
    
    if [ -z "$module" ] || [ "$module" = "$SRC_DIR" ]; then
        module=$(basename "$file" | sed 's/\.[^.]*$//')
    fi
    
    # Extract imports based on file type
    case "$file" in
        *.js|*.ts)
            deps=$(grep -oE "from ['\"][^'\"./][^'\"]*['\"]" "$file" 2>/dev/null | sed "s/from ['\"]//;s/['\"]$//" | grep -v "^\." | cut -d'/' -f1 | sort -u)
            ;;
        *.py)
            deps=$(grep -oE "^(import|from) [a-zA-Z_]+" "$file" 2>/dev/null | awk '{print $2}' | grep -v "^\." | sort -u)
            ;;
        *.go)
            deps=$(grep -oE 'import "[^"]+"' "$file" 2>/dev/null | sed 's/import "//;s/"$//' | sort -u)
            ;;
        *.java)
            deps=$(grep -oE 'import [a-zA-Z0-9_.]+' "$file" 2>/dev/null | awk '{print $2}' | cut -d'.' -f1 | sort -u)
            ;;
        *)
            deps=""
            ;;
    esac
    
    for dep in $deps; do
        # Count coupling
        key="${module}→${dep}"
        imports[$key]=$((${imports[$key]:-0} + 1))
    done
    
done < <(find "$SRC_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" \) 2>/dev/null)

# Calculate coupling metrics per module
declare -A afferent   # Ca: how many depend on this
declare -A efferent   # Ce: how many this depends on

for key in "${!imports[@]}"; do
    count="${imports[$key]}"
    source=$(echo "$key" | cut -d'→' -f1)
    target=$(echo "$key" | cut -d'→' -f2)
    
    efferent[$source]=$((${efferent[$source]:-0} + 1))
    afferent[$target]=$((${afferent[$target]:-0} + 1))
done

# Group by coupling level
high_coupling=""
moderate_coupling=""
low_coupling=""

for module in $(echo "${!afferent[@]} ${!efferent[@]}" | tr ' ' '\n' | sort -u); do
    ca="${afferent[$module]:-0}"
    ce="${efferent[$module]:-0}"
    total=$((ca + ce))
    
    if [ "$total" -eq 0 ]; then
        continue
    fi
    
    # Calculate instability: Ce / (Ca + Ce)
    instability=$(echo "scale=2; $ce / ($ca + $ce)" | bc 2>/dev/null || echo "0")
    
    # Categorize
    if [ "$total" -ge 15 ]; then
        high_coupling="$high_coupling $module"
    elif [ "$total" -ge 8 ]; then
        moderate_coupling="$moderate_coupling $module"
    else
        low_coupling="$low_coupling $module"
    fi
done

# Output Mermaid graph
if [ -n "$high_coupling" ]; then
    echo "    subgraph \"High Coupling (15+ connections)\""
    for module in $high_coupling; do
        ca="${afferent[$module]:-0}"
        ce="${efferent[$module]:-0}"
        echo "        ${module}[${module}<br/>Ca: $ca, Ce: $ce]"
    done
    echo "    end"
fi

if [ -n "$moderate_coupling" ]; then
    echo "    subgraph \"Moderate Coupling\""
    for module in $moderate_coupling; do
        ca="${afferent[$module]:-0}"
        ce="${efferent[$module]:-0}"
        echo "        ${module}[${module}<br/>Ca: $ca, Ce: $ce]"
    done
    echo "    end"
fi

if [ -n "$low_coupling" ]; then
    echo "    subgraph \"Low Coupling (Stable)\""
    for module in $low_coupling; do
        ca="${afferent[$module]:-0}"
        ce="${efferent[$module]:-0}"
        echo "        ${module}[${module}<br/>Ca: $ca, Ce: $ce]"
    done
    echo "    end"
fi

# Add top connections
echo ""
echo "    %% Top connections"

for key in "${!imports[@]}"; do
    count="${imports[$key]}"
    if [ "$count" -ge 5 ]; then
        source=$(echo "$key" | cut -d'→' -f1)
        target=$(echo "$key" | cut -d'→' -f2)
        echo "    $source -->|${count} connections| $target"
    fi
done

# Style high coupling as red
if [ -n "$high_coupling" ]; then
    for module in $high_coupling; do
        echo "    style $module fill:#ff6b6b,stroke:#c92a2a"
    done
fi
