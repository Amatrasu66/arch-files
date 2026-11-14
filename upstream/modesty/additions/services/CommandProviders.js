.pragma library

// Universal Command Palette Provider Registry
// Combines Applications, Desktop & System Actions, Niri Compositor Controls,
// Command History, Calculator, and File Search.

const SYSTEM_ACTIONS = [
    // Desktop Actions
    {
        key: "action:island",
        kind: "action",
        actionId: "island",
        title: "Toggle Dynamic Island",
        subtitle: "Expand or collapse the top Dynamic Island",
        category: "Desktop",
        icon: "dock",
        shortcut: "Mod+I"
    },
    {
        key: "action:shortcuts",
        kind: "action",
        actionId: "shortcuts",
        title: "Universal Shortcut Reference",
        subtitle: "Inspect all desktop keyboard shortcuts and copy bindings",
        category: "Desktop",
        icon: "keyboard",
        shortcut: "Mod+K"
    },
    {
        key: "action:quicksettings",
        kind: "action",
        actionId: "quicksettings",
        title: "Control Center / Quick Settings",
        subtitle: "Wi-Fi, Bluetooth, volume, and display controls",
        category: "Desktop",
        icon: "tune",
        shortcut: ""
    },
    {
        key: "action:notifhistory",
        kind: "action",
        actionId: "notifhistory",
        title: "Notification History",
        subtitle: "Review recent desktop notifications and alerts",
        category: "Desktop",
        icon: "notifications",
        shortcut: "Mod+N"
    },
    {
        key: "action:calendar",
        kind: "action",
        actionId: "calendar",
        title: "Calendar & Schedule",
        subtitle: "Open monthly calendar and date overview",
        category: "Desktop",
        icon: "calendar_today",
        shortcut: "Mod+Shift+C"
    },
    {
        key: "action:media",
        kind: "action",
        actionId: "media",
        title: "Media Player & Visualizer",
        subtitle: "Playback controls and CAVA audio visualizer",
        category: "Desktop",
        icon: "music_note",
        shortcut: "Mod+Shift+M"
    },
    {
        key: "action:notes",
        kind: "action",
        actionId: "notes",
        title: "Quick Notes",
        subtitle: "Open scratchpad and pinned markdown notes",
        category: "Desktop",
        icon: "edit_note",
        shortcut: "Mod+Shift+N"
    },
    {
        key: "action:settings",
        kind: "action",
        actionId: "settings",
        title: "Modesty Settings",
        subtitle: "Configure desktop shell, themes, and animations",
        category: "Desktop",
        icon: "settings",
        shortcut: "Mod+Shift+S"
    },

    // Display Actions
    {
        key: "action:wallpapers",
        kind: "action",
        actionId: "wallpapers",
        title: "Change Wallpaper",
        subtitle: "Browse and select desktop wallpapers in Dynamic Island",
        category: "Display",
        icon: "image",
        shortcut: "Mod+Alt+W"
    },
    {
        key: "action:display",
        kind: "action",
        actionId: "display",
        title: "Display Settings",
        subtitle: "Configure resolution, scaling, and monitor layout",
        category: "Display",
        icon: "monitor",
        shortcut: "Mod+Shift+D"
    },
    {
        key: "action:nightlight",
        kind: "action",
        actionId: "nightlight",
        title: "Toggle Night Light",
        subtitle: "Toggle blue-light color temperature filter",
        category: "Display",
        icon: "nightlight",
        shortcut: ""
    },
    {
        key: "action:appearance",
        kind: "action",
        actionId: "appearance",
        title: "Toggle Dark / Light Style",
        subtitle: "Switch between Catppuccin Mocha and light theme",
        category: "Display",
        icon: "contrast",
        shortcut: ""
    },

    // Audio Actions
    {
        key: "action:volup",
        kind: "action",
        actionId: "volup",
        title: "Volume Up (+5%)",
        subtitle: "Increase default PipeWire audio output volume",
        category: "Audio",
        icon: "volume_up",
        shortcut: ""
    },
    {
        key: "action:voldown",
        kind: "action",
        actionId: "voldown",
        title: "Volume Down (-5%)",
        subtitle: "Decrease default PipeWire audio output volume",
        category: "Audio",
        icon: "volume_down",
        shortcut: ""
    },
    {
        key: "action:mute",
        kind: "action",
        actionId: "mute",
        title: "Toggle Audio Mute",
        subtitle: "Mute or unmute default audio output sink",
        category: "Audio",
        icon: "volume_off",
        shortcut: "XF86AudioMute"
    },
    {
        key: "action:sound",
        kind: "action",
        actionId: "sound",
        title: "Sound & Audio Routing",
        subtitle: "Manage PipeWire audio input/output devices",
        category: "Audio",
        icon: "volume_up",
        shortcut: "Mod+Shift+A"
    },

    // Connectivity Actions
    {
        key: "action:wifi",
        kind: "action",
        actionId: "wifi",
        title: "Wi-Fi Settings",
        subtitle: "Scan, connect, and configure wireless networks",
        category: "Connectivity",
        icon: "wifi",
        shortcut: "Mod+Shift+W"
    },
    {
        key: "action:bluetooth",
        kind: "action",
        actionId: "bluetooth",
        title: "Bluetooth Settings",
        subtitle: "Pair, connect, and manage Bluetooth devices",
        category: "Connectivity",
        icon: "bluetooth",
        shortcut: "Mod+B"
    },

    // Session Actions
    {
        key: "action:lock",
        kind: "action",
        actionId: "lock",
        title: "Lock Screen",
        subtitle: "Lock session immediately via Wayland session lock",
        category: "Session",
        icon: "lock",
        shortcut: "Mod+L"
    },
    {
        key: "action:suspend",
        kind: "action",
        actionId: "suspend",
        title: "Suspend / Sleep",
        subtitle: "Suspend system to RAM and lock screen",
        category: "Session",
        icon: "dark_mode",
        shortcut: ""
    },
    {
        key: "action:logout",
        kind: "action",
        actionId: "logout",
        title: "Log Out",
        subtitle: "Exit current Niri Wayland session (Requires confirmation)",
        category: "Session",
        icon: "logout",
        shortcut: "",
        confirmation: true
    },
    {
        key: "action:reboot",
        kind: "action",
        actionId: "reboot",
        title: "Restart Computer",
        subtitle: "Reboot system safely via systemd (Requires confirmation)",
        category: "Session",
        icon: "restart_alt",
        shortcut: "",
        confirmation: true
    },
    {
        key: "action:poweroff",
        kind: "action",
        actionId: "poweroff",
        title: "Shut Down Computer",
        subtitle: "Power off system safely via systemd (Requires confirmation)",
        category: "Session",
        icon: "power_settings_new",
        shortcut: "",
        confirmation: true
    },
    {
        key: "action:clearhistory",
        kind: "action",
        actionId: "clearhistory",
        title: "Clear Command History",
        subtitle: "Reset recent command palette history and recents",
        category: "History",
        icon: "delete_sweep",
        shortcut: ""
    }
];

