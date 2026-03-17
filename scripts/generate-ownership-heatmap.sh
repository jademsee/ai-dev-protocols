#!/bin/bash
# Generate code ownership heatmap in Mermaid format
# Usage: ./generate-ownership-heatmap.sh [months_lookback]
# Output: Mermaid graph to stdout

set -e

MONTHS_LOOKBACK="${1:-6}"
SINCE_DATE=$(date -d "$MONTHS_LOOKBACK months ago" '+%Y-%m-%d' 2>/dev/null || date -v-${MONTHS_LOOKBACK}m '+%Y-%m-%d')

echo "%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#4dabf7'}}}%%"
echo "graph LR"

# Get top-level directories
DIRS=$(find . -maxdepth 2 -type d -name "src" -o -name "lib" -o -name "internal" -o -name "pkg" 2>/dev/null | head -5)

if [ -z "$DIRS" ]; then
    # Fallback to any directories with code
    DIRS=$(find . -maxdepth 1 -type d ! -name ".*" ! -name "docs" ! -name "scripts" 2>/dev/null | head -5)
fi

# Process each directory
for dir in $DIRS; do
    dir_name=$(basename "$dir")
    
    echo "    subgraph \"$dir_name/*\""
    
    # Get files and their primary owners
    find "$dir" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" \) 2>/dev/null | head -10 | while read -r file; do
        file_basename=$(basename "$file" | sed 's/\.[^.]*$//')
        
        # Get top contributor for this file
        top_owner=$(git log --since="$SINCE_DATE" --format='%an' -- "$file" 2>/dev/null | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
        commit_count=$(git log --since="$SINCE_DATE" --format='%an' -- "$file" 2>/dev/null | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')
        
        if [ -z "$top_owner" ]; then
            # Check if file is orphaned (no commits in lookback period)
            last_commit=$(git log -1 --format='%ar' -- "$file" 2>/dev/null)
            if [ -n "$last_commit" ]; then
                echo "        ${file_basename}[${file_basename}<br/>⚠️ ORPHANED<br/>last: ${last_commit}]"
            else
                echo "        ${file_basename}[${file_basename}<br/>⚠️ NEW FILE]"
            fi
        elif [ "$commit_count" -gt 10 ]; then
            # Single dominant owner - potential bus factor risk
            echo "        ${file_basename}[${file_basename}<br/>${top_owner}: ${commit_count} commits]"
        else
            # Check for multiple owners
            owner_count=$(git log --since="$SINCE_DATE" --format='%an' -- "$file" 2>/dev/null | sort -u | wc -l)
            if [ "$owner_count" -gt 1 ]; then
                echo "        ${file_basename}[${file_basename}<br/>${owner_count} contributors]"
            else
                echo "        ${file_basename}[${file_basename}<br/>${top_owner}: ${commit_count}]"
            fi
        fi
    done
    
    echo "    end"
done

# Add legend
echo ""
echo "    %% Style definitions"
echo "    %% Red: orphaned or single-owner (risk)"
echo "    %% Yellow: concentrated ownership"
echo "    %% Green: distributed ownership"
