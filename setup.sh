#!/bin/bash
set -e

# Check for Hyprland
if ! pgrep -x Hyprland > /dev/null && [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]; then
    echo "[ERROR] Hyprland is not running. Please run this script inside a Hyprland session." >&2
    exit 1
fi

# Clone the repo if not already present
REPO_URL="https://github.com/YOUR_USERNAME/focus-audios.git"
TARGET_DIR="$HOME/focus-audios"

if [ ! -d "$TARGET_DIR" ]; then
    git clone "$REPO_URL" "$TARGET_DIR"
    echo "Cloned focus-audios repo to $TARGET_DIR"
else
    echo "focus-audios repo already exists at $TARGET_DIR, skipping clone."
fi

cd "$TARGET_DIR"

# Run the installer
bash install.sh 