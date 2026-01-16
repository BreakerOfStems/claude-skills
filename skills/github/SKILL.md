---
name: github
description: GitHub and git workflows for cloning repos, managing issues, creating branches, resolving conflicts, and creating PRs
---

# GitHub + Git Workflows Skill

This skill provides safe, structured workflows for GitHub and git operations.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Scope

- Clone repositories
- Read and reference issues
- Create feature branches
- Cherry-pick commits
- Resolve merge conflicts
- Push branches
- Create pull requests

## Command Allowlist

### GitHub CLI (`gh`)

```
gh auth status
gh repo clone <repo>
gh issue view <number>
gh pr create
gh pr view <number>
```

### Git Commands

```
git status
git diff
git checkout -b <branch>
git fetch
git pull --rebase
git cherry-pick <commit>
git rebase <branch>
git merge <branch>
git commit
git push
```

## Policies

### Branch Protection

- **Never push directly to `main` or `master`**
- Always work on feature branches

### Branch Naming Convention

```
claude/<issue-number>-<short-slug>
```

Examples:
- `claude/123-fix-login-bug`
- `claude/456-add-user-auth`

### Pull Request Standards

- PR title **must include** the issue number: `[#123] Fix login validation bug`
- PR body **must use** the template at `templates/pr_body.md`
- Link the PR to the relevant issue

### Conflict Resolution Protocol

When conflicts occur, **do not guess** at resolutions:

1. Stop and enumerate all conflicting files
2. For each file, show:
   - The conflicting sections
   - "Ours" version (current branch)
   - "Theirs" version (incoming changes)
3. Present resolution choices:
   - Accept ours
   - Accept theirs
   - Manual merge (show proposed result)
4. Apply resolution only after user confirmation

## Workflow Examples

### Starting Work on an Issue

```bash
# 1. Check auth status
gh auth status

# 2. View the issue
gh issue view 123

# 3. Ensure repo is clean
./scripts/ensure_repo_clean.sh

# 4. Create branch
git checkout -b claude/123-fix-login-bug

# 5. Make changes...

# 6. Commit and push
git add .
git commit -m "[#123] Fix login validation bug"
git push -u origin claude/123-fix-login-bug

# 7. Create PR
gh pr create --title "[#123] Fix login validation bug" --body-file templates/pr_body.md
```

### Cherry-picking a Commit

```bash
# 1. Ensure clean state
git status

# 2. Fetch latest
git fetch origin

# 3. Cherry-pick
git cherry-pick <commit-sha>

# 4. If conflicts, follow conflict resolution protocol
```

## Helper Scripts

- `scripts/ensure_repo_clean.sh` - Verify working directory is clean before operations
