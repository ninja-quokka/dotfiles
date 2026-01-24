#!/usr/bin/env bash

# Kill any existing monitor-sensor processes
killall monitor-sensor 2>/dev/null

monitor-sensor | while read -r line; do
    if [[ $line =~ "Accelerometer orientation changed" ]]; then
        ORIENTATION=$(echo "$line" | awk -F': ' '{print $2}')

        case "$ORIENTATION" in
            normal)
                TRANSFORM=0
                POSITION=auto-down
                ;;
            right-up)
                TRANSFORM=3
                POSITION=auto-right
                ;;
            bottom-up)
                TRANSFORM=2
                POSITION=auto-up
                ;;
            left-up)
                TRANSFORM=1
                POSITION=auto-left
                ;;
        esac

        # Apply to Monitor
        hyprctl keyword monitor "eDP-1,preferred,auto,2,transform,$TRANSFORM"

        grep -q "1b2c" /sys/bus/usb/devices/*/idProduct || \
        hyprctl keyword monitor "eDP-2,preferred,$POSITION,2,transform,$TRANSFORM"
    fi
done
