# Comprehensive Keybindings Map

All keybindings are centralized in Niri (`~/.config/niri/config.kdl`) using `Mod` (Super / Windows key):

## Applications & Menus
| Shortcut | Action | Underlying Command |
|---|---|---|
| `Mod + T` | Open Terminal | `kitty` |
| `Mod + D` / `Mod + Space` | Application Launcher | `fuzzel` |
| `Mod + A` | Modesty App Launcher | `quickshell ipc call island toggle launcher` |
| `Mod + Shift + Space` | Universal Command Canvas | `quickshell ipc call canvas toggle` |
| `Mod + K` / `Mod + Shift + K` | Shortcut Reference | `quickshell ipc call shortcuts toggle` |
| `Mod + I` | Toggle Dynamic Island | `quickshell ipc call island toggle island` |
| `Mod + B` | Bluetooth Menu | `quickshell ipc call island toggle bluetooth` |
| `Mod + Shift + W` | Wi-Fi Menu | `quickshell ipc call island toggle wifi` |
| `Mod + Alt + W` | Wallpaper Selector | `quickshell ipc call island toggle wallpapers` |
| `Mod + Shift + A` | Audio Controls | `quickshell ipc call island toggle sound` |
| `Mod + Shift + D` | Display Controls | `quickshell ipc call island toggle display` |
| `Mod + N` | Notification Center | `quickshell ipc call island toggle notifhistory` |
| `Mod + Alt + N` | Quick Notes | `quickshell ipc call island toggle notes` |
| `Mod + S` | Quick Settings Center | `quickshell ipc call island toggle quicksettings` |
| `Mod + Alt + S` | System Settings | `quickshell ipc call island toggle settings` |
| `Mod + Shift + C` | Calendar View | `quickshell ipc call island toggle calendar` |
| `Mod + Shift + M` | Media Player Card | `quickshell ipc call island toggle media` |
| `Mod + V` | Clipboard History | `/home/amatrasu/.local/bin/modesty-clipboard` |
| `Super + Alt + L` | Lock Screen | `/home/amatrasu/.local/bin/lock-session` |

## Window & Column Navigation
| Shortcut | Action |
|---|---|
| `Mod + Left` / `Mod + H` | Focus column left |
| `Mod + Right` / `Mod + L` | Focus column right |
| `Mod + Down` / `Mod + J` | Focus window down |
| `Mod + Up` / `Mod + K` | Focus window up |
| `Mod + Shift + H` / `Left` | Move column left |
| `Mod + Shift + L` / `Right` | Move column right |
| `Mod + Q` | Close focused window |
| `Mod + R` | Switch preset column width (1/3, 1/2, 2/3) |
| `Mod + F` | Maximize window column |
| `Mod + Shift + F` | Fullscreen window |
| `Mod + C` | Center focused column |
| `Mod + Minus` / `Equal` | Resize column width by -10% / +10% |

## Screenshots & Media
| Shortcut | Action |
|---|---|
| `Print` / `Mod + Shift + S` | Interactive screenshot UI |
| `Ctrl + Print` | Fullscreen screenshot saved to `~/Pictures/Screenshots` |
| `Alt + Print` | Focused window screenshot |
| `XF86AudioRaiseVolume` | Volume +10% (`wpctl`) |
| `XF86AudioLowerVolume` | Volume -10% (`wpctl`) |
| `XF86AudioMute` | Toggle audio mute |
| `XF86AudioMicMute` | Toggle microphone mute |
