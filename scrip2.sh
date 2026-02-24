#!/usr/bin/env bash

for repo_url in "$@"
do
  repo_name=$(basename -s .git "$repo_url")
  repo_path=$(echo "$repo_url" | sed -e 's/https:\/\/github.com\///' -e 's/\.git//')

  echo -e "\n🏛️  Archiving full history for $repo_name..."

  # 1. Get the list of tags
  tags=$(gh release list --repo "$repo_path" --limit 100 --json tagName --jq '.[].tagName')

  if [ -z "$tags" ]; then
    echo "ℹ️ No releases found for $repo_name."
    continue
  fi

  for tag in $tags
  do
    echo "  -> Processing $tag..."
    target_dir="$repo_name/releases/$tag"
    mkdir -p "$target_dir"

    # 2. DOWNLOAD THE FILES (Binaries + Source Zip)
    # We run these separately to avoid the CLI error from earlier
    gh release download "$tag" --repo "$repo_path" --dir "$target_dir" --pattern="*" --clobber 2>/dev/null || true
    gh release download "$tag" --repo "$repo_path" --dir "$target_dir" --archive=zip --clobber 2>/dev/null || true

    # 3. LOG THE DATA (The "Tombstone")
    release_info=$(gh release view "$tag" --repo "$repo_path")
    cat <<EOF > "$target_dir/release_info.md"
# Release Archive: $tag
**Original Repo:** $repo_url
**Snapshot Date:** $(date +'%Y-%m-%d')

## GitHub Release Details:
\`\`\`text
$release_info
\`\`\`

---
*Archived automatically in the Graveyard*
EOF
  done

  # 4. COMMIT EVERYTHING
  git add "$repo_name"
  git commit -m "📦 full archive: code, releases, and logs for $repo_name" || echo "No changes for $repo_name"
done