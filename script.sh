#!/usr/bin/env bash
set -e

# Ensure gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed. Run 'sudo apt install gh' and 'gh auth login'."
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: Commit your changes (like this script) first."
    exit 1
fi

for repo_url in "$@"
do
  repo_name=$(basename -s .git "$repo_url")
  # Extract "user/repo" for the gh command
  repo_path=$(echo "$repo_url" | sed -e 's/https:\/\/github.com\///' -e 's/\.git//')

  echo -e "\n==== Archiving: $repo_name (with Releases) ===="

  if [ -d "$repo_name" ]; then
    echo "⏩ Skipping $repo_name: Folder exists."
    continue
  fi

  # 1. Setup Remotes
  git remote remove "tmp-$repo_name" 2>/dev/null || true
  git remote add "tmp-$repo_name" "$repo_url"
  git fetch "tmp-$repo_name" --quiet

  default_branch=$(git remote show "tmp-$repo_name" | grep "HEAD branch" | awk '{print $NF}')
  [ -z "$default_branch" ] && default_branch="main"

  # 2. Move Code
  mkdir -p "$repo_name"
  git read-tree --prefix="$repo_name/" -u "tmp-$repo_name/$default_branch"
  
  # 3. Download Releases
  echo "📦 Checking for releases in $repo_path..."
  mkdir -p "$repo_name/releases"
  
  # This downloads assets for all releases into the releases folder
  # We use '|| true' so the script doesn't crash if there are no releases
  gh release download --repo "$repo_path" --dir "$repo_name/releases" --archive=zip --pattern="*" || echo "No releases found."

  # Clean up empty release folder if nothing was downloaded
  rmdir "$repo_name/releases" 2>/dev/null || true

  # 4. Commit everything
  git add "$repo_name"
  git commit -m "Archive $repo_name (code + releases) from $repo_url"

  git remote remove "tmp-$repo_name"
  echo "✅ Done: $repo_name"
done