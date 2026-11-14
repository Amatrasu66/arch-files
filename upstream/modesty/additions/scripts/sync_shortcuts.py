#!/usr/bin/env python3
"""
Centralized Shortcut Registry Generator & Synchronizer
Parses active Niri configuration, Modesty bindings, and installed applications
(Kitty, Brave, Thunar, Fuzzel, Zsh, Antigravity) to produce a single source of truth.
"""

import json
import os
import re
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
REGISTRY_DIR = BASE_DIR / "config" / "shortcuts"
REGISTRY_FILE = REGISTRY_DIR / "shortcut_registry.json"
CUSTOM_FILE = REGISTRY_DIR / "custom_shortcuts.json"
NIRI_CONFIG = Path.home() / ".config" / "niri" / "config.kdl"

def normalize_key(key: str) -> list[str]:
    """Convert a chord like 'Mod+Shift+K' or 'Ctrl+Alt+Delete' to ['Super', 'Shift', 'K']."""
    parts = key.split("+")
    result = []
    for p in parts:
        p = p.strip()
        if p == "Mod":
            result.append("Super")
        elif p.lower() == "super":
            result.append("Super")
        elif p.lower() == "ctrl":
            result.append("Ctrl")
        elif p.lower() == "alt":
            result.append("Alt")
        elif p.lower() == "shift":
            result.append("Shift")
        elif p == "Slash":
            result.append("/")
        elif p == "Question":
            result.append("?")
        elif p == "Comma":
            result.append(",")
        elif p == "Period":
            result.append(".")
        elif p == "Minus":
            result.append("-")
        elif p == "Equal":
            result.append("=")
        elif p == "BracketLeft":
            result.append("[")
        elif p == "BracketRight":
            result.append("]")
        elif p == "Space":
            result.append("Space")
        elif p == "Return":
            result.append("Enter")
        elif p == "Escape":
            result.append("Esc")
        elif p.startswith("XF86Audio"):
            result.append(p.replace("XF86Audio", "Audio "))
        elif p.startswith("XF86MonBrightness"):
            result.append(p.replace("XF86MonBrightness", "Brightness "))
        else:
            result.append(p)
    return result

