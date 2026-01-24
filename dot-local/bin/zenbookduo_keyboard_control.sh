#!/usr/bin/env bash

# Check if the keyboard is attached
keyboard_attached(){
  grep -l "1b2c" /sys/bus/usb/devices/*/idProduct > /dev/null 2>&1
  return $?
}

if keyboard_attached; then
  [[ $1 = 0 ]] && brightnessctl --device='asus::kbd_backlight' set 0
  [[ $1 = 1 ]] && brightnessctl --device='asus::kbd_backlight' set 3
fi

if ! keyboard_attached; then
  device_id=$(bluetoothctl devices | grep 'ASUS Zenbook Duo Keyboard' | awk '{m=$2;gsub(/:/,"_",m);print m;}' | head -1)

  [[ $1 = 0 ]] && printf "gatt.select-attribute /org/bluez/hci0/dev_%s/service001b/char003b\n gatt.write \"0xba 0xc5 0xc4 0x00\"\n exit\n" "$device_id" | bluetoothctl

  [[ $1 = 1 ]] && printf "gatt.select-attribute /org/bluez/hci0/dev_%s/service001b/char003b\n gatt.write \"0xba 0xc5 0xc4 0x02\"\n exit\n" "$device_id" | bluetoothctl
fi
