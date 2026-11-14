# Package Inventory & Architecture Notes

## Overview
The reference system runs Arch Linux (x86_64) on a Lenovo ThinkPad E560.
The package set is highly curated and minimal, consisting of:
- **78 Explicit Native Packages** (via official Arch repositories)
- **7 Explicit Foreign / AUR Packages** (managed via `yay-bin`)
- **0 Flatpaks**
- **598 Automatic Dependencies**
- **Total Packages:** 683

## Key Choices & Justifications

### 1. Compositor & Shell
- **niri**: Modern scrollable-tiling Wayland compositor. Provides dynamic horizontal tile strip workflow.
- **quickshell**: Native QtQuick/QML desktop shell framework powering the Modesty Dynamic Island and Control Center.
- **xwayland-satellite**: Runs XWayland outside the compositor process, improving reliability.
- **swaybg**: Lightweight Wayland wallpaper daemon managed via systemd.
- **swaylock**: Wayland screen locker (complemented by Modesty Dynamic Island lockscreen).
- **fuzzel**: Extremely fast, lightweight Wayland application launcher and dmenu replacement styled in Catppuccin Mocha.

### 2. Audio & Multimedia
- **PipeWire Stack**: `pipewire`, `pipewire-pulse`, `pipewire-alsa`, and `wireplumber` session manager.
- Hardware routing supports internal speakers, HDMI audio (Panasonic TV), and Bluetooth (CMF Buds via bluez5).

### 3. Graphics & Hardware Acceleration
- **Intel HD Graphics 520 (Skylake GT2)**: Driven by `i915` kernel module, `mesa`, `vulkan-intel`, and `intel-media-driver` (VA-API).
- Chromium/Brave flags enable VA-API hardware video decode acceleration on Wayland.

### 4. Development Environment
- Runtime stack: Node.js LTS, pnpm, Python (uv / pipx), Android SDK / Studio, Neovim, and VS Code.