const NIRI_ACTIONS = [
    {
        key: "niri:focus-column-right",
        kind: "niri",
        niriAction: ["focus-column-right"],
        title: "Focus Next Column (Right)",
        subtitle: "Move focus to the column on the right",
        category: "Niri",
        icon: "view_column",
        shortcut: "Mod+Right / Mod+L"
    },
    {
        key: "niri:focus-column-left",
        kind: "niri",
        niriAction: ["focus-column-left"],
        title: "Focus Previous Column (Left)",
        subtitle: "Move focus to the column on the left",
        category: "Niri",
        icon: "view_column",
        shortcut: "Mod+Left / Mod+H"
    },
    {
        key: "niri:focus-window-down",
        kind: "niri",
        niriAction: ["focus-window-down"],
        title: "Focus Window Down",
        subtitle: "Move focus down within the current column",
        category: "Niri",
        icon: "arrow_downward",
        shortcut: "Mod+Down / Mod+J"
    },
    {
        key: "niri:focus-window-up",
        kind: "niri",
        niriAction: ["focus-window-up"],
        title: "Focus Window Up",
        subtitle: "Move focus up within the current column",
        category: "Niri",
        icon: "arrow_upward",
        shortcut: "Mod+Up"
    },
    {
        key: "niri:focus-window-previous",
        kind: "niri",
        niriAction: ["focus-window-previous"],
        title: "Focus Previously Focused Window",
        subtitle: "Switch focus back to previous active window",
        category: "Niri",
        icon: "history",
        shortcut: ""
    },
    {
        key: "niri:maximize-column",
        kind: "niri",
        niriAction: ["maximize-column"],
        title: "Maximize / Restore Column",
        subtitle: "Toggle maximized width for the focused column",
        category: "Niri",
        icon: "fullscreen",
        shortcut: "Mod+F / Mod+M"
    },
    {
        key: "niri:fullscreen-window",
        kind: "niri",
        niriAction: ["fullscreen-window"],
        title: "Toggle Fullscreen Window",
        subtitle: "Toggle fullscreen mode for the active window",
        category: "Niri",
        icon: "fullscreen",
        shortcut: "Mod+Shift+F"
    },
    {
        key: "niri:close-window",
        kind: "niri",
        niriAction: ["close-window"],
        title: "Close Focused Window",
        subtitle: "Send close request to active window",
        category: "Niri",
        icon: "close",
        shortcut: "Mod+Q"
    },
    {
        key: "niri:toggle-window-floating",
        kind: "niri",
        niriAction: ["toggle-window-floating"],
        title: "Toggle Floating Mode",
        subtitle: "Move window between floating and tiling layout",
        category: "Niri",
        icon: "picture_in_picture_alt",
        shortcut: "Mod+V"
    },
    {
        key: "niri:center-column",
        kind: "niri",
        niriAction: ["center-column"],
        title: "Center Focused Column",
        subtitle: "Center the active column horizontally on screen",
        category: "Niri",
        icon: "filter_center_focus",
        shortcut: "Mod+C"
    },
    {
        key: "niri:toggle-overview",
        kind: "niri",
        niriAction: ["toggle-overview"],
        title: "Toggle Overview",
        subtitle: "Open or close the Niri workspace overview",
        category: "Niri",
        icon: "grid_view",
        shortcut: ""
    }
];

