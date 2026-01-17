#!/bin/bash
# unity_build.sh
# Run Unity headless build with proper logging and error handling

set -e

usage() {
    echo "Usage: $0 <project-path> <build-method> [log-file]"
    echo ""
    echo "Arguments:"
    echo "  project-path  Path to Unity project"
    echo "  build-method  Static method to execute (e.g., BuildScript.PerformBuild)"
    echo "  log-file      Optional log file path (default: ~/workspace/_artifacts/build.log)"
    echo ""
    echo "Examples:"
    echo "  $0 ~/workspace/my-game BuildScript.PerformBuild"
    echo "  $0 ~/workspace/my-game CI.BuildLinuxServer ~/logs/build.log"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

PROJECT_PATH="$1"
BUILD_METHOD="$2"
LOG_FILE="${3:-$HOME/workspace/_artifacts/build.log}"

# Validate project path
if [ ! -d "$PROJECT_PATH" ]; then
    echo "ERROR: Project path does not exist: $PROJECT_PATH"
    exit 1
fi

if [ ! -f "$PROJECT_PATH/Assets" ] && [ ! -d "$PROJECT_PATH/Assets" ]; then
    echo "ERROR: Not a valid Unity project (no Assets folder): $PROJECT_PATH"
    exit 1
fi

# Create log directory
LOG_DIR=$(dirname "$LOG_FILE")
mkdir -p "$LOG_DIR"

# Find Unity executable
UNITY_PATH=$(find /opt/unity* ~/.local/share/Unity/Hub/Editor -name "Unity" -type f 2>/dev/null | head -1)

if [ -z "$UNITY_PATH" ]; then
    echo "ERROR: Unity Editor not found. Install an editor first."
    exit 1
fi

echo "========================================"
echo "Unity Build"
echo "========================================"
echo "Project: $PROJECT_PATH"
echo "Method:  $BUILD_METHOD"
echo "Log:     $LOG_FILE"
echo "Unity:   $UNITY_PATH"
echo "========================================"
echo ""
echo "Starting build..."

# Run build
"$UNITY_PATH" \
    -quit \
    -batchmode \
    -nographics \
    -projectPath "$PROJECT_PATH" \
    -executeMethod "$BUILD_METHOD" \
    -logFile "$LOG_FILE"

EXIT_CODE=$?

echo ""
echo "========================================"
echo "Build completed with exit code: $EXIT_CODE"
echo "========================================"

# Show log summary
if [ -f "$LOG_FILE" ]; then
    echo ""
    echo "--- Log Summary ---"

    # Check for errors
    ERROR_COUNT=$(grep -c "error CS\|Error:\|FAILED\|Exception:" "$LOG_FILE" 2>/dev/null || echo "0")

    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "Errors found: $ERROR_COUNT"
        echo ""
        echo "Error details:"
        grep -n "error CS\|Error:\|FAILED\|Exception:" "$LOG_FILE" | head -20
    else
        echo "No errors found in log"
    fi

    # Show last few lines
    echo ""
    echo "--- Last 10 lines ---"
    tail -10 "$LOG_FILE"
fi

echo ""
echo "Full log: $LOG_FILE"

exit $EXIT_CODE
