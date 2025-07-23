CC := gcc
CFLAGS := $(shell pkg-config --cflags hidapi-hidraw appindicator3-0.1 gtk+-3.0) -Wall -Wextra -Werror -O2
LDFLAGS := $(shell pkg-config --libs hidapi-hidraw appindicator3-0.1 gtk+-3.0)

SRC := k380-fnlock.c
TARGET := bin/k380-fnlock

$(shell mkdir -p bin)

.PHONY: all check-deps clean install

all: check-deps $(TARGET)

check-deps:
	@pkg-config --exists hidapi-hidraw || { echo "Missing dependency: hidapi-hidraw"; exit 1; }
	@pkg-config --exists appindicator3-0.1 || { echo "Missing dependency: appindicator3-0.1"; exit 1; }
	@pkg-config --exists gtk+-3.0 || { echo "Missing dependency: gtk+-3.0"; exit 1; }

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@echo "\033[1;34m[INFO] Installing K380 Fn Lock...\033[0m"
	@echo "\033[1;34m[INFO] Stopping any running k380-fnlock processes...\033[0m"
	pgrep k380-fnlock > /dev/null && sudo killall k380-fnlock || true
	@echo "\033[1;34m[INFO] Copying binary to /usr/local/bin/k380-fnlock\033[0m"
	sudo cp $(TARGET) /usr/local/bin/k380-fnlock
	sudo chmod +x /usr/local/bin/k380-fnlock
	@echo "\033[1;34m[INFO] Creating sudoers file for k380-fnlock: /etc/sudoers.d/k380-fnlock\033[0m"
	@echo "$(shell whoami) ALL=(ALL) NOPASSWD: /usr/local/bin/k380-fnlock" | sudo tee /etc/sudoers.d/k380-fnlock > /dev/null
	@echo "\033[1;34m[INFO] Copying icon to: $$HOME/.local/share/icons/k380-fnlock.png\033[0m"
	cp -f ./assets/icon.png "$$HOME/.local/share/icons/k380-fnlock.png"
	@echo "\033[1;34m[INFO] Creating desktop file: $$HOME/.config/autostart/k380-fnlock.desktop\033[0m"
	mkdir -p "$$HOME/.config/autostart"
	rm -f "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo '[Desktop Entry]' > "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Type=Application' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Name=K380 Fn Lock' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Comment=Toggle Fn lock for Logitech K380 keyboard' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Exec=sudo /usr/local/bin/k380-fnlock' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Hidden=false' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'NoDisplay=false' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'X-GNOME-Autostart-enabled=true' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Terminal=false' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo 'Icon=k380-fnlock' >> "$$HOME/.config/autostart/k380-fnlock.desktop"
	@echo "\033[1;34m[INFO] Setting up application menu entry: $$HOME/.local/share/applications/k380-fnlock.desktop\033[0m"
	mkdir -p "$$HOME/.local/share/applications"
	rm -f "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo '[Desktop Entry]' > "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Type=Application' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Name=K380 Fn Lock' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Comment=Toggle Fn lock for Logitech K380 keyboard' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Exec=sudo /usr/local/bin/k380-fnlock' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Icon=k380-fnlock' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Terminal=false' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo 'Categories=Utility;' >> "$$HOME/.local/share/applications/k380-fnlock.desktop"
	@echo "\033[1;34m[INFO] K380 Fn Lock has been installed successfully.\033[0m"