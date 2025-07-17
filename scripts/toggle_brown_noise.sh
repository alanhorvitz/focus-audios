#!/bin/bash

SOCKET="/tmp/mpv_brown.sock"
AUDIO="/home/alan/Music/brownNoise.mp3"

if pgrep -f "mpv --title=brown_noise_sound" > /dev/null; then
    # If running, send pause command via IPC
    echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET"
else
    # Start mpv with IPC
    mpv --title=brown_noise_sound --audio-display=no --loop=inf --input-ipc-server="$SOCKET" "$AUDIO" &
fi