def parse_niri_binds():
    """Extract binds directly from ~/.config/niri/config.kdl."""
    shortcuts = []
    if not NIRI_CONFIG.exists():
        return shortcuts

    text = NIRI_CONFIG.read_text()
    binds_match = re.search(r"binds\s*\{(.*)\}", text, re.DOTALL)
    if not binds_match:
        return shortcuts

    binds_text = binds_match.group(1)
    
    # Pattern to match bind definitions
    pattern = r"^\s*([A-Za-z0-9_+-]+)(?:\s+allow-when-locked=[a-z]+)?(?:\s+allow-inhibiting=[a-z]+)?(?:\s+repeat=[a-z]+)?(?:\s+cooldown-ms=\d+)?(?:\s+hotkey-overlay-title=(?:\"([^\"]*)\"|null))?\s*\{\s*([^}]+)\s*\}"

    action_map = {
        "show-hotkey-overlay;": ("Show Niri Hotkey Overlay", "Displays Niri internal keyboard shortcut cheat sheet", "System & Desktop"),
        "toggle-overview;": ("Toggle Window Overview", "Zoomed-out grid view of all active workspaces and windows", "Niri Window Management"),
        "close-window;": ("Close Focused Window", "Closes the currently active application window", "Niri Window Management"),
        "focus-column-left;": ("Focus Column Left", "Moves keyboard and window focus to the left column", "Niri Window Management"),
        "focus-column-right;": ("Focus Column Right", "Moves keyboard and window focus to the right column", "Niri Window Management"),
        "focus-window-down;": ("Focus Window Down", "Moves focus to the window below in the same column", "Niri Window Management"),
        "focus-window-up;": ("Focus Window Up", "Moves focus to the window above in the same column", "Niri Window Management"),
        "move-column-left;": ("Move Column Left", "Shifts the focused column one step to the left", "Niri Window Management"),
        "move-column-right;": ("Move Column Right", "Shifts the focused column one step to the right", "Niri Window Management"),
        "move-window-down;": ("Move Window Down", "Moves the window down within its column", "Niri Window Management"),
        "move-window-up;": ("Move Window Up", "Moves the window up within its column", "Niri Window Management"),
        "focus-column-first;": ("Focus First Column", "Jumps focus to the first column on the workspace", "Niri Window Management"),
        "focus-column-last;": ("Focus Last Column", "Jumps focus to the last column on the workspace", "Niri Window Management"),
        "move-column-to-first;": ("Move Column to Start", "Moves the focused column to the beginning of the workspace", "Niri Window Management"),
        "move-column-to-last;": ("Move Column to End", "Moves the focused column to the end of the workspace", "Niri Window Management"),
        "focus-monitor-left;": ("Focus Monitor Left", "Moves focus to the monitor on the left", "Niri Window Management"),
        "focus-monitor-right;": ("Focus Monitor Right", "Moves focus to the monitor on the right", "Niri Window Management"),
        "focus-monitor-down;": ("Focus Monitor Down", "Moves focus to the monitor below", "Niri Window Management"),
        "focus-monitor-up;": ("Focus Monitor Up", "Moves focus to the monitor above", "Niri Window Management"),
        "focus-workspace-down;": ("Next Workspace Down", "Navigates to the workspace directly below", "Workspaces"),
        "focus-workspace-up;": ("Previous Workspace Up", "Navigates to the workspace directly above", "Workspaces"),
        "move-column-to-workspace-down;": ("Move Column Down", "Moves the active column to the workspace below", "Workspaces"),
        "move-column-to-workspace-up;": ("Move Column Up", "Moves the active column to the workspace above", "Workspaces"),
        "move-workspace-down;": ("Shift Workspace Down", "Swaps the current workspace down in the workspace list", "Workspaces"),
        "move-workspace-up;": ("Shift Workspace Up", "Swaps the current workspace up in the workspace list", "Workspaces"),
        "consume-or-expel-window-left;": ("Consume/Expel Window Left", "Pulls adjacent left window into column or expels it", "Niri Window Management"),
        "consume-or-expel-window-right;": ("Consume/Expel Window Right", "Pulls adjacent right window into column or expels it", "Niri Window Management"),
        "consume-window-into-column;": ("Consume Window to Column", "Absorbs adjacent window into the focused column", "Niri Window Management"),
        "expel-window-from-column;": ("Expel Window from Column", "Ejects the bottom window out into a new column", "Niri Window Management"),
        "switch-preset-column-width;": ("Cycle Column Width", "Cycles column through preset sizes (e.g. 1/3, 1/2, 2/3)", "Niri Window Management"),
        "switch-preset-column-width-back;": ("Cycle Column Width Back", "Cycles column sizes in reverse order", "Niri Window Management"),
        "maximize-column;": ("Maximize Column", "Maximizes current column width while preserving window borders", "Niri Window Management"),
        "fullscreen-window;": ("Fullscreen Window", "Toggles true borderless fullscreen display for the window", "Niri Window Management"),
        "maximize-window-to-edges;": ("Maximize Window to Edges", "Expands window flush to all screen edges without borders", "Niri Window Management"),
        "expand-column-to-available-width;": ("Expand Column to Space", "Expands column to consume all remaining horizontal space", "Niri Window Management"),
        "center-column;": ("Center Column", "Scrolls workspace horizontally to center the active column", "Niri Window Management"),
        "center-visible-columns;": ("Center Visible Columns", "Centers all currently visible columns on the screen", "Niri Window Management"),
        "set-column-width \"-10%\";": ("Shrink Column Width", "Decreases the active column width by 10%", "Niri Window Management"),
        "set-column-width \"+10%\";": ("Expand Column Width", "Increases the active column width by 10%", "Niri Window Management"),
        "set-window-height \"-10%\";": ("Shrink Window Height", "Decreases the focused window height by 10%", "Niri Window Management"),
        "set-window-height \"+10%\";": ("Expand Window Height", "Increases the focused window height by 10%", "Niri Window Management"),
        "toggle-window-floating;": ("Toggle Window Floating", "Switches window between tiling column and free floating mode", "Niri Window Management"),
        "switch-focus-between-floating-and-tiling;": ("Focus Tiling / Floating", "Switches keyboard focus between floating and tiled windows", "Niri Window Management"),
        "toggle-column-tabbed-display;": ("Toggle Tabbed Display", "Displays windows in current column as vertical tabs", "Niri Window Management"),
        "screenshot;": ("Take Screenshot (Interactive)", "Interactive screenshot selection tool", "Screenshots & Utilities"),
        "screenshot-screen;": ("Take Fullscreen Screenshot", "Captures the entire active screen immediately", "Screenshots & Utilities"),
        "screenshot-window;": ("Take Window Screenshot", "Captures the currently focused window", "Screenshots & Utilities"),
        "power-off-monitors;": ("Power Off Monitors", "Puts display into DPMS sleep immediately", "Power & Session"),
        "toggle-keyboard-shortcuts-inhibit;": ("Toggle Shortcut Inhibitor", "Emergency escape hatch to inhibit/restore compositor binds", "System & Desktop"),
    }

    for line in binds_text.splitlines():
        m = re.match(pattern, line)
        if not m:
            continue
        key, title, cmd = m.groups()
        key = key.strip()
        cmd = cmd.strip()
        keys_list = normalize_key(key)

        # 1. Direct workspace number focus
        ws_focus = re.match(r"focus-workspace\s+(\d+);", cmd)
        if ws_focus:
            idx = ws_focus.group(1)
            shortcuts.append({
                "id": f"niri.workspace.focus.{idx}",
                "keys": keys_list,
                "action": f"Focus Workspace {idx}",
                "description": f"Switches view directly to workspace {idx}",
                "category": "Workspaces",
                "application": "Niri",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        # 2. Workspace move column
        ws_move = re.match(r"move-column-to-workspace\s+(\d+);", cmd)
        if ws_move:
            idx = ws_move.group(1)
            shortcuts.append({
                "id": f"niri.workspace.move.{idx}",
                "keys": keys_list,
                "action": f"Move Column to Workspace {idx}",
                "description": f"Transfers the active column directly to workspace {idx}",
                "category": "Workspaces",
                "application": "Niri",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        # 3. Modesty IPC Spawns
        if "quickshell" in cmd and "ipc" in cmd:
            ipc_match = re.search(r'ipc"\s+"call"\s+"([^"]+)"\s+"([^"]+)"(?:\s+"([^"]+)")?', cmd)
            if ipc_match:
                target, func, arg = ipc_match.groups()
                arg = arg or ""
                mod_action = f"{target}.{func}.{arg}" if arg else f"{target}.{func}"
                
                descriptions = {
                    "island.toggle.quicksettings": ("Control Center / Quick Settings", "Opens or closes the Modesty Quick Settings panel", "Quick Settings"),
                    "island.toggle.settings": ("Modesty Settings", "Opens the dedicated Modesty desktop customization app", "Modesty Dynamic Island"),
                    "island.toggle.calendar": ("Calendar & Reminders", "Opens the integrated calendar and agenda capsule", "Modesty Dynamic Island"),
                    "island.toggle.media": ("Expanded Media Player", "Reveals album artwork, live visualizer and playback controls", "Media & Audio"),
                    "island.toggle.notes": ("Quick Notes", "Opens the slide-out note taking and scratchpad capsule", "Modesty Dynamic Island"),
                    "island.toggle.power": ("Power & Session Menu", "Opens the shutdown, reboot, suspend, and lock dialog", "Power & Session"),
                    "island.toggle.launcher": ("Application Launcher", "Opens the Modesty fast application grid", "System & Desktop"),
                    "island.toggle.wifi": ("Wi-Fi Network Menu", "Displays available Wi-Fi access points and signal info", "Quick Settings"),
                    "island.toggle.wallpapers": ("Wallpaper Selector", "Opens the carousel wallpaper switcher in the Dynamic Island", "Display & Brightness"),
                    "island.toggle.bluetooth": ("Bluetooth Devices", "Scans and pairs with nearby Bluetooth audio and peripherals", "Quick Settings"),
                    "island.toggle.sound": ("Sound & Volume Controls", "Adjusts active sink volume, streams, and PipeWire routing", "Media & Audio"),
                    "island.toggle.display": ("Display & Brightness", "Controls backlight brightness and display settings", "Display & Brightness"),
                    "island.toggle.notifhistory": ("Notification Center", "Displays historical desktop alerts and notification toasts", "Quick Settings"),
                    "island.toggle.island": ("Toggle Dynamic Island", "Smoothly reveals or hides the top Dynamic Island capsule", "Modesty Dynamic Island"),
                    "canvas.toggle": ("Command Canvas / Search", "Opens the universal desktop search and system query palette", "Modesty Dynamic Island"),
                    "shortcuts.toggle": ("Universal Shortcut Reference", "Opens the interactive keyboard shortcut reference center", "System & Desktop"),
                }
                
                desc_entry = descriptions.get(f"{target}.{func}.{arg}") or descriptions.get(f"{target}.{func}")
                if desc_entry:
                    action_name, action_desc, cat = desc_entry
                else:
                    action_name = title or f"Modesty {arg or func}"
                    action_desc = f"Executes Modesty {target} {func} {arg}"
                    cat = "Modesty Dynamic Island"

                shortcuts.append({
                    "id": f"modesty.{target}.{arg or func}",
                    "keys": keys_list,
                    "action": action_name,
                    "description": action_desc,
                    "category": cat,
                    "application": "Modesty",
                    "scope": "global",
                    "source": "Niri configuration",
                    "verified": True,
                    "enabled": True
                })
                continue

        # 4. Standard spawn commands
        if "spawn \"kitty\"" in cmd:
            shortcuts.append({
                "id": "app.kitty.launch",
                "keys": keys_list,
                "action": "Open Terminal (Kitty)",
                "description": "Launches a new Kitty GPU-accelerated terminal window",
                "category": "Kitty Terminal",
                "application": "Kitty",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "spawn \"fuzzel\"" in cmd:
            shortcuts.append({
                "id": "app.fuzzel.launch",
                "keys": keys_list,
                "action": "Application Launcher (Fuzzel)",
                "description": "Launches the Fuzzel Wayland dmenu-style fuzzy app search",
                "category": "System & Desktop",
                "application": "Fuzzel",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "modesty-clipboard" in cmd:
            shortcuts.append({
                "id": "system.clipboard.history",
                "keys": keys_list,
                "action": "Clipboard History (cliphist)",
                "description": "Opens the Fuzzel clipboard history manager and picker",
                "category": "System & Desktop",
                "application": "cliphist",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "spawn \"swaylock\"" in cmd:
            shortcuts.append({
                "id": "system.lock.swaylock",
                "keys": keys_list,
                "action": "Lock Screen (Swaylock)",
                "description": "Locks the current Wayland session securely",
                "category": "Power & Session",
                "application": "System",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        # 5. Media & Audio keys
        if "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+" in cmd:
            shortcuts.append({
                "id": "audio.volume.up",
                "keys": keys_list,
                "action": "Volume Up (+10%)",
                "description": "Increases system default audio sink volume by 10%",
                "category": "Media & Audio",
                "application": "PipeWire",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-" in cmd:
            shortcuts.append({
                "id": "audio.volume.down",
                "keys": keys_list,
                "action": "Volume Down (-10%)",
                "description": "Decreases system default audio sink volume by 10%",
                "category": "Media & Audio",
                "application": "PipeWire",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" in cmd:
            shortcuts.append({
                "id": "audio.volume.mute",
                "keys": keys_list,
                "action": "Mute Audio Output",
                "description": "Toggles mute for the active audio output sink",
                "category": "Media & Audio",
                "application": "PipeWire",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "playerctl play-pause" in cmd:
            shortcuts.append({
                "id": "media.playback.playpause",
                "keys": keys_list,
                "action": "Play / Pause Media",
                "description": "Toggles playback on the active MPRIS media player",
                "category": "Media & Audio",
                "application": "Media",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "playerctl next" in cmd:
            shortcuts.append({
                "id": "media.playback.next",
                "keys": keys_list,
                "action": "Next Track",
                "description": "Skips forward to the next media track",
                "category": "Media & Audio",
                "application": "Media",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "playerctl previous" in cmd:
            shortcuts.append({
                "id": "media.playback.prev",
                "keys": keys_list,
                "action": "Previous Track",
                "description": "Returns to previous track or restarts current track",
                "category": "Media & Audio",
                "application": "Media",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "brightnessctl" in cmd and "+10%" in cmd:
            shortcuts.append({
                "id": "display.brightness.up",
                "keys": keys_list,
                "action": "Brightness Up (+10%)",
                "description": "Increases display backlight level by 10%",
                "category": "Display & Brightness",
                "application": "System",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        if "brightnessctl" in cmd and "10%-" in cmd:
            shortcuts.append({
                "id": "display.brightness.down",
                "keys": keys_list,
                "action": "Brightness Down (-10%)",
                "description": "Decreases display backlight level by 10%",
                "category": "Display & Brightness",
                "application": "System",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        # 6. Lookup in known action map
        if cmd in action_map:
            name, desc, cat = action_map[cmd]
            shortcuts.append({
                "id": f"niri.action.{cmd.replace(';', '').replace(' ', '_').replace('\"', '')}",
                "keys": keys_list,
                "action": name,
                "description": desc,
                "category": cat,
                "application": "Niri",
                "scope": "global",
                "source": "Niri configuration",
                "verified": True,
                "enabled": True
            })
            continue

        # Default fallback for unmapped binds
        clean_action = title or cmd.replace(";", "").strip()
        shortcuts.append({
            "id": f"niri.bind.{key.replace('+', '_')}",
            "keys": keys_list,
            "action": clean_action,
            "description": f"Trigger: {cmd}",
            "category": "Niri Window Management",
            "application": "Niri",
            "scope": "global",
            "source": "Niri configuration",
            "verified": True,
            "enabled": True
        })

    return shortcuts

def get_application_shortcuts():
    """Documented, verified application-specific shortcuts."""
    return [
        # Kitty Terminal
        {
            "id": "kitty.copy",
            "keys": ["Ctrl", "Shift", "C"],
            "action": "Copy to Clipboard",
            "description": "Copies selected text from terminal buffer",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.paste",
            "keys": ["Ctrl", "Shift", "V"],
            "action": "Paste from Clipboard",
            "description": "Pastes clipboard content into terminal session",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.paste_selection",
            "keys": ["Ctrl", "Shift", "S"],
            "action": "Paste from Primary Selection",
            "description": "Pastes primary mouse selection buffer into terminal",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.new_tab",
            "keys": ["Ctrl", "Shift", "T"],
            "action": "New Terminal Tab",
            "description": "Opens a new tab in current Kitty window",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.close_tab",
            "keys": ["Ctrl", "Shift", "Q"],
            "action": "Close Terminal Tab",
            "description": "Closes the currently focused terminal tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.next_tab",
            "keys": ["Ctrl", "Shift", "Right"],
            "action": "Next Tab",
            "description": "Switches focus to next terminal tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.prev_tab",
            "keys": ["Ctrl", "Shift", "Left"],
            "action": "Previous Tab",
            "description": "Switches focus to previous terminal tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.move_tab_forward",
            "keys": ["Ctrl", "Shift", "."],
            "action": "Move Tab Forward",
            "description": "Shifts current tab one position to the right",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.move_tab_backward",
            "keys": ["Ctrl", "Shift", ","],
            "action": "Move Tab Backward",
            "description": "Shifts current tab one position to the left",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.set_tab_title",
            "keys": ["Ctrl", "Shift", "Alt", "T"],
            "action": "Set Tab Title",
            "description": "Prompt to rename active tab title",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.new_window",
            "keys": ["Ctrl", "Shift", "Enter"],
            "action": "New Split Window",
            "description": "Opens a new window split within current tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.close_window",
            "keys": ["Ctrl", "Shift", "W"],
            "action": "Close Split Window",
            "description": "Closes the focused window split",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.next_window",
            "keys": ["Ctrl", "Shift", "]"],
            "action": "Focus Next Split Window",
            "description": "Moves focus to next window split in current tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.prev_window",
            "keys": ["Ctrl", "Shift", "["],
            "action": "Focus Previous Split Window",
            "description": "Moves focus to previous window split in current tab",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.next_layout",
            "keys": ["Ctrl", "Shift", "L"],
            "action": "Next Window Layout",
            "description": "Cycles through available terminal window layouts",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.show_scrollback",
            "keys": ["Ctrl", "Shift", "H"],
            "action": "Show Scrollback in Pager",
            "description": "Opens complete terminal scrollback buffer in pager",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.search_scrollback",
            "keys": ["Ctrl", "Shift", "/"],
            "action": "Search Scrollback",
            "description": "Search history buffer within pager",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.scroll_page_up",
            "keys": ["Ctrl", "Shift", "Page_Up"],
            "action": "Scroll Page Up",
            "description": "Scrolls backward one full page in buffer",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.scroll_page_down",
            "keys": ["Ctrl", "Shift", "Page_Down"],
            "action": "Scroll Page Down",
            "description": "Scrolls forward one full page in buffer",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.scroll_home",
            "keys": ["Ctrl", "Shift", "Home"],
            "action": "Scroll to Top",
            "description": "Scrolls terminal view directly to the top of buffer",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.scroll_end",
            "keys": ["Ctrl", "Shift", "End"],
            "action": "Scroll to Bottom",
            "description": "Scrolls terminal view directly to current prompt",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.toggle_fullscreen",
            "keys": ["Ctrl", "Shift", "F11"],
            "action": "Toggle Fullscreen",
            "description": "Toggles terminal OS window full-screen mode",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.font_increase",
            "keys": ["Ctrl", "Shift", "+"],
            "action": "Increase Font Size",
            "description": "Enlarges terminal typography size",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.font_decrease",
            "keys": ["Ctrl", "Shift", "-"],
            "action": "Decrease Font Size",
            "description": "Shrinks terminal typography size",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },
        {
            "id": "kitty.font_reset",
            "keys": ["Ctrl", "Shift", "Backspace"],
            "action": "Reset Font Size",
            "description": "Restores default terminal font size",
            "category": "Kitty Terminal",
            "application": "Kitty",
            "scope": "application",
            "source": "Kitty configuration",
            "verified": True,
            "enabled": True
        },

        # Brave Browser
        {
            "id": "brave.new_tab",
            "keys": ["Ctrl", "T"],
            "action": "New Browser Tab",
            "description": "Opens a new browsing tab",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.close_tab",
            "keys": ["Ctrl", "W"],
            "action": "Close Browser Tab",
            "description": "Closes current browsing tab",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.reopen_tab",
            "keys": ["Ctrl", "Shift", "T"],
            "action": "Reopen Closed Tab",
            "description": "Restores the most recently closed browsing tab",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.new_window",
            "keys": ["Ctrl", "N"],
            "action": "New Browser Window",
            "description": "Opens a new standard browser window",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.new_incognito",
            "keys": ["Ctrl", "Shift", "N"],
            "action": "New Private Window",
            "description": "Opens a private/incognito browsing window",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.focus_address",
            "keys": ["Ctrl", "L"],
            "action": "Focus Address Bar",
            "description": "Highlights URL bar for quick search or address input",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.reload",
            "keys": ["Ctrl", "R"],
            "action": "Reload Page",
            "description": "Refreshes active webpage content",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.hard_reload",
            "keys": ["Ctrl", "Shift", "R"],
            "action": "Hard Reload Page",
            "description": "Refreshes webpage ignoring cached content",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.find_on_page",
            "keys": ["Ctrl", "F"],
            "action": "Find in Page",
            "description": "Opens search bar to find text on current page",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "brave.dev_tools",
            "keys": ["F12"],
            "action": "Toggle Developer Tools",
            "description": "Opens web inspector and developer console",
            "category": "Browsers",
            "application": "Brave",
            "scope": "application",
            "source": "Brave documentation",
            "verified": True,
            "enabled": True
        },

        # Thunar File Manager
        {
            "id": "thunar.new_tab",
            "keys": ["Ctrl", "T"],
            "action": "New Folder Tab",
            "description": "Opens a new tab in active Thunar window",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "thunar.new_window",
            "keys": ["Ctrl", "N"],
            "action": "New Thunar Window",
            "description": "Opens a new file manager window",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "thunar.location_bar",
            "keys": ["Ctrl", "L"],
            "action": "Edit Location Path",
            "description": "Focuses path bar to type target directory",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "thunar.search",
            "keys": ["Ctrl", "F"],
            "action": "Search Files",
            "description": "Searches files within current directory",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "thunar.toggle_hidden",
            "keys": ["Ctrl", "H"],
            "action": "Toggle Hidden Files",
            "description": "Shows or hides dotfiles and hidden folders",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "thunar.properties",
            "keys": ["Alt", "Enter"],
            "action": "Item Properties",
            "description": "Displays permissions and size properties for item",
            "category": "File Manager",
            "application": "Thunar",
            "scope": "application",
            "source": "Thunar documentation",
            "verified": True,
            "enabled": True
        },

        # Fuzzel
        {
            "id": "fuzzel.close",
            "keys": ["Esc"],
            "action": "Close Fuzzel",
            "description": "Closes the application runner without action",
            "category": "System & Desktop",
            "application": "Fuzzel",
            "scope": "application",
            "source": "Fuzzel documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "fuzzel.next_item",
            "keys": ["Down"],
            "action": "Next Result",
            "description": "Moves selector down (also Ctrl+N or Ctrl+J)",
            "category": "System & Desktop",
            "application": "Fuzzel",
            "scope": "application",
            "source": "Fuzzel documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "fuzzel.prev_item",
            "keys": ["Up"],
            "action": "Previous Result",
            "description": "Moves selector up (also Ctrl+P or Ctrl+K)",
            "category": "System & Desktop",
            "application": "Fuzzel",
            "scope": "application",
            "source": "Fuzzel documentation",
            "verified": True,
            "enabled": True
        },

        # Zsh & Shell Utilities
        {
            "id": "zsh.beginning_of_line",
            "keys": ["Ctrl", "A"],
            "action": "Jump to Line Start",
            "description": "Moves cursor to the beginning of the command line",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.end_of_line",
            "keys": ["Ctrl", "E"],
            "action": "Jump to Line End",
            "description": "Moves cursor to the end of the command line",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.forward_char",
            "keys": ["Ctrl", "F"],
            "action": "Forward One Character",
            "description": "Moves cursor one character forward",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.backward_char",
            "keys": ["Ctrl", "B"],
            "action": "Backward One Character",
            "description": "Moves cursor one character backward",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.forward_word",
            "keys": ["Alt", "F"],
            "action": "Forward One Word",
            "description": "Moves cursor forward by one word",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.backward_word",
            "keys": ["Alt", "B"],
            "action": "Backward One Word",
            "description": "Moves cursor backward by one word",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.backward_kill_word",
            "keys": ["Ctrl", "W"],
            "action": "Delete Word Backward",
            "description": "Deletes the word preceding the cursor",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.kill_word_forward",
            "keys": ["Alt", "D"],
            "action": "Delete Word Forward",
            "description": "Deletes the word immediately after the cursor",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.kill_line",
            "keys": ["Ctrl", "K"],
            "action": "Kill Line Forward",
            "description": "Deletes text from cursor position to end of line",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.kill_whole_line",
            "keys": ["Ctrl", "U"],
            "action": "Kill Line Backward",
            "description": "Deletes entire command line up to cursor",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.yank",
            "keys": ["Ctrl", "Y"],
            "action": "Yank Killed Text",
            "description": "Pastes most recently killed word or line",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.clear",
            "keys": ["Ctrl", "L"],
            "action": "Clear Screen",
            "description": "Clears terminal screen while preserving current input",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.history_search",
            "keys": ["Ctrl", "R"],
            "action": "FZF Reverse History Search",
            "description": "Interactively search command history with fzf widget",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.fzf_file",
            "keys": ["Ctrl", "T"],
            "action": "FZF File Finder",
            "description": "Fuzzy search files and insert selection into command line",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.fzf_cd",
            "keys": ["Alt", "C"],
            "action": "FZF Directory Navigation",
            "description": "Fuzzy find directory and cd into it immediately",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.autocomplete",
            "keys": ["Tab"],
            "action": "FZF / Zsh Autocomplete",
            "description": "Trigger auto-completion for commands, paths, and flags",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.interrupt",
            "keys": ["Ctrl", "C"],
            "action": "Interrupt Process (SIGINT)",
            "description": "Sends SIGINT to abort running foreground command",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.eof_exit",
            "keys": ["Ctrl", "D"],
            "action": "Exit Shell (EOF)",
            "description": "Closes current shell session or logs out",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },
        {
            "id": "zsh.suspend",
            "keys": ["Ctrl", "Z"],
            "action": "Suspend Process (SIGTSTP)",
            "description": "Sends SIGTSTP to pause and background current process",
            "category": "Zsh & Shell",
            "application": "Zsh",
            "scope": "application",
            "source": "Zsh keybindings",
            "verified": True,
            "enabled": True
        },

        # Neovim & LazyVim
        {
            "id": "nvim.find_files_root",
            "keys": ["Space", "Space"],
            "action": "Find Files (Root Dir)",
            "description": "Snacks picker for files across workspace root",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.find_files",
            "keys": ["Space", "f", "f"],
            "action": "Find Files",
            "description": "Snacks picker to search files by name in current project",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.explorer",
            "keys": ["Space", "e"],
            "action": "File Explorer (Snacks)",
            "description": "Toggle file tree explorer in workspace root",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.live_grep_root",
            "keys": ["Space", "/"],
            "action": "Grep Text (Root Dir)",
            "description": "Live grep search across all files in workspace root",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.live_grep",
            "keys": ["Space", "s", "g"],
            "action": "Grep Text (Snacks)",
            "description": "Snacks interactive project-wide text search",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.search_replace",
            "keys": ["Space", "s", "r"],
            "action": "Search and Replace",
            "description": "Interactive search and replace across files (grug-far)",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.buffer_lines",
            "keys": ["Space", "s", "b"],
            "action": "Search Buffer Lines",
            "description": "Fuzzy search text lines within current buffer",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.list_buffers",
            "keys": ["Space", "f", "b"],
            "action": "Open Buffers",
            "description": "List and switch active buffers via Snacks picker",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.other_buffer",
            "keys": ["Space", "b", "b"],
            "action": "Switch to Other Buffer",
            "description": "Quickly toggle between current and alternate buffer",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.delete_buffer",
            "keys": ["Space", "b", "d"],
            "action": "Delete Buffer",
            "description": "Close active buffer without altering window layout",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.next_buffer",
            "keys": ["]", "b"],
            "action": "Next Buffer",
            "description": "Jump forward to the next buffer in list",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.prev_buffer",
            "keys": ["[", "b"],
            "action": "Previous Buffer",
            "description": "Jump backward to previous buffer in list",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.split_below",
            "keys": ["Space", "w", "-"],
            "action": "Split Window Below",
            "description": "Open horizontal window split below current buffer",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.split_right",
            "keys": ["Space", "w", "|"],
            "action": "Split Window Right",
            "description": "Open vertical window split to the right of current buffer",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.close_window",
            "keys": ["Space", "w", "d"],
            "action": "Close Window Split",
            "description": "Close the currently active window split",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.focus_left",
            "keys": ["Ctrl", "H"],
            "action": "Focus Window Left",
            "description": "Move cursor focus to window split on the left",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.focus_down",
            "keys": ["Ctrl", "J"],
            "action": "Focus Window Down",
            "description": "Move cursor focus to window split below",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.focus_up",
            "keys": ["Ctrl", "K"],
            "action": "Focus Window Up",
            "description": "Move cursor focus to window split above",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.focus_right",
            "keys": ["Ctrl", "L"],
            "action": "Focus Window Right",
            "description": "Move cursor focus to window split on the right",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.terminal_toggle",
            "keys": ["Space", "t", "t"],
            "action": "Toggle Terminal",
            "description": "Toggle floating root terminal session",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.terminal_ctrl_slash",
            "keys": ["Ctrl", "/"],
            "action": "Toggle Terminal (Ctrl+/)",
            "description": "Universal terminal toggle key combination",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lazygit",
            "keys": ["Space", "g", "g"],
            "action": "LazyGit Interface",
            "description": "Open full-screen LazyGit interface inside Neovim",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.git_status",
            "keys": ["Space", "g", "s"],
            "action": "Git Status (Snacks)",
            "description": "Snacks picker for modified and untracked git files",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.git_diff",
            "keys": ["Space", "g", "d"],
            "action": "Git Diff (Hunks)",
            "description": "Inspect all repository changes and uncommitted hunks",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.git_branches",
            "keys": ["Space", "g", "c"],
            "action": "Git Branches (Snacks)",
            "description": "Snacks picker to list and checkout Git branches",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.next_hunk",
            "keys": ["]", "h"],
            "action": "Next Git Hunk",
            "description": "Jump to next modified hunk using Gitsigns",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.prev_hunk",
            "keys": ["[", "h"],
            "action": "Previous Git Hunk",
            "description": "Jump to previous modified hunk using Gitsigns",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.stage_hunk",
            "keys": ["Space", "g", "h", "s"],
            "action": "Stage Git Hunk",
            "description": "Stage current git hunk under cursor into Git index",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.reset_hunk",
            "keys": ["Space", "g", "h", "r"],
            "action": "Reset Git Hunk",
            "description": "Discard uncommitted modifications in current hunk",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.preview_hunk",
            "keys": ["Space", "g", "h", "p"],
            "action": "Preview Git Hunk",
            "description": "Show inline diff preview of current git hunk",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.blame_line",
            "keys": ["Space", "g", "h", "b"],
            "action": "Git Blame Line",
            "description": "Inspect author, commit hash, and date for current line",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.format_code",
            "keys": ["Space", "c", "f"],
            "action": "Format Document",
            "description": "Format buffer with Prettier, LSP, or Conform",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.code_actions",
            "keys": ["Space", "c", "a"],
            "action": "Code Actions",
            "description": "Show available LSP code actions and quickfixes",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.rename_symbol",
            "keys": ["Space", "c", "r"],
            "action": "Rename Symbol",
            "description": "Rename symbol across workspace via LSP",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.diagnostics",
            "keys": ["Space", "x", "x"],
            "action": "Diagnostics List",
            "description": "Toggle Trouble / Snacks diagnostics list",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.line_diagnostics",
            "keys": ["Space", "c", "d"],
            "action": "Line Diagnostics",
            "description": "Show diagnostic error details for current line",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.next_diagnostic",
            "keys": ["]", "d"],
            "action": "Next Diagnostic",
            "description": "Jump cursor to next diagnostic error or warning",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.prev_diagnostic",
            "keys": ["[", "d"],
            "action": "Previous Diagnostic",
            "description": "Jump cursor to previous diagnostic error or warning",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lsp_hover",
            "keys": ["Shift", "K"],
            "action": "LSP Hover Documentation",
            "description": "Display symbol type definition and documentation popup",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lsp_definition",
            "keys": ["g", "d"],
            "action": "Go to Definition",
            "description": "Jump to definition of symbol under cursor",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lsp_references",
            "keys": ["g", "r"],
            "action": "Find References",
            "description": "Snacks picker for all references of symbol",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lsp_implementation",
            "keys": ["g", "I"],
            "action": "Go to Implementation",
            "description": "Jump to implementation of interface or method",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.lsp_type_definition",
            "keys": ["g", "y"],
            "action": "Go to Type Definition",
            "description": "Jump to type definition of symbol under cursor",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.surround_add",
            "keys": ["g", "s", "a"],
            "action": "Add Surrounding Pair",
            "description": "Mini.surround: wrap text/motion with brackets or quotes",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.surround_delete",
            "keys": ["g", "s", "d"],
            "action": "Delete Surrounding Pair",
            "description": "Mini.surround: delete surrounding quotes or brackets",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.surround_replace",
            "keys": ["g", "s", "r"],
            "action": "Replace Surrounding Pair",
            "description": "Mini.surround: change enclosing quotes or brackets",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.snippet_jump_next",
            "keys": ["Tab"],
            "action": "Snippet Next Placeholder",
            "description": "Blink.cmp: accept suggestion or jump to next snippet tabstop",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },
        {
            "id": "nvim.snippet_jump_prev",
            "keys": ["Shift", "Tab"],
            "action": "Snippet Prev Placeholder",
            "description": "Blink.cmp: jump back to previous snippet tabstop",
            "category": "Neovim & LazyVim",
            "application": "Neovim",
            "scope": "application",
            "source": "Neovim / LazyVim",
            "verified": True,
            "enabled": True
        },

        # Git & LazyGit
        {
            "id": "lazygit.toggle_stage",
            "keys": ["Space"],
            "action": "Toggle Stage File / Hunk",
            "description": "Stage or unstage selected file or individual diff hunk",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.stage_all",
            "keys": ["a"],
            "action": "Stage / Unstage All",
            "description": "Toggle staged status for all modified files in repository",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.commit",
            "keys": ["c"],
            "action": "Commit Changes",
            "description": "Open commit prompt to record staged changes",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.amend_commit",
            "keys": ["Shift", "A"],
            "action": "Amend Last Commit",
            "description": "Amend previously committed changeset without modifying message",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.push",
            "keys": ["Shift", "P"],
            "action": "Push Commits",
            "description": "Push commits to tracked upstream remote branch",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.pull",
            "keys": ["p"],
            "action": "Pull Changes",
            "description": "Pull and merge/rebase remote commits into current branch",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.fetch",
            "keys": ["f"],
            "action": "Fetch Remotes",
            "description": "Fetch branch and tag updates from all configured remotes",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.branch_menu",
            "keys": ["b"],
            "action": "Branch Menu",
            "description": "Open branch operations menu (switch, merge, rebase)",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.new_branch",
            "keys": ["n"],
            "action": "New Branch",
            "description": "Prompt for branch name and create new branch",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.merge_branch",
            "keys": ["m"],
            "action": "Merge Branch",
            "description": "Merge selected branch into checked out branch",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.view_diff",
            "keys": ["Enter"],
            "action": "Drill Down / View Diff",
            "description": "Enter sub-view to inspect line-by-line file diff or commit",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.discard_changes",
            "keys": ["d"],
            "action": "Discard Changes",
            "description": "Discard uncommitted working tree modifications in file or hunk",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.stash",
            "keys": ["s"],
            "action": "Stash Changes",
            "description": "Stash modified and untracked files into stash list",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.filter_search",
            "keys": ["/"],
            "action": "Filter List",
            "description": "Search and filter files, commits, or branch list by pattern",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.help",
            "keys": ["?"],
            "action": "Keybindings Help",
            "description": "Display complete context-sensitive keybinding help cheat sheet",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.quit",
            "keys": ["q"],
            "action": "Quit LazyGit",
            "description": "Exit LazyGit interface and return to terminal or Neovim",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.panel_files",
            "keys": ["1"],
            "action": "Files Panel",
            "description": "Jump focus to files list panel",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.panel_branches",
            "keys": ["2"],
            "action": "Branches Panel",
            "description": "Jump focus to git branches list panel",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.panel_commits",
            "keys": ["3"],
            "action": "Commits Panel",
            "description": "Jump focus to commit history list panel",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.panel_stash",
            "keys": ["4"],
            "action": "Stash Panel",
            "description": "Jump focus to stash list panel",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.next_panel",
            "keys": ["]"],
            "action": "Next Panel Tab",
            "description": "Switch focus to next panel tab",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.prev_panel",
            "keys": ["["],
            "action": "Previous Panel Tab",
            "description": "Switch focus to previous panel tab",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.conflict_accept_both",
            "keys": ["b"],
            "action": "Accept Both Changes",
            "description": "In merge conflict view: keep both incoming and local changes",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },
        {
            "id": "lazygit.conflict_undo",
            "keys": ["z"],
            "action": "Undo Conflict Resolution",
            "description": "In merge conflict view: undo last resolved conflict choice",
            "category": "Git & LazyGit",
            "application": "LazyGit",
            "scope": "application",
            "source": "LazyGit defaults",
            "verified": True,
            "enabled": True
        },

        # OpenCode CLI
        {
            "id": "opencode.submit",
            "keys": ["Enter"],
            "action": "Submit Message",
            "description": "Submit prompt turn to active OpenCode session",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.newline",
            "keys": ["Shift", "Enter"],
            "action": "Insert Line Break",
            "description": "Add a line break in multiline prompt without submitting",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.newline_alt",
            "keys": ["Alt", "Enter"],
            "action": "Line Break (Alt)",
            "description": "Alternative chord for inserting line break in prompt",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.cancel",
            "keys": ["Ctrl", "C"],
            "action": "Cancel Generation",
            "description": "Abort running response generation or active tool call",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.exit",
            "keys": ["Ctrl", "D"],
            "action": "Exit Session",
            "description": "Close interactive CLI session and exit to shell",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.autocomplete",
            "keys": ["Tab"],
            "action": "Autocomplete / Cycle",
            "description": "Trigger autocomplete or cycle choices in prompts",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "opencode.slash_menu",
            "keys": ["/"],
            "action": "Slash Command Menu",
            "description": "Open interactive menu to select commands (/model, /session, /exit)",
            "category": "OpenCode CLI",
            "application": "OpenCode CLI",
            "scope": "application",
            "source": "OpenCode CLI documentation",
            "verified": True,
            "enabled": True
        },

        # Antigravity CLI
        {
            "id": "agy.submit",
            "keys": ["Enter"],
            "action": "Submit Turn",
            "description": "Submit prompt turn to Antigravity agent",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.newline",
            "keys": ["Shift", "Enter"],
            "action": "Insert Line Break",
            "description": "Insert a new line into multiline prompt buffer",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.cancel",
            "keys": ["Ctrl", "C"],
            "action": "Cancel Operation",
            "description": "Cancel current turn, streaming response, or tool run",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.exit",
            "keys": ["Ctrl", "D"],
            "action": "Exit CLI Session",
            "description": "Close interactive session and return to shell",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.mode_switch",
            "keys": ["Shift", "Tab"],
            "action": "Cycle Agent Mode",
            "description": "Cycle execution mode between accept-edits, auto, and plan",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.history_prev",
            "keys": ["Up"],
            "action": "Previous Prompt",
            "description": "Navigate backward through interactive prompt history",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "agy.slash_menu",
            "keys": ["/"],
            "action": "Slash Command Menu",
            "description": "Open interactive menu to select commands (/model, /clear, /cost)",
            "category": "Antigravity CLI",
            "application": "Antigravity CLI",
            "scope": "application",
            "source": "Antigravity CLI documentation",
            "verified": True,
            "enabled": True
        },

        # Development Tools & Terminal IDE Workflow
        {
            "id": "antigravity.quick_open",
            "keys": ["Ctrl", "P"],
            "action": "Quick Open File",
            "description": "Quickly search and jump to files in workspace",
            "category": "Development Tools",
            "application": "Antigravity",
            "scope": "application",
            "source": "Antigravity documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "antigravity.command_palette",
            "keys": ["Ctrl", "Shift", "P"],
            "action": "Command Palette",
            "description": "Access all developer editor commands and tools",
            "category": "Development Tools",
            "application": "Antigravity",
            "scope": "application",
            "source": "Antigravity documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "antigravity.terminal_toggle",
            "keys": ["Ctrl", "`"],
            "action": "Toggle Integrated Terminal",
            "description": "Shows or hides the built-in terminal pane",
            "category": "Development Tools",
            "application": "Antigravity",
            "scope": "application",
            "source": "Antigravity documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "antigravity.find_in_files",
            "keys": ["Ctrl", "Shift", "F"],
            "action": "Find in Workspace Files",
            "description": "Global multi-file text and regex search",
            "category": "Development Tools",
            "application": "Antigravity",
            "scope": "application",
            "source": "Antigravity documentation",
            "verified": True,
            "enabled": True
        },
        {
            "id": "devflow.next_tab",
            "keys": ["Ctrl", "Shift", "Right"],
            "action": "Next Terminal IDE Tab",
            "description": "Switch to next stage tab (Editor -> OpenCode -> Antigravity -> Dev Shell)",
            "category": "Development Tools",
            "application": "Terminal IDE",
            "scope": "application",
            "source": "Terminal IDE layout",
            "verified": True,
            "enabled": True
        },
        {
            "id": "devflow.prev_tab",
            "keys": ["Ctrl", "Shift", "Left"],
            "action": "Previous Terminal IDE Tab",
            "description": "Switch to previous stage tab in terminal layout",
            "category": "Development Tools",
            "application": "Terminal IDE",
            "scope": "application",
            "source": "Terminal IDE layout",
            "verified": True,
            "enabled": True
        },
        {
            "id": "devflow.term_toggle",
            "keys": ["Space", "t", "t"],
            "action": "Neovim Embedded Terminal",
            "description": "Quick floating terminal popup within editor session",
            "category": "Development Tools",
            "application": "Terminal IDE",
            "scope": "application",
            "source": "Terminal IDE layout",
            "verified": True,
            "enabled": True
        },
        {
            "id": "devflow.git_review",
            "keys": ["Space", "g", "g"],
            "action": "Review AI Changes in LazyGit",
            "description": "Review all AI code modifications in LazyGit before staging",
            "category": "Development Tools",
            "application": "Terminal IDE",
            "scope": "application",
            "source": "Terminal IDE layout",
            "verified": True,
            "enabled": True
        },
    ]

def sync():
    """Main synchronization routine."""
    REGISTRY_DIR.mkdir(parents=True, exist_ok=True)
    
    niri_shortcuts = parse_niri_binds()
    app_shortcuts = get_application_shortcuts()
    
    custom_shortcuts = []
    if CUSTOM_FILE.exists():
        try:
            custom_shortcuts = json.loads(CUSTOM_FILE.read_text())
        except Exception as e:
            print(f"Warning loading custom shortcuts: {e}", file=sys.stderr)

    # Combine with de-duplication by id; if multiple chords trigger the same action,
    # preserve all chords by appending a key slug to duplicate ids.
    registry = {}
    
    for s in niri_shortcuts:
        item_id = s["id"]
        if item_id in registry:
            key_slug = "_".join(k.lower() for k in s.get("keys", []))
            s["id"] = f"{item_id}_{key_slug}"
        registry[s["id"]] = s
        
    for s in app_shortcuts:
        item_id = s["id"]
        if item_id in registry:
            key_slug = "_".join(k.lower() for k in s.get("keys", []))
            s["id"] = f"{item_id}_{key_slug}"
        registry[s["id"]] = s
        
    for s in custom_shortcuts:
        item_id = s["id"]
        if item_id in registry:
            key_slug = "_".join(k.lower() for k in s.get("keys", []))
            s["id"] = f"{item_id}_{key_slug}"
        registry[s["id"]] = s

    all_items = list(registry.values())
    
    # Sort logically by category then action name
    category_order = [
        "System & Desktop",
        "Niri Window Management",
        "Workspaces",
        "Modesty Dynamic Island",
        "Quick Settings",
        "Media & Audio",
        "Display & Brightness",
        "Power & Session",
        "Kitty Terminal",
        "Zsh & Shell",
        "Neovim & LazyVim",
        "Git & LazyGit",
        "OpenCode CLI",
        "Antigravity CLI",
        "Development Tools",
        "Browsers",
        "File Manager",
        "Screenshots & Utilities",
        "Other Applications"
    ]
    
    def sort_key(item):
        cat = item.get("category", "Other Applications")
        cat_idx = category_order.index(cat) if cat in category_order else 99
        return (cat_idx, item.get("action", ""))

    all_items.sort(key=sort_key)
    
    # Check for conflicts among global shortcuts
    global_chords = {}
    for item in all_items:
        if item.get("scope") == "global" and item.get("enabled", True):
            chord = "+".join(item.get("keys", []))
            if chord in global_chords:
                print(f"Notice: Global shortcut conflict detected on {chord}: {global_chords[chord]['action']} vs {item['action']}", file=sys.stderr)
                item["conflict"] = global_chords[chord]["id"]
            else:
                global_chords[chord] = item

    output_data = {
        "version": "1.0.0",
        "generatedAt": os.popen("date -u +%Y-%m-%dT%H:%M:%SZ").read().strip(),
        "total": len(all_items),
        "categories": [c for c in category_order if any(i.get("category") == c for i in all_items)],
        "shortcuts": all_items
    }

    REGISTRY_FILE.write_text(json.dumps(output_data, indent=2))

    print(f"Shortcut registry successfully synchronized: {len(all_items)} shortcuts saved to {REGISTRY_FILE}")
    return output_data

if __name__ == "__main__":
    sync()
