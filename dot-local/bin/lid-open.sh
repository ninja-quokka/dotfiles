#!/bin/bash
# Log the event for debugging
echo "$(date): Laptop lid opened." >> /tmp/lid_open_log.txt

# --- YOUR CUSTOM COMMANDS GO HERE ---
# /usr/bin/notify-send "System Resumed" "The lid has been opened and the script ran."

hyprctl keyword monitor "eDP-2,preferred,auto-down,2"

exit 0
