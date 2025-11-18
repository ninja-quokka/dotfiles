#!/usr/bin/env bash

# Needs to be ran with sudo

cat << EOF > /etc/systemd/system/keyboard_backlight.service
[Unit]
Description=Execute keyboard backlight script after system resume
After=suspend.target sleep.target
BindsTo=suspend.target sleep.target

[Service]
Type=oneshot
ExecStart=$HOME/.local/bin/bk.py 3

[Install]
WantedBy=suspend.target sleep.target
EOF

systemctl daemon-reload

systemctl enable keyboard_backlight.service

systemctl status keyboard_backlight.service | cat
