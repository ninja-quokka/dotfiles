#!/usr/bin/env bash

# Needs to be ran with sudo

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

systemctl enable --now zenbook-display-brightness-monitor.path zenbook-display-brightness-monitor.service

# Set keyboard brightness via bluetooth
# Edit /etc/bluetooth/main.conf to add:
# [GATT]
# ExportClaimedServices = read-write
#
# $ systemctl restart bluetooth.service
