---
name: github-issues
description: View and understand GitHub issues
---

# GitHub Issues Skill

Read and understand GitHub issues to gather requirements.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Purpose

View issue details, comments, and labels to understand work requirements.

## Commands

```bash
gh issue view <number>
gh issue view <number> --comments
gh issue list
gh issue list --label <label>
gh issue list --assignee @me
```

## Workflow

1. **View issue details**
   ```bash
   gh issue view 123
   ```

2. **Read comments for context**
   ```bash
   gh issue view 123 --comments
   ```

3. **Check related issues**
   ```bash
   gh issue list --label "related-feature"
   ```

## Output Format

When summarizing an issue, include:
- Issue number and title
- Current status (open/closed)
- Key requirements from description
- Important points from comments
- Acceptance criteria if specified

## Policies

- Read-only operations only
- Summarize key points concisely
- Note any ambiguities that need clarification
- Cross-reference related issues when relevant
