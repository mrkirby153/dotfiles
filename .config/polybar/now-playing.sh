#!/bin/bash

playerctl -p playerctld status &> /dev/null
if [ $? -ne 0 ]; then
    echo "Nothing Playing"
    exit
fi

playing=$(playerctl -p playerctld status)
status=""

case "$playing" in
"Playing")
    status=""
    ;;
"Paused")
    status=""
    ;;
"Stopped")
    status=""
    ;;
esac

if [ $playing = "Stopped" ]; then
    artist_song="Nothing Playing"
else
    artist_song=$(playerctl -p playerctld metadata --format "{{artist}} - {{title}}")
fi

echo "$status  $artist_song"
