#!/bin/bash
# svc_status.sh
# Comprehensive service status check with recent logs

set -e

usage() {
    echo "Usage: $0 <service-name>"
    echo ""
    echo "Shows comprehensive status for a systemd service including:"
    echo "  - Current service status"
    echo "  - Recent journal entries"
    echo ""
    echo "Example:"
    echo "  $0 nginx"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

SERVICE="$1"

# Validate service name (basic sanitization)
if ! echo "$SERVICE" | grep -qE '^[a-zA-Z0-9_@.-]+$'; then
    echo "ERROR: Invalid service name format"
    exit 1
fi

echo "========================================"
echo "Service Status: $SERVICE"
echo "========================================"
echo ""

# Check if service exists
if ! systemctl list-unit-files --type=service | grep -q "^${SERVICE}"; then
    # Try with .service suffix
    if ! systemctl list-unit-files --type=service | grep -q "^${SERVICE}.service"; then
        echo "WARNING: Service '$SERVICE' may not exist"
        echo ""
    fi
fi

echo "--- Service Status ---"
systemctl status "$SERVICE" --no-pager 2>&1 || true
echo ""

echo "--- Recent Logs (last 200 lines) ---"
journalctl -u "$SERVICE" --no-pager -n 200 2>&1 || echo "No logs available"
echo ""

echo "--- Service Properties ---"
echo "Active State: $(systemctl show "$SERVICE" --property=ActiveState --value 2>/dev/null || echo 'unknown')"
echo "Sub State: $(systemctl show "$SERVICE" --property=SubState --value 2>/dev/null || echo 'unknown')"
echo "Load State: $(systemctl show "$SERVICE" --property=LoadState --value 2>/dev/null || echo 'unknown')"
echo "Main PID: $(systemctl show "$SERVICE" --property=MainPID --value 2>/dev/null || echo 'unknown')"
echo "Memory: $(systemctl show "$SERVICE" --property=MemoryCurrent --value 2>/dev/null || echo 'unknown')"
echo ""

echo "========================================"
echo "Status check complete"
echo "========================================"
