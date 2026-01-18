#!/usr/bin/env bash
# sync.sh - Update skills from the cached repository
# This is a convenience script if you've already run install.sh

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-skills"
DST="$HOME/.claude/skills"

if [[ ! -d "$CACHE_DIR/.git" ]]; then
  echo "Error: Skills repository not found at $CACHE_DIR"
  echo "Run the install command first:"
  echo "  curl -fsSL https://raw.githubusercontent.com/BreakerOfStems/claude-skills/main/scripts/install.sh | bash"
  exit 1
fi

echo "Updating skills repository..."
git -C "$CACHE_DIR" pull --ff-only

echo ""
echo "Syncing skills to $DST..."
for d in "$CACHE_DIR/skills"/*/ ; do
  name="$(basename "$d")"
  if [[ -f "$d/SKILL.md" ]]; then
    mkdir -p "$DST/$name"
    echo "  Syncing $name"
    rsync -a --delete --exclude ".git/" "$d/" "$DST/$name/"
  fi
done

echo ""
echo "Done! Skills updated."
