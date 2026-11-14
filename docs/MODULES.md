# Modular Architecture & Deployment Modules

`arch-files` organizes desktop configuration and setup into **13 independent deployment modules** located in [`scripts/modules/`](../scripts/modules/).

Each module is:
1. **Independently Executable**: Can be invoked directly (e.g. `./scripts/modules/niri.sh`).
2. **Orchestrated via CLI**: Can be called via `./scripts/configure.sh --module <name>`.
3. **Dry-Run Safe**: Supports the `DRY_RUN=1` environment flag or `--dry-run` parameter to preview actions without filesystem writes.
4. **Collision Protected**: Automatically backs up pre-existing regular files to `.bak.<timestamp>` before creating symlinks.
5. **Sanitized**: Uses `$USER_HOME`, `$XDG_CONFIG_HOME`, and `$PATH` instead of hardcoded paths.

---

## 1. Module Catalog & Symlink Targets

| Module Name | Script Path | Source Path in Repository | Destination Path on Target System | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`system`** | [`system.sh`](../scripts/modules/system.sh) | `configs/misc/bin/*` | `$USER_HOME/.local/bin/*` | Deploys 5 utility scripts (power menu, quick settings, clipboard, inactivity manager) |
| **`environment`**| [`environment.sh`](../scripts/modules/environment.sh) | `configs/misc/environment.d/` | `$XDG_CONFIG_HOME/environment.d/` | Configures Wayland, XDG, and Ozone environment flags |
| **`niri`** | [`niri.sh`](../scripts/modules/niri.sh) | `configs/niri/config.kdl` | `$XDG_CONFIG_HOME/niri/config.kdl` | Deploys Niri scrollable tiling compositor configuration |
| **`modesty`** | [`modesty.sh`](../scripts/modules/modesty.sh) | `upstream/modesty/` | `$USER_HOME/App/Modesty` -> `$XDG_CONFIG_HOME/quickshell` | Clones upstream Modesty, applies customizations patch, copies 11 custom additions, and links QuickShell |
| **`terminal`** | [`terminal.sh`](../scripts/modules/terminal.sh) | `configs/terminal/kitty.conf` | `$XDG_CONFIG_HOME/kitty/kitty.conf` | Glassmorphic Catppuccin Mocha Kitty terminal configuration |
| **`launcher`** | [`launcher.sh`](../scripts/modules/launcher.sh) | `configs/launcher/fuzzel.ini` | `$XDG_CONFIG_HOME/fuzzel/fuzzel.ini` | Fuzzel fuzzy-search application launcher configuration |
| **`shell`** | [`shell.sh`](../scripts/modules/shell.sh) | `configs/shell/` | `$USER_HOME/.zshrc`, `.bashrc`, `.bash_profile`, `.gitconfig` | Shell profiles and git configuration template |
| **`gtk`** | [`gtk.sh`](../scripts/modules/gtk.sh) | `configs/gtk/` | `$XDG_CONFIG_HOME/gtk-3.0/`, `gtk-4.0/`, `xsettingsd/` | GTK 3 & 4 Catppuccin themes, settings.ini, and 68 symbolic SVG icons |
| **`lockscreen`** | [`lockscreen.sh`](../scripts/modules/lockscreen.sh) | `configs/lockscreen/`, `assets/wallpapers/` | `$XDG_CONFIG_HOME/swaylock/`, `swayidle/`, `backgrounds/`, `~/.local/bin/lock-session` | Swaylock, swayidle, default active wallpaper (`laundry.jpg`), and lock-session wrapper |
| **`file-manager`**| [`file-manager.sh`](../scripts/modules/file-manager.sh) | `configs/file-manager/` | `$XDG_CONFIG_HOME/Thunar/` | Thunar file manager custom actions (UCA) and accelerators |
| **`browsers`** | [`browsers.sh`](../scripts/modules/browsers.sh) | `configs/browsers/` | `$XDG_CONFIG_HOME/brave-flags.conf`, `mimeapps.list` | Chromium/Brave hardware video acceleration flags and default browser MIME routing |
| **`services`** | [`services.sh`](../scripts/modules/services.sh) | `configs/misc/systemd-user/` | `$XDG_CONFIG_HOME/systemd/user/` | User systemd service units for quickshell, swaybg, swayidle, and cliphist |
| **`development`**| [`development.sh`](../scripts/modules/development.sh) | Internal validation | N/A | Verifies development runtime toolchains (Node.js, pnpm, Python uv, Android SDK, Neovim) |

---

## 2. Standalone Module Deployment

You can deploy or update any module independently without running a full profile configuration:

```bash
# Preview what the niri module will deploy:
./scripts/configure.sh --dry-run --module niri

# Deploy only the terminal configuration:
./scripts/configure.sh --module terminal

# Deploy only the GTK appearance and assets:
./scripts/configure.sh --module gtk

# Update Modesty desktop shell and custom additions:
./scripts/configure.sh --module modesty
```

Or execute the module script directly:
```bash
./scripts/modules/niri.sh
./scripts/modules/modesty.sh
```

---

## 3. Reversibility & Rollback

Every module records its symlink operations in a deployment manifest.
* To safely remove all managed symlinks deployed by modules:
  ```bash
  ./scripts/uninstall.sh --dry-run   # Preview
  ./scripts/uninstall.sh --confirm   # Execute removal
  ```
* To restore files that were backed up prior to module deployment:
  ```bash
  ./scripts/restore.sh               # Auto-detects and restores latest backup
  ```
