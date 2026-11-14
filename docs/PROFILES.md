# Installation Profiles Specification & Comparison

`arch-files` features a declarative, profile-driven deployment architecture. Profiles allow users and automated deployment agents to select the precise scope of configuration and package installation required for their specific use case.

All profiles are machine-readable and stored in the [`profiles/`](../profiles/) directory:
* [`profiles/default/`](../profiles/default/)
* [`profiles/minimal/`](../profiles/minimal/)
* [`profiles/development/`](../profiles/development/)

Each profile contains:
1. `profile.json`: Metadata, description, target compositor, and list of enabled modules.
2. `packages.txt`: Explicit, sorted list of native and AUR packages required for the profile.
3. `modules.txt`: Execution order of deployment modules (`scripts/modules/*.sh`).

---

## 1. Profile Comparison Matrix

| Feature / Domain | Minimal Profile (`minimal`) | Default Profile (`default`) | Development Profile (`development`) |
| :--- | :--- | :--- | :--- |
| **Target User** | Minimalists, low-spec systems, testing | Daily desktop workstation | Full-stack & mobile software engineers |
| **Compositor** | Niri 26.04 (Wayland scrollable tiling) | Niri 26.04 (Wayland scrollable tiling) | Niri 26.04 (Wayland scrollable tiling) |
| **Desktop Shell** | None (Raw Niri compositor) | Modesty (Dynamic Island QuickShell) | Modesty (Dynamic Island QuickShell) |
| **Terminal** | Kitty (Catppuccin Mocha glassmorphic) | Kitty (Catppuccin Mocha glassmorphic) | Kitty (Catppuccin Mocha glassmorphic) |
| **Launcher** | Fuzzel (Catppuccin theme) | Fuzzel + Modesty App Launcher & Canvas | Fuzzel + Modesty App Launcher & Canvas |
| **File Manager** | None (CLI file tools: `fd`, `bat`, `tree`) | Thunar (XFCE) + custom actions | Thunar (XFCE) + custom actions |
| **Web Browsers** | None (Installed on-demand) | Brave Browser (`brave-bin`) | Brave, Helium Browser, Zen Browser |
| **Session Locking** | None (TTY lock / exit) | Swaylock + Modesty PAM lockscreen | Swaylock + Modesty PAM lockscreen |
| **Power Management**| None (Manual systemctl) | Swayidle + Session Inactivity Manager | Swayidle + Session Inactivity Manager |
| **GTK Appearance** | System fallback | Catppuccin Mocha GTK3/4 + 68 SVGs | Catppuccin Mocha GTK3/4 + 68 SVGs |
| **Development Suite**| Git | Git + `gitconfig.template` | Full Toolchain (Node, Android, VS Code, Neovim) |
| **Total Packages** | **37 packages** | **77 packages** | **83 packages** |
| **Enabled Modules** | **6 modules** | **12 modules** | **13 modules** |

---

## 2. Enabled Modules by Profile

| Module Script (`scripts/modules/`) | Description | `minimal` | `default` | `development` |
| :--- | :--- | :---: | :---: | :---: |
| [`system.sh`](../scripts/modules/system.sh) | Pacman/zram templates & `~/.local/bin` utilities | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`environment.sh`](../scripts/modules/environment.sh) | Wayland & XDG environment variables | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`niri.sh`](../scripts/modules/niri.sh) | Niri compositor layout & keybindings | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`terminal.sh`](../scripts/modules/terminal.sh) | Kitty terminal configuration | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`launcher.sh`](../scripts/modules/launcher.sh) | Fuzzel application launcher | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`shell.sh`](../scripts/modules/shell.sh) | Zsh & Bash dotfiles, gitconfig template | ✅ Enabled | ✅ Enabled | ✅ Enabled |
| [`modesty.sh`](../scripts/modules/modesty.sh) | Dynamic Island clone, patch & custom additions | ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`gtk.sh`](../scripts/modules/gtk.sh) | Catppuccin GTK 3/4 themes & 68 SVG assets | ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`lockscreen.sh`](../scripts/modules/lockscreen.sh) | Swaylock, swayidle & active wallpaper | ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`file-manager.sh`](../scripts/modules/file-manager.sh) | Thunar UCA custom actions & accelerators | ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`browsers.sh`](../scripts/modules/browsers.sh) | Brave flags & default MIME associations | ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`services.sh`](../scripts/modules/services.sh) | Systemd user units (quickshell, swaybg, etc.)| ❌ Excluded | ✅ Enabled | ✅ Enabled |
| [`development.sh`](../scripts/modules/development.sh) | Developer environment verification & templates| ❌ Excluded | ❌ Excluded | ✅ Enabled |

---

## 3. Package Breakdown & Categorization

### 3.1 Common Base Packages (All Profiles)
All profiles include the 37 essential base packages required to run a pure Wayland Niri desktop on modern 64-bit hardware:
* **Base Core**: `base`, `base-devel`, `sudo`, `efibootmgr`, `linux`, `linux-firmware`, `mkinitcpio`
* **Hardware & Drivers**: `mesa`, `vulkan-intel`, `zram-generator`, `brightnessctl`
* **Networking & Bluetooth**: `networkmanager`, `wpa_supplicant`, `bluez`, `bluez-utils`
* **Audio Server**: `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `wireplumber`
* **Compositor & Wayland**: `niri`, `xwayland-satellite`, `swaybg`, `fuzzel`, `wl-clipboard`, `polkit-gnome`, `xdg-utils`
* **Shell & Terminal**: `kitty`, `zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `bat`, `ripgrep`, `fd`, `fastfetch`, `tree`, `git`

### 3.2 Packages Added in `default` (+40 packages)
The `default` profile adds desktop lifestyle, file management, UI shell, and browser applications:
* **Desktop Shell & Integration**: `quickshell`, `mako`, `swaylock`, `intel-ucode`, `intel-media-driver`, `linux-lts`, `smartmontools`, `playerctl`, `mpv`, `yt-dlp`, `ffmpegthumbnailer`
* **Everyday Applications**: `brave-bin`, `alacritty` (fallback terminal)
* **File Management Stack**: `thunar`, `tumbler`, `webp-pixbuf-loader`, `gvfs`, `gnome-keyring`, `zip`, `unzip`
* **System Monitoring & CLI**: `btop`, `htop`, `lsof`, `wget`, `aria2`, `ani-cli`
* **AUR Tooling**: `yay-bin`

### 3.3 Packages Added in `development` (+6 packages)
The `development` profile augments the `default` desktop with comprehensive development toolchains:
* **Development Editors & IDEs**: `visual-studio-code-bin`, `android-studio`
* **Mobile Toolchain**: `android-tools`, `android-udev`
* **Alternative Browsers**: `helium-browser-bin`, `zen-browser-bin`
*(Runtime toolchains such as Node.js LTS, pnpm, Python uv/pipx, and Neovim are managed via user-level package managers or verified in `development.sh`)*

---

## 4. How to Use Profiles

### Previewing (Dry-Run)
To preview which packages and symlinks will be deployed without mutating the system:
```bash
# Package preview
./scripts/install.sh --dry-run <profile_name>

# Configuration preview
./scripts/configure.sh --dry-run --profile <profile_name>
```

### Full Deployment
```bash
# Example: Deploying the default profile
./scripts/bootstrap.sh
./scripts/install.sh default
./scripts/configure.sh --profile default
```
