#!/bin/bash

SOCKET="/tmp/mpv_rain.sock"
AUDIO="/home/alan/Music/rain.mp3"

if pgrep -f "mpv --title=rain_sound" > /dev/null; then
    # If running, send pause command via IPC
    echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET"
else
    # Start mpv with IPC and at 10 minutes (600 seconds)
    mpv --title=rain_sound --audio-display=no --loop=inf --start=600 --input-ipc-server="$SOCKET" "$AUDIO" &
fi
