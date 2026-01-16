# Claude Skills Pack

A collection of reusable skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Anthropic's official CLI for Claude.

Skills provide Claude with domain-specific knowledge, command allowlists, and safety guardrails for common workflows.

## Installation

Clone this repository into your Claude Code skills directory:

```bash
git clone https://github.com/BreakerOfStems/claude-skills.git ~/.claude/skills
```

Claude Code will automatically discover skills by reading `SKILL.md` files with YAML frontmatter.

## Available Skills

| Skill | Description |
|-------|-------------|
| [github](github/SKILL.md) | GitHub and git workflows for cloning repos, managing issues, creating branches, resolving conflicts, and creating PRs |
| [azure](azure/SKILL.md) | Azure CLI read-only operations for searching resources, querying configurations, and inspecting RBAC |
| [linux-admin](linux-admin/SKILL.md) | Bounded Linux administration for filesystem and systemd service management |
| [windows-remote](windows-remote/SKILL.md) | Windows remote administration via PowerShell over SSH tunnel |

## Structure

```
├── github/
│   ├── SKILL.md                 # Skill definition
│   ├── templates/               # PR templates, etc.
│   └── scripts/                 # Helper scripts
├── azure/
│   ├── SKILL.md
│   └── scripts/
├── linux-admin/
│   ├── SKILL.md
│   └── scripts/
├── windows-remote/
│   ├── SKILL.md
│   └── scripts/
├── shared/
│   ├── CONVENTIONS.md           # Shared conventions for all skills
│   └── SAFETY.md                # Safety guidelines
└── README.md
```

## Shared Conventions

All skills follow the conventions defined in [shared/CONVENTIONS.md](shared/CONVENTIONS.md):

- Work only inside designated workspace directories
- Prefer non-interactive commands and JSON outputs
- Never modify protected system resources unless explicitly asked
- Show current state before destructive actions
- Stop and summarize on merge conflicts before proceeding

## Creating Your Own Skills

Each skill requires a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: my-skill
description: Brief description of what this skill does
---

# My Skill

Detailed instructions, command allowlists, and policies...
```

### Skill Anatomy

A well-structured skill includes:

1. **Scope** - What the skill covers
2. **Command Allowlist** - Explicitly permitted commands
3. **Policies** - Safety rules and operational constraints
4. **Workflow Examples** - Common usage patterns
5. **Helper Scripts** - Automation for complex operations

### Best Practices

- Be explicit about what's allowed and forbidden
- Include safety checks and confirmation requirements for destructive operations
- Reference shared conventions rather than duplicating them
- Provide concrete examples for common workflows
- Use helper scripts to enforce policies programmatically

## Learn More

For detailed documentation on Claude Code skills, see the official Anthropic documentation:

**[Claude Code Skills Documentation](https://docs.anthropic.com/en/docs/claude-code/skills)**

## License

MIT
