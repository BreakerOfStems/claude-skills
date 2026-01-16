#!/bin/bash
# win_ps.sh
# Execute PowerShell commands on Windows workers via SSH tunnel

set -e

WORKERS_FILE="config/workers.json"

usage() {
    echo "Usage: $0 <worker-name> <powershell-command>"
    echo ""
    echo "Executes a PowerShell command on a Windows worker via SSH tunnel."
    echo ""
    echo "The worker must be defined in $WORKERS_FILE"
    echo ""
    echo "Examples:"
    echo "  $0 worker1 'Get-Service'"
    echo "  $0 worker1 'Get-ChildItem C:\\Apps'"
    echo "  $0 worker1 'Restart-Service MyApp'"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

WORKER_NAME="$1"
shift
PS_COMMAND="$*"

# Check if workers file exists
if [ ! -f "$WORKERS_FILE" ]; then
    echo "ERROR: Workers registry not found at $WORKERS_FILE"
    exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "ERROR: jq is required but not installed"
    exit 1
fi

# Look up worker in registry
WORKER=$(jq -r --arg name "$WORKER_NAME" '.workers[] | select(.name == $name)' "$WORKERS_FILE")

if [ -z "$WORKER" ] || [ "$WORKER" = "null" ]; then
    echo "ERROR: Worker '$WORKER_NAME' not found in registry"
    echo ""
    echo "Available workers:"
    jq -r '.workers[].name' "$WORKERS_FILE" 2>/dev/null || echo "  (none)"
    exit 1
fi

# Extract connection details
TUNNEL_PORT=$(echo "$WORKER" | jq -r '.tunnel_port')
SSH_USER=$(echo "$WORKER" | jq -r '.ssh_user')
NOTES=$(echo "$WORKER" | jq -r '.notes // "No notes"')

if [ -z "$TUNNEL_PORT" ] || [ "$TUNNEL_PORT" = "null" ]; then
    echo "ERROR: No tunnel_port defined for worker '$WORKER_NAME'"
    exit 1
fi

if [ -z "$SSH_USER" ] || [ "$SSH_USER" = "null" ]; then
    echo "ERROR: No ssh_user defined for worker '$WORKER_NAME'"
    exit 1
fi

# Check for forbidden commands
FORBIDDEN_PATTERNS=(
    "Restart-Computer"
    "Stop-Computer"
    "New-LocalUser"
    "Remove-LocalUser"
    "Add-LocalGroupMember"
    "Remove-LocalGroupMember"
    "Set-ExecutionPolicy"
    "New-NetFirewallRule"
    "Remove-NetFirewallRule"
)

for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    if echo "$PS_COMMAND" | grep -qi "$pattern"; then
        echo "ERROR: Forbidden command detected: $pattern"
        echo ""
        echo "This command is not allowed by the windows-remote skill."
        echo "If you need to perform this operation, please do so manually."
        exit 1
    fi
done

echo "========================================"
echo "Worker: $WORKER_NAME"
echo "Port: $TUNNEL_PORT"
echo "User: $SSH_USER"
echo "Notes: $NOTES"
echo "========================================"
echo "Command: $PS_COMMAND"
echo "========================================"
echo ""

# Execute the command
ssh -p "$TUNNEL_PORT" -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new \
    "${SSH_USER}@localhost" \
    powershell -Command "$PS_COMMAND"

EXIT_CODE=$?

echo ""
echo "========================================"
echo "Exit code: $EXIT_CODE"
echo "========================================"

exit $EXIT_CODE
