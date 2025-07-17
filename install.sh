#!/bin/bash
set -e

# Paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_SRC="$REPO_DIR/scripts"
AUDIOS_SRC="$REPO_DIR/audios"
SCRIPTS_DEST="$HOME/scripts"
MUSIC_DIR="$HOME/Music"
FOCUS_AUDIOS="$MUSIC_DIR/focusAudios"

# Create scripts dir if missing
mkdir -p "$SCRIPTS_DEST"

# Copy scripts if not already present
for script in "$SCRIPTS_SRC"/*.sh; do
    base="$(basename "$script")"
    if [ ! -f "$SCRIPTS_DEST/$base" ]; then
        cp "$script" "$SCRIPTS_DEST/$base"
        chmod +x "$SCRIPTS_DEST/$base"
        echo "Installed $base to $SCRIPTS_DEST"
    else
        echo "$base already exists in $SCRIPTS_DEST, skipping."
    fi
done

# Handle audios
if [ -d "$MUSIC_DIR" ]; then
    mkdir -p "$FOCUS_AUDIOS"
    for audio in "$AUDIOS_SRC"/*.mp3; do
        base="$(basename "$audio")"
        if [ ! -f "$FOCUS_AUDIOS/$base" ]; then
            cp "$audio" "$FOCUS_AUDIOS/$base"
            echo "Installed $base to $FOCUS_AUDIOS"
        else
            echo "$base already exists in $FOCUS_AUDIOS, skipping."
        fi
    done
else
    echo "No $MUSIC_DIR found. Audios will remain in $AUDIOS_SRC."
fi

echo "\nInstallation complete!"
echo "Add the following keybinds to your Hyprland config (keybindings.conf):"
echo "bindd = SUPER Control, R, exec, $SCRIPTS_DEST/toggle_rain.sh"
echo "bindd = SUPER Control, B, exec, $SCRIPTS_DEST/toggle_brown_noise.sh"
echo "bindd = SUPER Control, equal, exec, $SCRIPTS_DEST/toggle_ambient_volume.sh"
echo "\nEnjoy your focus audios!" 