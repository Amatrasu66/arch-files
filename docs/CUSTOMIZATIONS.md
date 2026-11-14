# Customizations & Modifications Inventory

This document catalogs every behavioral and visual customization implemented across the system.

## 1. Niri Compositor
- **Scrollable Tiling**: Infinite horizontal ribbon workflow.
- **Gaps**: 16 logical pixels around windows.
- **Focus Ring**: Catppuccin Mauve (`#cba6f788`), width 2, rendered behind client decorations via `prefer-no-csd`.
- **Display Output Scaling**: HDMI output fixed to `1.4` scale with `1920x1080@60Hz`. Internal laptop panel disabled.
- **Keybindings**: Mod (Super) mapped to terminal, launcher, dynamic island toggles, and window management.

## 2. Modesty Dynamic Island (QuickShell)
- **Top Center Dynamic Island**: Collapsed idle state showing media status, clock, and system stats.
- **Hover & Expand**: Interactively opens control center, audio slider, network list, and settings.
- **AI Agent Pill**: Custom module (`AiAgentPill.qml`) that displays live status of AI coding agents.
- **Lock Screen**: Native Wayland session lock implementation in `LockContent.qml`.

## 3. Terminal (Kitty)
- **Glassmorphism**: Opacity 0.82 with background blur enabled.
- **Cursor Effects**: Animated cursor trail with decay and light blue highlight (`#89b4fa`).
- **Font**: Adwaita Mono 11.5pt.

## 4. Inactivity & Power Management
- **Multi-stage Inactivity**:
  - 10 minutes: Screen lock via Modesty IPC.
  - 1 hour: System suspend.
  - 6 hours: Clean system shutdown (persisted across suspends using boot ID and session tracking).
