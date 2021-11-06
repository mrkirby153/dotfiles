#!/bin/bash

~/.screenlayout/dualmonitor.sh

pidof dunst || dunst &

pidof xfce-polkit || /usr/lib/xfce-polkit/xfce-polkit &

pidof picom || picom -f &

pidof parcellite || parcellite -n &

pgrep -u $UID -x udiskie || udiskie &

pidof geoclue || /usr/lib/geoclue-2.0/demos/agent &

pgrep -u $UID -x redshift-gtk || redshift-gtk &

pidof kdeconnectd || /usr/lib/kdeconnectd &
pidof kdeconnect-indicator || kdeconnect-indicator &

# Set wallpaper and colors with wal
# wal -i ~/Pictures/wallpaper.jpg
feh --bg-fill ~/Pictures/wallpaper
# wal --theme base16-nord
wal -f ~/theme
dwmc xrdb


# Start/Reload sxhkd
~/.local/bin/start_sxhkd

# Start dwmblocks
~/.local/bin/statusbar/start

disown
