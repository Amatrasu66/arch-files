# System & User Services Architecture

## Systemd User Services (Graphical Session)
User units are tied to `graphical-session.target` and started when Niri initializes:

| Unit Name | State | Purpose | Executable / Command |
|---|---|---|---|
| `niri.service` | Active (Running) | Core Wayland compositor session | `/usr/bin/niri --session` |
| `quickshell.service` | Active (Running) | Modesty Dynamic Island shell | `/usr/bin/quickshell` |
| `swaybg.service` | Active (Running) | Desktop wallpaper daemon | `/usr/bin/swaybg -i .../laundry.jpg -m fill` |
| `swayidle.service` | Active (Running) | Session inactivity power management | `%h/.local/bin/swayidle -w -C ...` |
| `cliphist.service` | Active (Running) | Wayland clipboard history watcher | `/usr/bin/wl-paste --watch cliphist store` |
| `pipewire.service` | Active (Running) | Multimedia audio server | `/usr/bin/pipewire` |
| `pipewire-pulse.service` | Active (Running) | PulseAudio compatibility daemon | `/usr/bin/pipewire-pulse` |
| `wireplumber.service` | Active (Running) | Audio session & policy manager | `/usr/bin/wireplumber` |
| `xdg-desktop-portal.service` | Active (Running) | Desktop portal router | `/usr/lib/xdg-desktop-portal` |
| `xdg-desktop-portal-gnome.service` | Active (Running) | ScreenCast / Screenshot portal | `/usr/lib/xdg-desktop-portal-gnome` |
| `xdg-desktop-portal-gtk.service` | Active (Running) | File chooser / Dialog portal | `/usr/lib/xdg-desktop-portal-gtk` |
| `gnome-keyring-daemon.service` | Active (Running) | Secret service provider | `/usr/bin/gnome-keyring-daemon` |

## Systemd System Services
| Unit Name | Enabled State | Running State | Purpose |
|---|---|---|---|
| `NetworkManager.service` | Enabled | Active | Primary network interface management |
| `bluetooth.service` | Enabled | Active | Bluetooth stack daemon (`bluez`) |
| `systemd-timesyncd.service` | Enabled | Active | NTP network time synchronization |
| `systemd-logind.service` | Static | Active | Session, seat, and power key management |
| `fstrim.timer` | Enabled | Active (Timer) | Weekly SSD TRIM optimization |
| `paccache.timer` | Enabled | Active (Timer) | Weekly pacman cache cleanup |
| `getty@tty1.service` | Enabled | Active | Direct console login on tty1 (auto-starts niri) |
