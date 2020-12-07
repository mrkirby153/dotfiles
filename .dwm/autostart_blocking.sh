#!/bin/bash

~/.screenlayout/dualmonitor.sh

pidof dunst || dunst &

pidof xfce-polkit || /usr/lib/xfce-polkit/xfce-polkit &

pidof picom || picom -f &

pidof parcellite || parcellite &

pgrep -u $UID -x udiskie || udiskie &

# Set wallpaper and colors with wal
# wal -i ~/Pictures/wallpaper.jpg
feh --bg-fill ~/Pictures/wallpaper.jpg
# wal --theme base16-nord
wal -f ~/theme
dwmc xrdb


# Start/Reload sxhkd
~/.local/bin/start_sxhkd

# Start dwmblocks
~/.local/bin/statusbar/start

disown
