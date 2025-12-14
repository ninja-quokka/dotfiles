#!/usr/bin/env bash

# Needs to be ran with sudo

cat << 'EOF' > /usr/lib/systemd/system-sleep/keyboard_backlight.sh
#!/bin/sh

case $1 in
    pre) # This block runs BEFORE suspend/hibernate
        systemctl stop keyboard_backlight.service
        ;;
    post) # This block runs AFTER resume/thaw
        systemctl start keyboard_backlight.service
        ;;
esac
EOF

cat << 'EOF' > /etc/systemd/system/keyboard_backlight.service
[Unit]
Description=Control Zenbook Duo keyboard backlight

[Service]
Type=oneshot
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

ExecStart=/usr/local/bin/bk.py 3
ExecStop=/usr/local/bin/bk.py 0

[Install]
WantedBy=multi-user.target
EOF

cp ./dot-local/bin/bk.py /usr/local/bin/bk.py

cat << 'EOF' > /etc/systemd/system/zenbook-keyboard-monitor.service
[Unit]
Description=Launch inotifywait to watch for ZenBook Keyboard add and remove action
After=default.target

[Service]
Type=simple
ExecStart=/usr/local/bin/keyboard_event_handler.sh
Restart=always
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

cp ./dot-local/bin/keyboard_event_handler.sh /usr/local/bin/keyboard_event_handler.sh

cat << 'EOF' > /etc/systemd/system/zenbook-display-brightness-monitor.path
[Unit]
Description=Watch for changes to the main backlight file

[Path]
PathModified=/sys/class/backlight/intel_backlight/brightness

[Install]
WantedBy=multi-user.target
EOF

cat << 'EOF' > /etc/systemd/system/zenbook-display-brightness-monitor.service
[Unit]
Description=Sync Zenbook Duo display backlight

[Service]
Type=oneshot
RemainAfterExit=no
StandardOutput=journal
StandardError=journal

ExecStart=bash -c 'cat /sys/class/backlight/intel_backlight/brightness | tee /sys/class/backlight/card1-eDP-2-backlight/brightness'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable --now keyboard_backlight.service zenbook-keyboard-monitor.service zenbook-display-brightness-monitor.path zenbook-display-brightness-monitor.service

systemctl status keyboard_backlight.service | cat

systemctl status zenbook-keyboard-monitor.service | cat

# Set keyboard brightness via bluetooth
# Edit /etc/bluetooth/main.conf to add:
# [GATT]
# ExportClaimedServices = read-write
#
# $ systemctl restart bluetooth.service
#
# $ bluetoothctl &>/dev/null <<EOF
# gatt.select-attribute /org/bluez/hci0/dev_$(bluetoothctl devices | grep 'ASUS Zenbook Duo Keyboard' | awk '{m=$2;gsub(/:/,"_",m);print m;}')/service001b/char003b
# gatt.write "0xba 0xc5 0xc4 0x02"
# EOF
