#!/usr/bin/env bash

# Needs to be ran with sudo

cat << EOF > /usr/lib/systemd/system-sleep/keyboard_backlight.sh
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

cat << EOF > /etc/systemd/system/keyboard_backlight.service
[Unit]
Description=Control Zenbook Duo keyboard backlight

[Service]
Type=oneshot
RemainAfterExit=yes

ExecStart=$HOME/.local/bin/bk.py 3
ExecStop=$HOME/.local/bin/bk.py 0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable keyboard_backlight.service

systemctl start keyboard_backlight.service

systemctl status keyboard_backlight.service | cat
