#!/bin/bash
# Check bus factor for critical modules
# Usage: ./check-bus-factor.sh [threshold]
# Exit code: 1 if any module has bus factor below threshold

set -e

THRESHOLD="${1:-2}"
SINCE_DATE=$(date -d "6 months ago" '+%Y-%m-%d' 2>/dev/null || date -v-6m '+%Y-%m-%d')

# Find critical modules (most imported/depended upon)
# For now, use directories with most files as proxy
CRITICAL_DIRS=$(find . -type d \( -name "core" -o -name "auth" -o -name "api" -o -name "database" -o -name "services" \) 2>/dev/null)

if [ -z "$CRITICAL_DIRS" ]; then
    # Fallback: find directories with most commits
    CRITICAL_DIRS=$(git log --since="$SINCE_DATE" --format='' --name-only 2>/dev/null | grep -o '^[^/]*/' | sort | uniq -c | sort -rn | head -5 | awk '{print $2}' | tr -d '/')
fi

LOW_BUS_FACTOR=""

echo "Bus Factor Analysis"
echo "=================="
echo "Threshold: $THRESHOLD"
echo ""

for dir in $CRITICAL_DIRS; do
    if [ ! -d "$dir" ]; then
        continue
    fi
    
    # Count unique contributors
    owner_count=$(git log --since="$SINCE_DATE" --format='%an' -- "$dir" 2>/dev/null | sort -u | wc -l)
    
    # Get top contributor percentage
    total_commits=$(git log --since="$SINCE_DATE" --format='%an' -- "$dir" 2>/dev/null | wc -l)
    top_commits=$(git log --since="$SINCE_DATE" --format='%an' -- "$dir" 2>/dev/null | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')
    top_owner=$(git log --since="$SINCE_DATE" --format='%an' -- "$dir" 2>/dev/null | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
    
    if [ "$total_commits" -gt 0 ]; then
        concentration=$((top_commits * 100 / total_commits))
    else
        concentration=0
    fi
    
    if [ "$owner_count" -lt "$THRESHOLD" ]; then
        echo "⚠️  $dir: Bus factor = $owner_count (below threshold $THRESHOLD)"
        echo "   Top owner: $top_owner ($top_commits commits, ${concentration}%)"
        LOW_BUS_FACTOR="$LOW_BUS_FACTOR $dir"
    else
        echo "✅ $dir: Bus factor = $owner_count"
    fi
done

echo ""

if [ -n "$LOW_BUS_FACTOR" ]; then
    echo "::warning::Low bus factor detected in:$LOW_BUS_FACTOR"
    exit 1
else
    echo "All critical modules have adequate bus factor."
    exit 0
fi
