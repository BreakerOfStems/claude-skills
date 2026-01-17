# Shared Conventions

These conventions apply to **all skills** in this repository.

## Workspace Boundaries

- Work only inside `~/workspace/<repo>` or designated project directories
- Never create or modify files outside the designated workspace
- Respect project boundaries and do not traverse into unrelated directories

## Protected Resources

**Never modify** the following unless **explicitly asked** by the user:

- `/etc/ssh/*` - SSH configuration
- `/etc/sudoers`, `/etc/sudoers.d/*` - Sudo configuration
- Tailscale configuration
- `ufw`, `iptables` - Firewall rules
- Users and groups (`useradd`, `usermod`, `groupadd`, etc.)
- Network configuration (`/etc/network/*`, `/etc/netplan/*`)

## Git Hygiene

- Always run `git status` before and after changes
- Prefer minimal diffs - change only what's necessary
- One concern per commit - don't mix unrelated changes
- Never force push to main/master

## Command Preferences

- Prefer **non-interactive** commands whenever possible
- Use **JSON output** formats where available (e.g., `--output json`, `-o json`)
- Avoid commands that require user input or confirmation prompts

## Output Standards

Format responses as:
1. **Commands** executed
2. **Short results** (succinct output or summary)
3. **Next step** recommendation

Flag any warnings or unexpected results prominently.

## Pre-Destructive Action Protocol

Before any destructive action (delete, overwrite, force push, etc.):

1. Show current state (e.g., `git status`, `ls -la`, resource list)
2. Present a clear plan of what will be changed
3. Wait for explicit confirmation if the action is irreversible
