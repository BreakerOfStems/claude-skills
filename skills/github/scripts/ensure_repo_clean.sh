#!/bin/bash
# ensure_repo_clean.sh
# Verify the git working directory is clean before operations

set -e

echo "Checking repository status..."

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "ERROR: Not inside a git repository"
    exit 1
fi

# Get status
STATUS=$(git status --porcelain)

if [ -n "$STATUS" ]; then
    echo "ERROR: Working directory is not clean"
    echo ""
    echo "Uncommitted changes:"
    git status --short
    echo ""
    echo "Please commit or stash changes before proceeding."
    exit 1
fi

# Check for unpushed commits
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

if [ -n "$UPSTREAM" ]; then
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")

    if [ "$LOCAL" != "$REMOTE" ]; then
        AHEAD=$(git rev-list --count "$UPSTREAM"..@ 2>/dev/null || echo "0")
        BEHIND=$(git rev-list --count @.."$UPSTREAM" 2>/dev/null || echo "0")

        if [ "$AHEAD" -gt 0 ]; then
            echo "WARNING: Branch is $AHEAD commit(s) ahead of upstream"
        fi
        if [ "$BEHIND" -gt 0 ]; then
            echo "WARNING: Branch is $BEHIND commit(s) behind upstream"
        fi
    fi
fi

echo "Repository is clean. Ready to proceed."
exit 0
