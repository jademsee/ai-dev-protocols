#!/bin/bash
# Create onboarding guide with codebase visualizations
# Usage: ./create-onboarding-guide.sh [output_file]
# Output: Markdown document to stdout

set -e

OUTPUT_FILE="${1:-docs/ONBOARDING_GUIDE.md}"
PROJECT_NAME=$(basename "$(pwd)")

cat << 'HEADER'
# Onboarding Guide

HEADER

echo "## Project: $PROJECT_NAME"
echo ""
echo "Generated: $(date '+%Y-%m-%d')"
echo ""

# Add executive summary
echo "## Quick Start"
echo ""
echo "### Key Modules to Understand First"
echo ""

# Find modules with good documentation and low complexity
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" \) 2>/dev/null | head -10 | while read -r file; do
    doc_lines=$(grep -c "//\|#\|/\*" "$file" 2>/dev/null || echo 0)
    total_lines=$(wc -l < "$file" 2>/dev/null || echo 1)
    
    if [ "$total_lines" -gt 0 ]; then
        doc_ratio=$((doc_lines * 100 / total_lines))
        if [ "$doc_ratio" -gt 20 ]; then
            echo "- \`${file#./}\` (well-documented, ${doc_ratio}% comments)"
        fi
    fi
done | head -5

echo ""
echo "### Modules to Approach Later"
echo ""

# Find modules with high complexity or many dependencies
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" \) 2>/dev/null | head -20 | while read -r file; do
    import_count=$(grep -cE "^import|^from|^const.*require" "$file" 2>/dev/null || echo 0)
    total_lines=$(wc -l < "$file" 2>/dev/null || echo 1)
    
    if [ "$import_count" -gt 10 ] || [ "$total_lines" -gt 500 ]; then
        echo "- \`${file#./}\` (${import_count} imports, ${total_lines} lines)"
    fi
done | head -5

echo ""
echo "---"
echo ""

# Add visualizations
echo "## Codebase Visualizations"
echo ""

echo "### 1. Dependency Graph"
echo ""
echo '```mermaid'
if [ -x "./scripts/generate-dependency-graph.sh" ]; then
    ./scripts/generate-dependency-graph.sh 2>/dev/null | head -50
else
    echo "(Run ./scripts/generate-dependency-graph.sh to generate)"
fi
echo '```'
echo ""

echo "### 2. Code Ownership"
echo ""
echo '```mermaid'
if [ -x "./scripts/generate-ownership-heatmap.sh" ]; then
    ./scripts/generate-ownership-heatmap.sh 2>/dev/null | head -50
else
    echo "(Run ./scripts/generate-ownership-heatmap.sh to generate)"
fi
echo '```'
echo ""

echo "### 3. Module Coupling"
echo ""
echo '```mermaid'
if [ -x "./scripts/generate-coupling-heatmap.sh" ]; then
    ./scripts/generate-coupling-heatmap.sh 2>/dev/null | head -50
else
    echo "(Run ./scripts/generate-coupling-heatmap.sh to generate)"
fi
echo '```'
echo ""

echo "### 4. Layer Compliance"
echo ""
echo '```mermaid'
if [ -x "./scripts/generate-layer-compliance.sh" ]; then
    ./scripts/generate-layer-compliance.sh 2>/dev/null | head -50
else
    echo "(Run ./scripts/generate-layer-compliance.sh to generate)"
fi
echo '```'
echo ""

# Add knowledge holders section
echo "---"
echo ""
echo "## Knowledge Holders by Area"
echo ""

# Get top contributors per directory
for dir in $(find . -maxdepth 2 -type d -name "src" -o -name "lib" -o -name "internal" -o -name "pkg" 2>/dev/null | head -5); do
    dir_name=$(basename "$dir")
    echo "### $dir_name/"
    
    git log --since="6 months ago" --format='%an' -- "$dir" 2>/dev/null | sort | uniq -c | sort -rn | head -3 | while read -r line; do
        count=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | awk '{print $2}')
        echo "- **$name** ($count commits)"
    done
    echo ""
done

# Add next steps
echo "---"
echo ""
echo "## Recommended First Steps"
echo ""
echo "1. Review the dependency graph to understand the overall structure"
echo "2. Read the documentation in the modules marked as 'well-documented' above"
echo "3. Identify your area of work and check the ownership map"
echo "4. Reach out to the knowledge holders for your area"
echo "5. Review the layer compliance to understand architectural boundaries"
echo ""
echo "## Questions?"
echo ""
echo "Check the [Architecture Documentation](./docs/architecture/) for more details."
