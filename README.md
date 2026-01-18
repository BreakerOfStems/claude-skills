# Claude Skills Pack

A collection of reusable skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Anthropic's official CLI for Claude.

Skills provide Claude with domain-specific knowledge, command allowlists, and safety guardrails for common workflows.

## Installation

Install or update the skills by running:

```bash
curl -fsSL https://raw.githubusercontent.com/BreakerOfStems/claude-skills/main/scripts/install.sh | bash
```

This command:
- Clones only the `/skills` directory (via sparse-checkout) to a local cache
- Syncs skill folders to `~/.claude/skills/`
- Can be re-run to update to the latest version

> **Warning:** Skills from this repository will **override** any existing skills with the same folder name in `~/.claude/skills/`. Your custom skills with different names will be preserved.

Claude Code will automatically discover skills by reading `SKILL.md` files with YAML frontmatter.

## Available Skills

### GitHub

| Skill | Description |
|-------|-------------|
| [github-clone](skills/github-clone/SKILL.md) | Clone repositories and set up local workspace |
| [github-issues](skills/github-issues/SKILL.md) | View and understand GitHub issues |
| [github-branches](skills/github-branches/SKILL.md) | Create and manage feature branches |
| [github-pr](skills/github-pr/SKILL.md) | Create and manage pull requests |
| [github-conflicts](skills/github-conflicts/SKILL.md) | Resolve merge conflicts safely |

### Azure (Read-Only)

| Skill | Description |
|-------|-------------|
| [azure-resources](skills/azure-resources/SKILL.md) | Query Azure resources and configurations |
| [azure-rbac](skills/azure-rbac/SKILL.md) | Query Azure RBAC role assignments and definitions |

### Linux

| Skill | Description |
|-------|-------------|
| [linux-filesystem](skills/linux-filesystem/SKILL.md) | Filesystem operations within workspace boundaries |
| [linux-services](skills/linux-services/SKILL.md) | Systemd service management and log access |

### Windows Remote

| Skill | Description |
|-------|-------------|
| [windows-remote](skills/windows-remote/SKILL.md) | Windows remote administration via PowerShell over SSH tunnel |

### Unity

| Skill | Description |
|-------|-------------|
| [unity-headless](skills/unity-headless/SKILL.md) | Install Unity Hub/Editor, activate licenses, run headless builds and tests |
| [unity-coding](skills/unity-coding/SKILL.md) | Implement gameplay and system code following Unity conventions |
| [unity-debugging](skills/unity-debugging/SKILL.md) | Diagnose compile errors and runtime issues using logs |
| [unity-ui](skills/unity-ui/SKILL.md) | Make UI changes by editing prefabs and scenes carefully |
| [unity-project-hygiene](skills/unity-project-hygiene/SKILL.md) | Keep Unity repos stable for CI/CD |

### Obsidian

| Skill | Description |
|-------|-------------|
| [obsidian-read-context](skills/obsidian-read-context/SKILL.md) | Analyze vault documentation to understand knowledge state and identify gaps |
| [obsidian-extract-inbox](skills/obsidian-extract-inbox/SKILL.md) | Extract structured document proposals from messy inbox notes |
| [obsidian-write-document](skills/obsidian-write-document/SKILL.md) | Create or update canonical Obsidian documents with proper formatting |
| [obsidian-issue-from-doc](skills/obsidian-issue-from-doc/SKILL.md) | Convert Obsidian documents into GitHub-ready issues |

### Automation

| Skill | Description |
|-------|-------------|
| [task-plan-normalizer](skills/task-plan-normalizer/SKILL.md) | Convert raw task input into machine-safe execution plans for unattended operation |

### Meta

| Skill | Description |
|-------|-------------|
| [skill-authoring](skills/skill-authoring/SKILL.md) | Create new Claude Code skills with proper structure and best practices |

## Repository Structure

```
├── skills/
│   ├── github-clone/
│   ├── github-issues/
│   ├── github-branches/
│   ├── github-pr/
│   ├── github-conflicts/
│   ├── azure-resources/
│   ├── azure-rbac/
│   ├── linux-filesystem/
│   ├── linux-services/
│   ├── windows-remote/
│   ├── unity-headless/
│   │   └── scripts/
│   ├── unity-coding/
│   ├── unity-debugging/
│   ├── unity-ui/
│   ├── unity-project-hygiene/
│   ├── obsidian-read-context/
│   ├── obsidian-extract-inbox/
│   ├── obsidian-write-document/
│   ├── obsidian-issue-from-doc/
│   ├── task-plan-normalizer/
│   ├── skill-authoring/
│   └── shared/
│       ├── CONVENTIONS.md
│       └── SAFETY.md
├── scripts/
│   ├── install.sh
│   └── sync.sh
└── README.md
```

## Shared Conventions

All skills follow the conventions defined in [shared/CONVENTIONS.md](skills/shared/CONVENTIONS.md):

- Work only inside `~/workspace/` or designated project directories
- Never modify protected resources (SSH, sudoers, tailscale, ufw, users/groups)
- Always run `git status` before and after changes
- Prefer minimal diffs, one concern per commit
- Format output as: commands + short results + next step

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

### Skill Design Principles

1. **One function per skill** - Keep skills focused and granular
2. **No overlap** - Each skill has a distinct purpose
3. **Clear boundaries** - Explicit about what's allowed and forbidden
4. **Shared conventions** - Reference common protections, don't duplicate

### Skill Anatomy

A well-structured skill includes:

1. **Purpose** - What the skill does (one sentence)
2. **Commands** - Allowed commands with examples
3. **Workflow** - Step-by-step usage patterns
4. **Policies** - Safety rules and constraints

## Learn More

For detailed documentation on Claude Code skills, see the official Anthropic documentation:

**[Claude Code Skills Documentation](https://docs.anthropic.com/en/docs/claude-code/skills)**

## License

MIT