// Generate Workspace Switch & Move actions
for (let i = 1; i <= 9; i++) {
    NIRI_ACTIONS.push({
        key: "niri:focus-workspace-" + i,
        kind: "niri",
        niriAction: ["focus-workspace", String(i)],
        title: "Switch to Workspace " + i,
        subtitle: "Focus workspace " + i,
        category: "Niri",
        icon: "layers",
        shortcut: "Mod+" + i
    });
    NIRI_ACTIONS.push({
        key: "niri:move-column-to-workspace-" + i,
        kind: "niri",
        niriAction: ["move-column-to-workspace", String(i)],
        title: "Move Window to Workspace " + i,
        subtitle: "Move active column to workspace " + i,
        category: "Niri",
        icon: "drive_file_move",
        shortcut: "Mod+Shift+" + i
    });
}

function getSystemActions() {
    return SYSTEM_ACTIONS;
}

function getNiriActions() {
    return NIRI_ACTIONS;
}

// Search helper that matches search strings against item properties
function filterItems(items, query, fuzzyModule) {
    if (!query || !query.trim()) return items;
    const q = query.trim().toLowerCase();
    const cleanQ = q.replace(/[^a-z0-9]/g, "");
    const terms = q.split(/\s+/).filter(Boolean);

    return items.filter(item => {
        const rawHay = ((item.title || "") + " " + (item.subtitle || "") + " " + (item.category || "") + " " + (item.shortcut || "") + " " + (item.actionId || "")).toLowerCase();
        const cleanHay = rawHay.replace(/[^a-z0-9]/g, "");

        // 1. Normalized continuous substring match (e.g. "wifi" matches "Wi-Fi", "nightlight" matches "Night Light")
        if (cleanQ.length >= 2 && cleanHay.includes(cleanQ)) return true;

        // 2. Token-by-token matching
        return terms.every(term => {
            const cleanTerm = term.replace(/[^a-z0-9]/g, "");
            return rawHay.includes(term) || (cleanTerm.length >= 2 && cleanHay.includes(cleanTerm));
        });
    });
}
