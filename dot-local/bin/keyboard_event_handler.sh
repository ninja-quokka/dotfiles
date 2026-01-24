#!/usr/bin/env bash

# --- Monitor Keyboard attach state ---
while true
do
  sleep 1 # Prevent debounce events

  # Run inotifywait, waiting for the 'attrib' event recursively
  /usr/bin/inotifywait -r -e attrib /dev/bus/usb/*/

  # Check the exit status of inotifywait. If it exited (0), an event occurred.
  if [ $? -eq 0 ]; then

    # Check if the keyboard is attached
    if grep -l "1b2c" /sys/bus/usb/devices/*/idProduct > /dev/null 2>&1; then
      echo "Keyboard ATTACHED"

      # Keyboard backlight turns on when connected

      # Disable secondary bottom screen when keyboard attached
      hyprctl keyword monitor "eDP-2,disable"
    else
      echo "Keyboard DETATCHED"

      # Enable secondary bottom screen when keyboard detatched
      hyprctl keyword monitor "eDP-2,preferred,auto-down,2"

      sleep 3

      # Enable keyboard backlight
      zenbookduo_keyboard_control.sh 1
    fi
  else
    # Handle unexpected exit (e.g., if the path becomes unavailable)
    echo "Inotifywait failed. Sleeping for 5 seconds before restarting."
    sleep 5
  fi
done
