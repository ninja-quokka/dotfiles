#!/bin/bash

LOGFILE="/var/log/udev_keyboard_events.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

source /tmp/hyprland_signature

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	echo "Error: Could not find Hyprland signature file."
	exit 1
fi

# --- Main Monitoring Loop ---
while true
do
    # Run inotifywait, waiting for the 'attrib' event recursively
    /usr/bin/inotifywait -r -e attrib /dev/bus/usb/*/
    sudo -u ldenny HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE hyprctl notify -1 5000 "rgb(ff1ea3)" "CHANGE DETECTED" >> $LOGFILE

    # Check the exit status of inotifywait. If it exited (0), an event occurred.
    if [ $? -eq 0 ]; then
        echo "USB attribute change detected. Running action script..."

	if grep -l "1b2c" /sys/bus/usb/devices/*/idProduct > /dev/null 2>&1; then
		echo "✅ Match found (grep returned true/0)."
		sudo -u ldenny HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE hyprctl notify -1 5000 "rgb(ff1ea3)" "ATTACHED" >> $LOGFILE

		systemctl start keyboard_backlight.service >> $LOGFILE

		sudo -u ldenny HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE hyprctl keyword monitor "eDP-2,disable" >> $LOGFILE
	else
		echo "❌ No match found (grep returned false/non-0)."
		sudo -u ldenny HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE hyprctl notify -1 5000 "rgb(ff1ea3)" "DETATCHED" >> $LOGFILE

		systemctl stop keyboard_backlight.service >> $LOGFILE

		sudo -u ldenny HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE hyprctl keyword monitor "eDP-2,preferred,auto-down,2" >> $LOGFILE
	fi
    else
        # Handle unexpected exit (e.g., if the path becomes unavailable)
        echo "Inotifywait failed. Sleeping for 5 seconds before restarting."
        sleep 5
    fi
done
