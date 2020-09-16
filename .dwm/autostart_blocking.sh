#!/bin/bash

~/.screenlayout/dualmonitor.sh

pidof dunst || dunst &

pidof xfce-polkit || /usr/lib/xfce-polkit/xfce-polkit &

pidof picom || picom -f &

pidof parcellite || parcellite &

pgrep -u $UID -x udiskie || udiskie &

# Set wallpaper and colors with wal
wal -i ~/Pictures/wallpaper.jpg
dwmc xrdb


# Start/Reload sxhkd
~/.local/bin/start_sxhkd

# Start dwmblocks
~/.local/bin/statusbar/start

st -c mail neomutt &

disown
