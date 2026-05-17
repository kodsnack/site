#!/usr/bin/env bash
# List markdown files (recursive) that lack a `people` property in their frontmatter.
# Usage: missing-people.sh [DIR]   (defaults to current directory)

set -euo pipefail

dir="${1:-.}"

while IFS= read -r -d '' file; do
    if ! awk '
        NR == 1 {
            sub(/^[[:space:]]+/, "")
            sub(/[[:space:]]+$/, "")
            if ($0 == "+++") { fence = "+++"; next }
            if ($0 == "---") { fence = "---"; next }
            exit 1
        }
        { line = $0; sub(/^[[:space:]]+/, "", line); sub(/[[:space:]]+$/, "", line) }
        line == fence { exit found ? 0 : 1 }
        /^[[:space:]]*people[[:space:]]*[:=]/ { found = 1 }
        END { exit found ? 0 : 1 }
    ' "$file"; then
        echo "$file"
    fi
done < <(find "$dir" -type f -name '*.md' -print0) | sort -V
