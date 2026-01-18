#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/BreakerOfStems/claude-skills.git"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-skills"
DST="$HOME/.claude/skills"

mkdir -p "$DST"
mkdir -p "$(dirname "$CACHE_DIR")"

if [[ ! -d "$CACHE_DIR/.git" ]]; then
  echo "Cloning skills repository..."
  git clone --filter=blob:none --no-checkout "$REPO_URL" "$CACHE_DIR"
  git -C "$CACHE_DIR" sparse-checkout init --cone
  git -C "$CACHE_DIR" sparse-checkout set skills
  git -C "$CACHE_DIR" checkout
else
  echo "Updating skills repository..."
  git -C "$CACHE_DIR" pull --ff-only
fi

# Sync only skill folders under /skills
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
echo "Done! Skills installed to $DST"
