#!/bin/bash

~/.screenlayout/dualmonitor.sh

pidof dunst || dunst &

pgrep -u $UID -x vorta > /dev/null || vorta &

pidof xfce-polkit || /usr/lib/xfce-polkit/xfce-polkit &

pidof picom || picom -f &

pidof parcellite || parcellite &

pgrep -u $UID -x udiskie || udiskie &

# Set wallpaper and colors with wal
wal -i ~/Pictures/wallpaper.jpg


# Start/Reload sxhkd
~/.local/bin/start_sxhkd

disown
