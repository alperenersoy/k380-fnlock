#!/usr/bin/env bash

set -e

sudo cp ./bin/k380-fnlock /usr/local/bin/k380-fnlock

sudo chmod +x /usr/local/bin/k380-fnlock

mkdir -p "$HOME/.config/autostart"

DIRNAME=$(dirname "$(realpath "$0")")

echo "Creating sudoers file for k380-fnlock: /etc/sudoers.d/k380-fnlock"
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/local/bin/k380-fnlock" | sudo tee /etc/sudoers.d/k380-fnlock > /dev/null

echo "Creating desktop file: $HOME/.config/autostart/k380-fnlock.desktop"

cat <<EOF > "$HOME/.config/autostart/k380-fnlock.desktop"
[Desktop Entry]
Type=Application
Name=K380 Fn Lock
Comment=Toggle Fn lock for Logitech K380 keyboard
Exec=sudo /usr/local/bin/k380-fnlock
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

echo "K380 Fn Lock has been installed successfully."