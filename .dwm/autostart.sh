#!/bin/bash


pidof DiscordCanary || discord-canary &

pidof spotify || spotify &

disown
