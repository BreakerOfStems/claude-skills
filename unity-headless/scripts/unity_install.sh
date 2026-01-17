#!/bin/bash
# unity_install.sh
# Install Unity Hub, Editor versions, and manage licenses

set -e

usage() {
    echo "Usage: $0 <command> [args]"
    echo ""
    echo "Commands:"
    echo "  hub                          Install Unity Hub"
    echo "  editor <version> [modules]   Install Editor version with optional modules"
    echo "  license <serial>             Activate license with serial"
    echo "  return-license               Return current license"
    echo ""
    echo "Examples:"
    echo "  $0 hub"
    echo "  $0 editor 2022.3.0f1 linux-il2cpp,linux-server"
    echo "  $0 license XXXX-XXXX-XXXX-XXXX-XXXX"
    exit 1
}

install_hub() {
    echo "Installing Unity Hub..."

    # Check if already installed
    if command -v unityhub &> /dev/null; then
        echo "Unity Hub already installed"
        unityhub --version
        return 0
    fi

    # Add Unity repository
    wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -
    sudo sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'

    # Install
    sudo apt update
    sudo apt install -y unityhub

    echo "Unity Hub installed successfully"
    unityhub --version
}

install_editor() {
    local VERSION="$1"
    local MODULES="$2"

    if [ -z "$VERSION" ]; then
        echo "ERROR: Editor version required"
        echo "Available versions:"
        unityhub --headless editors --releases 2>/dev/null | head -20 || echo "  (run 'unityhub --headless editors --releases' to see)"
        exit 1
    fi

    echo "Installing Unity Editor $VERSION..."

    # Build module arguments
    MODULE_ARGS=""
    if [ -n "$MODULES" ]; then
        IFS=',' read -ra MOD_ARRAY <<< "$MODULES"
        for mod in "${MOD_ARRAY[@]}"; do
            MODULE_ARGS="$MODULE_ARGS --module $mod"
        done
    fi

    # Install editor
    unityhub --headless install --version "$VERSION" $MODULE_ARGS

    echo "Unity Editor $VERSION installed successfully"
}

activate_license() {
    local SERIAL="$1"

    if [ -z "$SERIAL" ]; then
        echo "ERROR: Serial key required"
        echo ""
        echo "For serial-based activation, provide your license serial."
        echo "Format: XXXX-XXXX-XXXX-XXXX-XXXX"
        exit 1
    fi

    # Find Unity executable
    UNITY_PATH=$(find /opt/unity* ~/.local/share/Unity/Hub/Editor -name "Unity" -type f 2>/dev/null | head -1)

    if [ -z "$UNITY_PATH" ]; then
        echo "ERROR: Unity Editor not found. Install an editor first."
        exit 1
    fi

    echo "Activating license..."
    echo "Unity path: $UNITY_PATH"
    echo ""
    echo "NOTE: You will be prompted for Unity account email and password"

    read -p "Unity account email: " EMAIL
    read -s -p "Unity account password: " PASSWORD
    echo ""

    "$UNITY_PATH" -quit -batchmode -serial "$SERIAL" -username "$EMAIL" -password "$PASSWORD"

    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo "License activated successfully"
    else
        echo "ERROR: License activation failed (exit code: $EXIT_CODE)"
        echo "Check Unity logs for details"
        exit $EXIT_CODE
    fi
}

return_license() {
    # Find Unity executable
    UNITY_PATH=$(find /opt/unity* ~/.local/share/Unity/Hub/Editor -name "Unity" -type f 2>/dev/null | head -1)

    if [ -z "$UNITY_PATH" ]; then
        echo "ERROR: Unity Editor not found"
        exit 1
    fi

    echo "Returning license..."
    "$UNITY_PATH" -quit -batchmode -returnlicense

    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo "License returned successfully"
    else
        echo "ERROR: License return failed (exit code: $EXIT_CODE)"
        exit $EXIT_CODE
    fi
}

# Main
if [ $# -eq 0 ]; then
    usage
fi

COMMAND="$1"
shift

case "$COMMAND" in
    hub)
        install_hub
        ;;
    editor)
        install_editor "$@"
        ;;
    license)
        activate_license "$@"
        ;;
    return-license)
        return_license
        ;;
    *)
        echo "Unknown command: $COMMAND"
        usage
        ;;
esac
