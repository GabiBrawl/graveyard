#!/usr/bin/env bash
# indexer.sh

README_FILE="README.md"

# Start the README content
cat <<EOF > $README_FILE
# 🪦 The Graveyard
*A collection of legacy projects and early experiments preserved for historical purposes.*

## 🏛️ Project Index
| Project | Description | Tech Stack | Status |
| :--- | :--- | :--- | :--- |
EOF

for d in */; do
    [[ "$d" =~ ^\. ]] && continue
    folder_name="${d%/}"
    
    # --- 1. Detect Tech Stack ---
    stack="Unknown"
    if ls "$folder_name"/*.py &>/dev/null; then stack="Python";
    elif ls "$folder_name"/*.bat &>/dev/null || ls "$folder_name"/*.cmd &>/dev/null; then stack="Batch / CMD";
    elif [ -f "$folder_name/package.json" ]; then stack="Node.js";
    elif ls "$folder_name"/*.sh &>/dev/null; then stack="Shell";
    elif ls "$folder_name"/*.html &>/dev/null; then stack="HTML/CSS";
    elif ls "$folder_name"/*.exe &>/dev/null; then stack="C++ / Win32";
    fi

    # --- 2. Get Description ---
    desc=""
    if [ -f "${folder_name}/README.md" ]; then
        # Try to find the first line of text that isn't a header or a link
        desc=$(grep -v "^#\|^!\|^\[\|^$" "${folder_name}/README.md" | head -n 1 | sed 's/|/\\|/g' | cut -c1-80)
    fi
    [ -z "$desc" ] && desc="Legacy project archive."

    # --- 3. Check for Releases ---
    if [ -d "${folder_name}/releases" ]; then
        status="[📦 Releases](./${folder_name}/releases)"
    else
        status="[💻 Code](./${folder_name})"
    fi

    # Append the row
    echo "| [**${folder_name}**](./${folder_name}) | $desc | **$stack** | $status |" >> $README_FILE
done

cat <<EOF >> $README_FILE

---
*Last updated on $(date +'%Y-%m-%d')*
EOF

echo "✅ README.md rebuilt with Tech Stacks detected."