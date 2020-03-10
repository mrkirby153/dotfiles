#!/bin/bash

# Set monitors
~/.screenlayout/dualmonitor.sh

sleep 1

# Start polybar
~/.local/bin/launch_polybar

# Notification daemon
dunst &

# Volume icon
volumeicon &

# Backups
vorta &

killall xfce-polkit;
/usr/lib/xfce-polkit/xfce-polkit &

# Start ckb-next if a corsair keyboard is plugged in
~/.local/bin/ckb_start

# Compositor
picom -f &

# Start cava & spotify on ws10
~/.local/bin/start_music
sleep 1

# Start discord and thunderbird on ws2
~/.local/bin/start_discord_thunderbird

parcellite &

udiskie &

# Disown forked programs
disown

sleep 1
