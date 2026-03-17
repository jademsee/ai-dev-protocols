#!/bin/bash
# Generate dependency graph in Mermaid format
# Usage: ./generate-dependency-graph.sh [src_dir]
# Output: Mermaid graph to stdout

set -e

SRC_DIR="${1:-src}"
OUTPUT_FORMAT="${2:-mmd}"

# Detect project type and use appropriate tool
detect_project_type() {
    if [ -f "package.json" ]; then
        echo "javascript"
    elif [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "Cargo.toml" ]; then
        echo "rust"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "python"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "java"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type)

generate_javascript() {
    if command -v npx &> /dev/null; then
        npx dependency-cruiser --output-type mmd "$SRC_DIR" 2>/dev/null
    else
        echo "ERROR: npx not found. Install Node.js to use dependency-cruiser" >&2
        exit 1
    fi
}

generate_go() {
    if command -v go &> /dev/null; then
        echo "graph TD"
        go mod graph 2>/dev/null | while read -r line; do
            # Parse "module dependency" format
            module=$(echo "$line" | awk '{print $1}')
            dep=$(echo "$line" | awk '{print $2}')
            echo "    $module --> $dep"
        done
    else
        echo "ERROR: go not found" >&2
        exit 1
    fi
}

generate_rust() {
    if command -v cargo &> /dev/null; then
        # cargo-depgraph needs to be installed
        if cargo depgraph --help &> /dev/null; then
            cargo depgraph --all-deps 2>/dev/null
        else
            echo "ERROR: cargo-depgraph not installed. Run: cargo install cargo-depgraph" >&2
            exit 1
        fi
    else
        echo "ERROR: cargo not found" >&2
        exit 1
    fi
}

generate_python() {
    if command -v pydeps &> /dev/null; then
        # pydeps outputs to file, we need to capture it
        local module_name
        module_name=$(basename "$(pwd)")
        pydeps "$module_name" --no-output -T mmd -o /dev/stdout 2>/dev/null
    else
        echo "ERROR: pydeps not found. Install with: pip install pydeps" >&2
        exit 1
    fi
}

generate_generic() {
    # Fallback: parse import statements manually
    echo "graph TD"
    find "$SRC_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" \) 2>/dev/null | while read -r file; do
        module=$(basename "$file" | sed 's/\.[^.]*$//')
        
        # Extract imports based on file type
        case "$file" in
            *.js|*.ts)
                grep -E "^import|^const.*require" "$file" 2>/dev/null | while read -r import; do
                    dep=$(echo "$import" | sed -n "s/.*from ['\"]\\([^'\"]*\\)['\"].*/\\1/p" | head -1)
                    if [ -n "$dep" ] && [[ ! "$dep" =~ ^\. ]]; then
                        echo "    $module --> ${dep//\//_}"
                    fi
                done
                ;;
            *.py)
                grep -E "^import|^from" "$file" 2>/dev/null | while read -r import; do
                    dep=$(echo "$import" | awk '{print $2}' | cut -d'.' -f1)
                    if [ -n "$dep" ] && [[ ! "$dep" =~ ^_ ]]; then
                        echo "    $module --> $dep"
                    fi
                done
                ;;
        esac
    done
}

case "$PROJECT_TYPE" in
    javascript)
        generate_javascript
        ;;
    go)
        generate_go
        ;;
    rust)
        generate_rust
        ;;
    python)
        generate_python
        ;;
    *)
        generate_generic
        ;;
esac
