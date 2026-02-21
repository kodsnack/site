#!/bin/bash

set -euo pipefail

# Find the .md file with the highest number as its name
highest=$(ls *.md 2>/dev/null | sed 's/\.md$//' | sort -n | tail -1)

if [ -z "$highest" ]; then
    echo "No numbered .md files found in current directory."
    exit 1
fi

new_num=$((highest + 1))

echo "Creating episode $new_num from episode $highest..."

# Copy the file and folder
cp "$highest.md" "$new_num.md"
if [ -d "$highest" ]; then
    cp -r "$highest" "$new_num"
    # Rename files inside the folder that contain the old number
    for f in "$new_num"/*; do
        new_name="${f//$highest/$new_num}"
        if [ "$f" != "$new_name" ]; then
            mv "$f" "$new_name"
        fi
    done
fi

# Extract the date from the front matter
old_date=$(grep '^date = ' "$new_num.md" | head -1 | sed 's/^date = //')
date_part="${old_date%%T*}"
time_part="${old_date#*T}"

# Calculate new date (one week later)
if [[ "$OSTYPE" == darwin* ]]; then
    new_date_part=$(date -j -v+7d -f "%Y-%m-%d" "$date_part" "+%Y-%m-%d")
    old_alias_date=$(date -j -f "%Y-%m-%d" "$date_part" "+%Y/%m/%d")
    new_alias_date=$(date -j -v+7d -f "%Y-%m-%d" "$date_part" "+%Y/%m/%d")
else
    new_date_part=$(date -d "$date_part + 7 days" "+%Y-%m-%d")
    old_alias_date=$(date -d "$date_part" "+%Y/%m/%d")
    new_alias_date=$(date -d "$date_part + 7 days" "+%Y/%m/%d")
fi

new_date="${new_date_part}T${time_part}"

# Process the file with awk
awk -v new_num="$new_num" -v old_num="$highest" \
    -v new_date="$new_date" -v old_date="$old_date" \
    -v new_alias_date="$new_alias_date" -v old_alias_date="$old_alias_date" \
'
BEGIN { in_front=0; front_count=0; body=0 }
{
    if ($0 == "+++") {
        front_count++
        print
        if (front_count == 2) { body=1; in_front=0 }
        else { in_front=1 }
        next
    }

    if (in_front) {
        if ($0 ~ /^date = /)       { print "date = " new_date; next }
        if ($0 ~ /^title = /)      { print "title = \"Kodsnack " new_num " - \""; next }
        if ($0 ~ /^slug = /)       { print "slug = \"" new_num "\""; next }
        if ($0 ~ /^aliases = /)    { print "aliases = [\"/blog/" new_alias_date "/" new_num "\"]"; next }
        if ($0 ~ /^audiofile = /)  { gsub(old_num, new_num); print; next }
        if ($0 ~ /^libsynid = /)   { print "libsynid = \"\""; next }
        if ($0 ~ /^audiosize = /)  { print "audiosize = \"\""; next }
        if ($0 ~ /^audiolength = /){ print "audiolength = \"\""; next }
        if ($0 ~ /^draft = /)      { print "draft = true"; next }
        if ($0 ~ /^images = /)     { gsub(old_num, new_num); print; next }
        print
        next
    }

    if (body) {
        if ($0 ~ /^## /) {
            print ""
            print $0
            print "* "
        }
    }
}
' "$new_num.md" > "$new_num.md.tmp" && mv "$new_num.md.tmp" "$new_num.md"

echo "Done! Created episode $new_num."
