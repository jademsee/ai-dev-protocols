#!/bin/bash
# Analyze knowledge transfer needs when a team member is leaving
# Usage: ./analyze-knowledge-transfer.sh <username>
# Output: Markdown report to stdout

set -e

USERNAME="${1:-}"
SINCE_DATE=$(date -d "12 months ago" '+%Y-%m-%d' 2>/dev/null || date -v-12m '+%Y-%m-%d')

if [ -z "$USERNAME" ]; then
    echo "ERROR: Username required" >&2
    echo "Usage: $0 <username>" >&2
    exit 1
fi

# Verify user exists in git history
if ! git log --author="$USERNAME" --format='%an' 2>/dev/null | head -1 | grep -q .; then
    echo "WARNING: No commits found for user '$USERNAME'" >&2
fi

cat << HEADER
# Knowledge Transfer Report

**Departing Team Member**: $USERNAME
**Analysis Period**: Since $SINCE_DATE
**Generated**: $(date '+%Y-%m-%d %H:%M')

---

## Executive Summary

HEADER

# Get statistics
total_commits=$(git log --author="$USERNAME" --since="$SINCE_DATE" --format='%H' 2>/dev/null | wc -l)
total_files=$(git log --author="$USERNAME" --since="$SINCE_DATE" --name-only --format='' 2>/dev/null | sort -u | wc -l)
total_lines=$(git log --author="$USERNAME" --since="$SINCE_DATE" --numstat --format='' 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added+deleted}')

echo "- Total commits: $total_commits"
echo "- Files touched: $total_files"
echo "- Lines changed: ${total_lines:-0}"
echo ""

# Find modules where this user is the primary owner
echo "## Critical Modules (Primary Owner)"
echo ""
echo "These modules have >50% ownership by $USERNAME and require immediate knowledge transfer:"
echo ""

git log --since="$SINCE_DATE" --format='' --name-only 2>/dev/null | sort | uniq -c | sort -rn | head -50 | while read -r line; do
    count=$(echo "$line" | awk '{print $1}')
    file=$(echo "$line" | awk '{print $2}')
    
    if [ -z "$file" ] || [ ! -f "$file" ]; then
        continue
    fi
    
    # Check if departing user is primary owner
    user_commits=$(git log --author="$USERNAME" --since="$SINCE_DATE" --format='%H' -- "$file" 2>/dev/null | wc -l)
    
    if [ "$count" -gt 0 ] && [ "$user_commits" -gt 0 ]; then
        ownership=$((user_commits * 100 / count))
        
        if [ "$ownership" -gt 50 ]; then
            dir=$(dirname "$file")
            echo "- **\`${file}\`** - ${ownership}% owned (${user_commits}/$count commits)"
        fi
    fi
done

echo ""

# Find potential successors
echo "## Recommended Knowledge Recipients"
echo ""
echo "Based on recent activity in the same areas:"
echo ""

# Get directories the user worked on
dirs=$(git log --author="$USERNAME" --since="$SINCE_DATE" --format='' --name-only 2>/dev/null | xargs dirname 2>/dev/null | sort -u | head -10)

for dir in $dirs; do
    if [ ! -d "$dir" ]; then
        continue
    fi
    
    echo "### $dir/"
    
    # Find other contributors to this directory
    git log --since="$SINCE_DATE" --format='%an' -- "$dir" 2>/dev/null | grep -v "^$USERNAME$" | sort | uniq -c | sort -rn | head -3 | while read -r line; do
        count=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | awk '{print $2}')
        echo "- **$name** ($count commits in this area)"
    done
    echo ""
done

# List files needing documentation
echo "## Files Needing Documentation"
echo ""
echo "Files with high ownership but low documentation:"
echo ""

git log --author="$USERNAME" --since="$SINCE_DATE" --format='' --name-only 2>/dev/null | sort -u | head -20 | while read -r file; do
    if [ -z "$file" ] || [ ! -f "$file" ]; then
        continue
    fi
    
    # Check documentation level
    doc_lines=$(grep -c "//\|#\|/\*" "$file" 2>/dev/null || echo 0)
    total_lines=$(wc -l < "$file" 2>/dev/null || echo 1)
    
    if [ "$total_lines" -gt 50 ]; then
        doc_ratio=$((doc_lines * 100 / total_lines))
        
        if [ "$doc_ratio" -lt 10 ]; then
            echo "- \`${file}\` - Only ${doc_ratio}% documented"
        fi
    fi
done

echo ""

# Outstanding work
echo "## Outstanding Work"
echo ""
echo "Recent unmerged branches or WIP:"
echo ""

# Check for branches by this user (if applicable)
if git branch -a --list "*$USERNAME*" 2>/dev/null | head -5 | grep -q .; then
    git branch -a --list "*$USERNAME*" 2>/dev/null | head -5 | while read -r branch; do
        echo "- $branch"
    done
else
    echo "(No branches found with username pattern)"
fi

echo ""

# Action items
echo "## Recommended Actions"
echo ""
echo "1. [ ] Schedule handoff meetings with recommended recipients above"
echo "2. [ ] Document the files marked as needing documentation"
echo "3. [ ] Review and merge any outstanding branches"
echo "4. [ ] Update ownership in CODEOWNERS file if applicable"
echo "5. [ ] Transfer any system access or credentials (see secrets management)"
