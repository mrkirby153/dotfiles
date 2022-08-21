#!/bin/bash


pidof DiscordCanary || discord-canary --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy &

pidof spotify || spotify &

pidof 1password || 1password --silent &

disown
