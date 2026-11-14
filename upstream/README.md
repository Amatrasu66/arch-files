# Upstream Projects Registry

This directory documents externally sourced GitHub repositories, their upstream origins, base commit hashes, and local customizations.

## 1. Modesty (`sandeepbist/Modesty`)
- **Upstream URL**: https://github.com/sandeepbist/Modesty
- **Base Commit**: `690af8b` (`main`)
- **Role**: Powers the primary Dynamic Island desktop shell using QuickShell (QtQuick/QML).
- **Local Customizations**:
  - `AiAgentPill.qml` and `ai-agent-status.py` for monitoring AI agent states.
  - Native ext-session-lock-v1 integration in `LockContent.qml`.
  - Catppuccin Mocha theme tuning in `theme/Palette.js`.
  - Refined menus: Bluetooth, Wi-Fi, Audio, and Display submenus.
  - All modifications are preserved in `upstream/modesty-customizations.patch`.

## 2. Reference Projects
- **dynamic-island-hyprland** (`St0rmosu/dynamic-island-hyprland`): Inspected for lock screen architecture.
- **Waybar** (`Alexays/Waybar`): Former status bar. Configuration preserved in `configs/waybar/` for modular deployment if a lightweight C++ bar is preferred.
