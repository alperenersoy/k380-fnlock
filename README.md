# Logitech K380 Fn Lock

<img src="assets/icon.png" alt="K380 Fn Lock Icon">

A system tray utility for toggling the fn lock on Logitech K380 bluetooth keyboards on Linux. Inspiration taken from the [dheygere/k380-fn-lock-for-windows](https://github.com/dheygere/k380-fn-lock-for-windows) project.

## Description

Easily toggle between F1-F12 and media key modes on your Logitech K380 keyboard using a simple system tray indicator. Specified for K380 keyboards, but may work with other Logitech keyboards when vendor ID and product ID are set correctly in the source code.

## Requirements

### System Dependencies

- `hidapi-hidraw` - For HID device communication
- `libappindicator3-0.1` - For system tray integration
- `gtk+-3.0` - For GUI components
- `gcc` - For compilation
- `pkg-config` - For dependency management

## Installation

### 1. Install Dependencies

#### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install build-essential pkg-config libhidapi-dev libappindicator3-dev libgtk-3-dev
```

### 2.1 Compile from Source

If you want to build the program yourself:

```bash
make
```

---

### 2.2 Use Precompiled Binaries

Linux x86_64 binary is available in the `bin/` directory. You can use it without compiling.

## Usage

### Run the Program

Foreground:
```bash
sudo ./bin/k380-fnlock
```

Background:
```bash
sudo ./bin/k380-fnlock > /dev/null 2>&1 &
```

### Install (Optional)

> **Warning:**  
> Installation requires sudo access. This utility needs elevated privileges to access HID devices, so the install process creates a sudoers file to allow running the utility without a password. If you are not comfortable with this, you can run the utility manually without installing.

To start the utility automatically with your desktop session and add it to your application menu, run:

```bash
make install
```