#!/usr/bin/env bash
# install.sh - Install acli to /usr/local/bin or ~/.local/bin
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/danielorlando97/acli/main/install.sh | bash
#   # or
#   ./install.sh [--prefix /custom/path]

set -e

REPO="danielorlando97/acli"
SCRIPT_NAME="acli"
RAW_URL="https://raw.githubusercontent.com/$REPO/main/bin/$SCRIPT_NAME"

# Determine install directory
PREFIX="/usr/local/bin"
if [ "${1}" = "--prefix" ] && [ -n "${2}" ]; then
  PREFIX="$2"
elif [ ! -w "/usr/local/bin" ]; then
  PREFIX="$HOME/.local/bin"
  mkdir -p "$PREFIX"
fi

DEST="$PREFIX/$SCRIPT_NAME"

echo "→ Downloading acli..."
curl -fsSL "$RAW_URL" -o "$DEST"
chmod +x "$DEST"

echo "✓ acli installed at $DEST"

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$PREFIX"; then
  echo ""
  echo "⚠ Note: '$PREFIX' may not be in your PATH."
  echo "  Add this to your ~/.zshrc or ~/.bashrc:"
  echo "  export PATH=\"$PREFIX:\$PATH\""
fi

echo ""
echo "Get started:"
echo "  acli help"
echo "  acli create my-work"
