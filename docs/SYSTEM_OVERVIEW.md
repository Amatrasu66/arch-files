# Arch Linux System Architecture Overview

## Executive Summary
This document provides an engineering overview of the reference Arch Linux system configuration, captured directly from a Lenovo ThinkPad E560. The environment is architected around the modern Wayland protocol, utilizing **Niri** (a scrollable-tiling Wayland compositor) and **Modesty** (a dynamic island desktop shell built on QuickShell/QtQuick).

## Architectural Pillars

### 1. Compositor & Window Management
- **Compositor**: Niri 26.04-1 (x86_64 Wayland).
- **Paradigm**: Scrollable tiling on an infinite horizontal strip.
- **Display Scaling & Resolution**: External HDMI 1080p @ 60Hz scaled at 1.4x (effective logical viewport: 1371x771). Internal laptop display eDP-1 is disabled.
- **XWayland**: Handled via `xwayland-satellite` (out-of-process isolation).

### 2. Desktop Shell & Dynamic Island
- **Framework**: QuickShell 0.3.2 (QtQuick/QML).
- **Shell Project**: Modesty (`https://github.com/sandeepbist/Modesty.git`) at commit `690af8b` with extensive custom modules.
- **Components Provided**:
  - Top Dynamic Island (collapsed status pill, hovered expansion, clock pill, system resource pill).
  - Quick Settings Control Center (Wi-Fi, Bluetooth, Audio Sink/Source, Display scaling, Power).
  - Native Wayland Lockscreen (`ext-session-lock-v1` integration).
  - Media player cards, calendar view, notification history, quick notes, and command canvas.

### 3. Audio & Multimedia
- **Server**: PipeWire 1.6.10 with `wireplumber` session manager.
- **Compatibility**: PulseAudio API emulation (`pipewire-pulse`) and ALSA bridge (`pipewire-alsa`).
- **Routing**: Active Bluetooth A2DP/HFP profile (CMF Buds) alongside HDMI stereo output.

### 4. Visual Theme
- **Palette**: Catppuccin Mocha with Mauve accent.
- **Toolkit Integration**: GTK 3/4 with `catppuccin-mocha-mauve-standard+default`, Qt Fusion with dark palette, and Papirus-Dark icons.
- **Glassmorphic Accents**: Restricted strictly to Kitty terminal (`background_opacity 0.82`, `background_blur 1`).
