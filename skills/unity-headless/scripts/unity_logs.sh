#!/bin/bash
# unity_logs.sh
# Parse Unity logs for errors and generate concise reports

set -e

usage() {
    echo "Usage: $0 <command> [log-file]"
    echo ""
    echo "Commands:"
    echo "  errors [log-file]    Extract all errors from log"
    echo "  summary [log-file]   Generate concise error summary"
    echo "  tail [log-file]      Show last 50 lines of log"
    echo "  find                 Find Unity log files"
    echo ""
    echo "Default log locations:"
    echo "  ~/.config/unity3d/Editor.log"
    echo "  ~/workspace/_artifacts/build.log"
    exit 1
}

# Default log locations
find_default_log() {
    # Check common locations
    local LOCATIONS=(
        "$HOME/.config/unity3d/Editor.log"
        "$HOME/workspace/_artifacts/build.log"
        "/tmp/unity-build.log"
    )

    for loc in "${LOCATIONS[@]}"; do
        if [ -f "$loc" ]; then
            echo "$loc"
            return 0
        fi
    done

    echo ""
    return 1
}

cmd_errors() {
    local LOG_FILE="$1"

    if [ -z "$LOG_FILE" ]; then
        LOG_FILE=$(find_default_log)
        if [ -z "$LOG_FILE" ]; then
            echo "ERROR: No log file found. Specify path or run a build first."
            exit 1
        fi
    fi

    if [ ! -f "$LOG_FILE" ]; then
        echo "ERROR: Log file not found: $LOG_FILE"
        exit 1
    fi

    echo "Errors from: $LOG_FILE"
    echo "========================================"

    # Extract errors with line numbers
    grep -n -E "error CS[0-9]+|Error:|FAILED|Exception:|NullReferenceException|MissingReferenceException" "$LOG_FILE" || echo "No errors found"
}

cmd_summary() {
    local LOG_FILE="$1"

    if [ -z "$LOG_FILE" ]; then
        LOG_FILE=$(find_default_log)
        if [ -z "$LOG_FILE" ]; then
            echo "ERROR: No log file found"
            exit 1
        fi
    fi

    if [ ! -f "$LOG_FILE" ]; then
        echo "ERROR: Log file not found: $LOG_FILE"
        exit 1
    fi

    echo "Unity Log Summary"
    echo "========================================"
    echo "File: $LOG_FILE"
    echo "Size: $(du -h "$LOG_FILE" | cut -f1)"
    echo ""

    # Count different types of issues
    local CS_ERRORS=$(grep -c "error CS" "$LOG_FILE" 2>/dev/null || echo "0")
    local WARNINGS=$(grep -c "warning CS\|Warning:" "$LOG_FILE" 2>/dev/null || echo "0")
    local EXCEPTIONS=$(grep -c "Exception:" "$LOG_FILE" 2>/dev/null || echo "0")
    local NULL_REFS=$(grep -c "NullReferenceException" "$LOG_FILE" 2>/dev/null || echo "0")

    echo "Issue Counts:"
    echo "  Compile errors (CS):     $CS_ERRORS"
    echo "  Warnings:                $WARNINGS"
    echo "  Exceptions:              $EXCEPTIONS"
    echo "  NullReferenceException:  $NULL_REFS"
    echo ""

    if [ "$CS_ERRORS" -gt 0 ]; then
        echo "--- Compile Errors ---"
        grep "error CS" "$LOG_FILE" | sort | uniq -c | sort -rn | head -10
        echo ""
    fi

    if [ "$EXCEPTIONS" -gt 0 ]; then
        echo "--- Exceptions ---"
        grep "Exception:" "$LOG_FILE" | sort | uniq -c | sort -rn | head -10
        echo ""
    fi

    # Build result
    if grep -q "Build succeeded" "$LOG_FILE" 2>/dev/null; then
        echo "Build Result: SUCCESS"
    elif grep -q "Build failed\|FAILED" "$LOG_FILE" 2>/dev/null; then
        echo "Build Result: FAILED"
    else
        echo "Build Result: UNKNOWN"
    fi
}

cmd_tail() {
    local LOG_FILE="$1"

    if [ -z "$LOG_FILE" ]; then
        LOG_FILE=$(find_default_log)
        if [ -z "$LOG_FILE" ]; then
            echo "ERROR: No log file found"
            exit 1
        fi
    fi

    if [ ! -f "$LOG_FILE" ]; then
        echo "ERROR: Log file not found: $LOG_FILE"
        exit 1
    fi

    echo "Last 50 lines of: $LOG_FILE"
    echo "========================================"
    tail -50 "$LOG_FILE"
}

cmd_find() {
    echo "Searching for Unity log files..."
    echo ""

    # Common locations
    echo "Standard locations:"
    for loc in "$HOME/.config/unity3d/Editor.log" "$HOME/workspace/_artifacts/"*.log; do
        if [ -f "$loc" ]; then
            echo "  $loc ($(du -h "$loc" | cut -f1))"
        fi
    done

    # Recent logs
    echo ""
    echo "Recent log files (last 24h):"
    find "$HOME" -name "*.log" -mtime -1 -type f 2>/dev/null | grep -i unity | head -10 || echo "  None found"
}

# Main
if [ $# -eq 0 ]; then
    usage
fi

COMMAND="$1"
shift

case "$COMMAND" in
    errors)
        cmd_errors "$@"
        ;;
    summary)
        cmd_summary "$@"
        ;;
    tail)
        cmd_tail "$@"
        ;;
    find)
        cmd_find
        ;;
    *)
        echo "Unknown command: $COMMAND"
        usage
        ;;
esac
