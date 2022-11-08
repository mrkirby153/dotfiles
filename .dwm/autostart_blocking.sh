#!/bin/bash

~/.screenlayout/dualmonitor.sh

pidof dunst || setsid -f dunst

pidof xfce-polkit || setsid -f /usr/lib/xfce-polkit/xfce-polkit

pidof picom || setsid -f picom -f

pidof parcellite || setsid -f parcellite -n

pgrep -u $UID -x udiskie || setsid -f udiskie

pidof geoclue || setsid -f /usr/lib/geoclue-2.0/demos/agent

pgrep -u $UID -x redshift-gtk || setsid -f redshift-gtk &

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

# Start ckb-next if needed
~/.local/bin/ckb_start

disown
