#!/usr/bin/env bash

# Rofi power menu for Hyprland
# Provides options: Lock, Suspend, Logout, Reboot, Shutdown

options="🔒 Lock\n💤 Suspend\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" \
    -theme-str 'window {width: 300px;}' \
    -theme-str 'listview {lines: 5;}')

case $chosen in
    "🔒 Lock")
        hyprlock
        ;;
    "💤 Suspend")
        systemctl suspend
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
esac
