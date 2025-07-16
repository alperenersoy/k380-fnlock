#!/usr/bin/env bash

set -e

sudo killall k380-fnlock || true
sudo cp ./bin/k380-fnlock /usr/local/bin/k380-fnlock
sudo chmod +x /usr/local/bin/k380-fnlock

echo "Creating sudoers file for k380-fnlock: /etc/sudoers.d/k380-fnlock"
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/local/bin/k380-fnlock" | sudo tee /etc/sudoers.d/k380-fnlock > /dev/null

cp -f ./assets/icon.png "$HOME/.local/share/icons/k380-fnlock.png"

mkdir -p "$HOME/.config/autostart"

DIRNAME=$(dirname "$(realpath "$0")")

echo "Creating desktop file: $HOME/.config/autostart/k380-fnlock.desktop"

rm -f "$HOME/.config/autostart/k380-fnlock.desktop"

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
Icon=k380-fnlock
EOF

echo "Setting up start menu entry for K380 Fn Lock"

mkdir -p "$HOME/.local/share/applications"

rm -f "$HOME/.local/share/applications/k380-fnlock.desktop"

cat <<EOF > "$HOME/.local/share/applications/k380-fnlock.desktop"
[Desktop Entry]
Type=Application
Name=K380 Fn Lock
Comment=Toggle Fn lock for Logitech K380 keyboard
Exec=sudo /usr/local/bin/k380-fnlock
Icon=k380-fnlock
Terminal=false
Categories=Utility;
EOF

echo "K380 Fn Lock has been installed successfully."