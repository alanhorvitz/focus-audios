#!/bin/bash

# IPC sockets and temp files
RAIN_SOCKET="/tmp/mpv_rain.sock"
BROWN_SOCKET="/tmp/mpv_brown.sock"
RAIN_VOL_FILE="/tmp/mpv_rain_vol"
BROWN_VOL_FILE="/tmp/mpv_brown_vol"

# Helper: set volume, unmute, unpause
set_full_audio() {
    local SOCKET="$1"
    local VOL="$2"
    echo "{ \"command\": [\"set_property\", \"volume\", $VOL] }" | socat - "$SOCKET"
    echo '{ "command": ["set_property", "mute", false] }' | socat - "$SOCKET"
    echo '{ "command": ["set_property", "pause", false] }' | socat - "$SOCKET"
}

# Toggle logic for one mpv instance
# $1 = socket, $2 = vol_file
robust_toggle_volume() {
    local SOCKET="$1"
    local VOL_FILE="$2"
    if [ -S "$SOCKET" ]; then
        CUR_VOL=$(echo '{ "command": ["get_property", "volume"] }' | socat - "$SOCKET" | jq -r '.data')
        if [ -z "$CUR_VOL" ] || [ "$CUR_VOL" == "null" ]; then
            return
        fi
        # If at 30, restore previous volume
        if [ "$(printf '%.0f' "$CUR_VOL")" == "30" ] && [ -f "$VOL_FILE" ]; then
            PREV_VOL=$(cat "$VOL_FILE")
            # Validate previous volume
            if [[ ! "$PREV_VOL" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                PREV_VOL=100
            fi
            set_full_audio "$SOCKET" "$PREV_VOL"
            rm -f "$VOL_FILE"
        else
            # Only save if not already at 60 and no state file
            if [ ! -f "$VOL_FILE" ]; then
                echo "$CUR_VOL" > "$VOL_FILE"
            fi
            echo '{ "command": ["set_property", "volume", 60] }' | socat - "$SOCKET"
        fi
    fi
}

robust_toggle_volume "$RAIN_SOCKET" "$RAIN_VOL_FILE"
robust_toggle_volume "$BROWN_SOCKET" "$BROWN_VOL_FILE" 