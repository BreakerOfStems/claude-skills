# Shared Conventions

These conventions apply to **all skills** in this repository.

## Workspace Boundaries

- Work only inside `/home/claude/workspace/*`
- Never create or modify files outside the designated workspace
- Respect project boundaries and do not traverse into unrelated directories

## Command Preferences

- Prefer **non-interactive** commands whenever possible
- Use **JSON output** formats where available (e.g., `--output json`, `-o json`)
- Avoid commands that require user input or confirmation prompts

## Protected Resources

Never modify the following unless **explicitly asked** by the user:

- SSH configuration (`/etc/ssh/*`, `~/.ssh/config`)
- Sudoers files (`/etc/sudoers`, `/etc/sudoers.d/*`)
- Tailscale configuration
- Firewall rules (`ufw`, `iptables`)
- User and group management (`useradd`, `usermod`, `groupadd`, etc.)

## Pre-Destructive Action Protocol

Before any destructive action (delete, overwrite, force push, etc.):

1. Show current state (e.g., `git status`, `ls -la`, resource list)
2. Present a clear plan of what will be changed
3. Wait for explicit confirmation if the action is irreversible

## Merge Conflict Resolution

When encountering merge conflicts:

1. **Stop** immediately - do not attempt to auto-resolve
2. **Summarize** the conflict:
   - List all conflicting files
   - Describe the nature of each conflict
   - Show both "ours" and "theirs" versions
3. **Propose** resolution options with clear explanations
4. **Proceed** only after user selects a resolution strategy

## Output Standards

- Provide concise, actionable summaries
- Include relevant command output for verification
- Flag any warnings or unexpected results prominently
