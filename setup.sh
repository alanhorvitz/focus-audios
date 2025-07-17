#!/bin/bash
set -e

# Check for Hyprland
if ! pgrep -x Hyprland > /dev/null && [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ]; then
    echo "[ERROR] Hyprland is not running. Please run this script inside a Hyprland session." >&2
    exit 1
fi

# Clone the repo if not already present
REPO_URL="https://github.com/alanhorvitz/focus-audios.git"
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

# Add keybinds to Hyprland config
HYPR_DIR="$HOME/.config/hypr"
KEYBINDS_FILE="$HYPR_DIR/keybindings.conf"
HYPRLAND_FILE="$HYPR_DIR/hyprland.conf"

KEYBINDS="bindd = SUPER Control, R, exec, ~/scripts/toggle_rain.sh\nbindd = SUPER Control, B, exec, ~/scripts/toggle_brown_noise.sh\nbindd = SUPER Control, equal, exec, ~/scripts/toggle_ambient_volume.sh"

add_keybinds() {
    local file="$1"
    local added=false
    for bind in "bindd = SUPER Control, R, exec, ~/scripts/toggle_rain.sh" \
                "bindd = SUPER Control, B, exec, ~/scripts/toggle_brown_noise.sh" \
                "bindd = SUPER Control, equal, exec, ~/scripts/toggle_ambient_volume.sh"; do
        if ! grep -Fxq "$bind" "$file" 2>/dev/null; then
            echo "$bind" >> "$file"
            added=true
        fi
    done
    if [ "$added" = true ]; then
        echo "Added focus-audios keybinds to $file"
    else
        echo "Keybinds already present in $file, skipping."
    fi
}

if [ -f "$KEYBINDS_FILE" ]; then
    add_keybinds "$KEYBINDS_FILE"
elif [ -f "$HYPRLAND_FILE" ]; then
    add_keybinds "$HYPRLAND_FILE"
else
    mkdir -p "$HYPR_DIR"
    add_keybinds "$HYPRLAND_FILE"
fi 