#!/bin/bash


pidof DiscordCanary || setsid -f discord-canary --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy

pidof spotify || setsid -f spotify-launcher

pidof 1password || setsid -f /sbin/1password --silent
numlockx

setxkbmap -option compose:ralt

