#!/bin/bash
# az_safe_query.sh
# Wrapper for Azure CLI that enforces read-only operations and JSON output

set -e

# List of allowed read-only commands/subcommands
ALLOWED_PATTERNS=(
    "^az account show"
    "^az account list"
    "^az group show"
    "^az group list"
    "^az resource list"
    "^az resource show"
    "^az role assignment list"
    "^az role definition list"
    "^az role definition show"
)

# List of forbidden patterns (mutations)
FORBIDDEN_PATTERNS=(
    "create"
    "update"
    "delete"
    "set"
    "remove"
    "add"
    "assign"
    "unassign"
)

usage() {
    echo "Usage: $0 <az-command-and-args>"
    echo ""
    echo "This wrapper enforces read-only Azure CLI operations."
    echo ""
    echo "Allowed operations:"
    echo "  - az account show/list"
    echo "  - az group show/list"
    echo "  - az resource list/show"
    echo "  - az role assignment list"
    echo "  - az role definition list/show"
    echo ""
    echo "Example:"
    echo "  $0 az resource list --resource-type Microsoft.Compute/virtualMachines"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

# Construct the full command for checking
FULL_CMD="$*"

# Check for forbidden patterns
for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    if echo "$FULL_CMD" | grep -qiw "$pattern"; then
        echo "ERROR: Mutating operation detected: '$pattern'"
        echo ""
        echo "This skill only allows read-only operations."
        echo "Command rejected: $FULL_CMD"
        exit 1
    fi
done

# Verify command matches allowed patterns
ALLOWED=false
for pattern in "${ALLOWED_PATTERNS[@]}"; do
    if echo "$FULL_CMD" | grep -qE "$pattern"; then
        ALLOWED=true
        break
    fi
done

if [ "$ALLOWED" = false ]; then
    echo "ERROR: Command not in allowlist"
    echo ""
    echo "Command rejected: $FULL_CMD"
    echo ""
    echo "Allowed commands:"
    for pattern in "${ALLOWED_PATTERNS[@]}"; do
        echo "  - ${pattern#^}"
    done
    exit 1
fi

# Ensure JSON output is specified
if ! echo "$FULL_CMD" | grep -qE "\-o\s*(json|table|tsv|yaml)|--output\s*(json|table|tsv|yaml)"; then
    # Append JSON output flag
    FULL_CMD="$FULL_CMD -o json"
    echo "Note: Adding '-o json' for consistent output format"
    echo ""
fi

# Execute the command
echo "Executing: $FULL_CMD"
echo "---"
eval "$FULL_CMD"
