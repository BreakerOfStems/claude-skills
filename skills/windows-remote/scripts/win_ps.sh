#!/bin/bash
# win_ps.sh
# Execute PowerShell commands on Windows workers via SSH tunnel

set -e

usage() {
    echo "Usage: $0 <port> <user> <powershell-command>"
    echo ""
    echo "Executes a PowerShell command on a Windows worker via SSH tunnel."
    echo ""
    echo "Arguments:"
    echo "  port    - The localhost port for the SSH tunnel"
    echo "  user    - The SSH username"
    echo "  command - The PowerShell command to execute"
    echo ""
    echo "Examples:"
    echo "  $0 2222 admin 'Get-Service'"
    echo "  $0 2222 admin 'Get-ChildItem C:\\Apps'"
    echo "  $0 2223 admin 'Restart-Service MyApp'"
    exit 1
}

if [ $# -lt 3 ]; then
    usage
fi

TUNNEL_PORT="$1"
SSH_USER="$2"
shift 2
PS_COMMAND="$*"

# Validate port is numeric
if ! [[ "$TUNNEL_PORT" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Port must be a number"
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
echo "Port: $TUNNEL_PORT"
echo "User: $SSH_USER"
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
