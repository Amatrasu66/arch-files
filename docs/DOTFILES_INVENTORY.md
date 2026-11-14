# Complete Dotfiles Forensic Inventory

| Application | Original Path | Repository Path | File Type | Status | Purpose | Dependencies | Machine Specific | Sensitive |
|---|---|---|---|---|---|---|---|---|
| **Niri** | `~/.config/niri/config.kdl` | `configs/niri/config.kdl` | KDL | Customized | Compositor layout, window rules, keybindings, animations | `niri` | Yes (Monitor names/scale) | No |
| **Kitty** | `~/.config/kitty/kitty.conf` | `configs/terminal/kitty.conf` | Conf | Customized | Catppuccin Mocha terminal theme, glassmorphism, fonts | `kitty` | No | No |
| **Fuzzel** | `~/.config/fuzzel/fuzzel.ini` | `configs/launcher/fuzzel.ini` | INI | Customized | App launcher & dmenu styling, colors, layout | `fuzzel` | Yes (`output=HDMI-A-1`) | No |
| **Zsh** | `~/.zshrc` | `configs/shell/zshrc` | Shell | Customized | Fast interactive shell, history, fzf, autosuggestions | `zsh`, `fzf` | No | No |
| **Bash** | `~/.bashrc` | `configs/shell/bashrc` | Shell | Customized | Fallback shell configuration & environment | `bash` | No | No |
| **Git** | `~/.gitconfig` | `configs/shell/gitconfig.template` | INI | Sanitized Template | Git author name and email | `git` | No | Yes (User credentials sanitized) |
| **Brave** | `~/.config/brave-flags.conf` | `configs/browsers/brave-flags.conf` | Conf | Customized | VA-API hardware video decode on Wayland | `brave-bin` | Yes (Intel VA-API) | No |
| **MIME** | `~/.config/mimeapps.list` | `configs/browsers/mimeapps.list` | Desktop | Customized | Default applications for HTTP, markdown, directory | Core desktop | No | No |
| **Thunar** | `~/.config/Thunar/uca.xml` | `configs/file-manager/uca.xml` | XML | Customized | Custom right-click actions in Thunar file manager | `thunar` | No | No |
| **Thunar Accels** | `~/.config/Thunar/accels.scm` | `configs/file-manager/accels.scm` | Scheme | Customized | Keyboard shortcuts for Thunar | `thunar` | No | No |
| **Swaylock** | `~/.config/swaylock/config` | `configs/lockscreen/swaylock.conf` | Conf | Customized | Standby screen locker indicator rings & colors | `swaylock` | No | No |
| **Lock Session** | `~/.local/bin/lock-session` | `configs/lockscreen/lock-session.sh` | Shell | Customized | Modesty Dynamic Island lockscreen IPC trigger | `quickshell` | No | No |
| **GTK 3** | `~/.config/gtk-3.0/settings.ini` | `configs/gtk/gtk3-settings.ini` | INI | Customized | GTK 3 theme, dark mode, icons, fonts | `gtk3` | No | No |
| **GTK 4** | `~/.config/gtk-4.0/settings.ini` | `configs/gtk/gtk4-settings.ini` | INI | Customized | GTK 4 theme, dark mode, icons, fonts | `gtk4` | No | No |
| **GTK CSS** | `~/.config/gtk-3.0/gtk.css` | `configs/gtk/gtk3.css` | CSS | Customized | Custom GTK 3 style overrides | `gtk3` | No | No |
| **XSettingsd** | `~/.config/xsettingsd/xsettingsd.conf` | `configs/gtk/xsettingsd.conf` | Conf | Customized | X11/XWayland theme and font hinting sync | `xsettingsd` | No | No |
| **Swayidle** | `~/.config/swayidle/config` | `configs/misc/swayidle/config` | Conf | Customized | Inactivity triggers (10m lock, 1h sleep, 6h poweroff) | `swayidle` | No | No |
| **Power Menu** | `~/.local/bin/desktop-power-menu` | `configs/misc/bin/desktop-power-menu` | Shell | Customized | Fuzzel-driven lock, suspend, shutdown menu | `fuzzel` | No | No |
| **Quick Settings** | `~/.local/bin/desktop-quick-settings` | `configs/misc/bin/desktop-quick-settings` | Shell | Customized | Fuzzel-driven Wi-Fi, BT, audio, display menu | `fuzzel`, `wpctl` | Yes (Display scale actions) | No |
| **Modesty Clip** | `~/.local/bin/modesty-clipboard` | `configs/misc/bin/modesty-clipboard` | Shell | Customized | Wayland clipboard history picker | `cliphist`, `fuzzel` | No | No |
| **Inactivity** | `~/.local/bin/session-inactivity-manager` | `configs/misc/bin/session-inactivity-manager` | Shell | Customized | Persistent inactivity power manager | `systemd`, `notify-send` | No | No |
| **Waybar** | Historical Backup | `configs/waybar/config.jsonc` | JSONC | Preserved | Former Waybar status bar config | `waybar` | No | No |
