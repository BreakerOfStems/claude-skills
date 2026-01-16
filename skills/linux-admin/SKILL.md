---
name: linux-admin
description: Bounded Linux administration for filesystem and systemd service management within workspace boundaries
---

# Linux Admin Skill (Bounded)

This skill provides bounded Linux administration capabilities for filesystem and service management.

> **See also**: [Shared Conventions](../shared/CONVENTIONS.md) | [Safety Guidelines](../shared/SAFETY.md)

## Scope

- Filesystem management (within workspace only)
- Systemd service management (bounded operations)

## Command Allowlist

### Filesystem Operations (Workspace Only)

All filesystem operations are **restricted to `/home/claude/workspace/*`**

```
ls <path>
cat <file>
sed <expression> <file>
grep <pattern> <path>
find <path> <options>
mkdir <path>
rm <path>           # Only within workspace!
```

### Systemd Operations

```
systemctl status <service>
systemctl restart <service>
systemctl stop <service>
systemctl start <service>
```

### Log Access

```
journalctl -u <service> --no-pager -n 200
journalctl -u <service> --since "1 hour ago" --no-pager
```

## Policies

### Protected Paths - NEVER Touch

The following paths are **strictly off-limits**:

- `/etc/ssh/*` - SSH configuration
- `/etc/sudoers*` - Sudo configuration
- Tailscale configuration
- `ufw` / `iptables` - Firewall rules
- `/etc/network/*`, `/etc/netplan/*` - Network configuration
- User/group files (`/etc/passwd`, `/etc/group`, `/etc/shadow`)

### Workspace Boundary Enforcement

- **All** filesystem operations must be within `/home/claude/workspace/`
- Before any `rm` command, verify the path is within workspace
- Never use `rm -rf /` or any variation that could escape workspace

### Service Restart Protocol

Before restarting any service:

1. **Capture current status**:
   ```bash
   systemctl status <service>
   ```

2. **Capture recent logs**:
   ```bash
   journalctl -u <service> --no-pager -n 50
   ```

3. **Present findings** to user

4. **Proceed with restart** only after acknowledgment

5. **Verify service started**:
   ```bash
   systemctl status <service>
   ```

## Workflow Examples

### Check Service Health

```bash
# Get service status
./scripts/svc_status.sh nginx

# View recent logs
journalctl -u nginx --no-pager -n 100
```

### Restart a Service Safely

```bash
# 1. Capture pre-restart state
systemctl status myapp
journalctl -u myapp --no-pager -n 50

# 2. Restart
systemctl restart myapp

# 3. Verify
systemctl status myapp
```

### Find Files in Workspace

```bash
# Find all Python files
find /home/claude/workspace -name "*.py" -type f

# Find recently modified files
find /home/claude/workspace -type f -mtime -1
```

### Search File Contents

```bash
# Search for a pattern
grep -r "TODO" /home/claude/workspace/project/

# Search with context
grep -r -n -C 3 "error" /home/claude/workspace/logs/
```

## Helper Scripts

- `scripts/svc_status.sh` - Comprehensive service status with logs

## Safety Checks

Before executing filesystem commands, verify:

1. Path starts with `/home/claude/workspace/`
2. No symlinks that could escape workspace
3. No `..` traversal that could escape workspace

```bash
# Safe path check
realpath /home/claude/workspace/target | grep -q "^/home/claude/workspace/" || echo "UNSAFE PATH"
```
