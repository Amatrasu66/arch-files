# Initial Commit Publication Manifest — arch-files

**Repository:** `https://github.com/Amatrasu66/arch-files`  
**Audit Date:** 2026-11-14  
**Intended Publication Files:** 247  
**Intended Publication Size:** 4.09 MB (4288791 bytes)  
**Excluded Files (Flagged for Licensing):** 3 (808.53 KB)  
**Pre-Commit Status:** **SAFE TO STAGE WITH EXCLUSIONS**

---

## 1. Summary of Intended Publication Files by Category

| Directory / Category | File Count | Size (KB) | Size (MB) | Role & Primary Contents |
| :--- | :---: | :---: | :---: | :--- |
| `.github` | 1 | 0.40 KB | 0.00 MB | Automated GitHub Actions CI validation workflow |
| `Root Files` | 6 | 24.89 KB | 0.02 MB | Core README, AGENTS manual, MIT LICENSE, Security, and Contributing policies |
| `assets` | 25 | 2811.87 KB | 2.75 MB | 23 desktop screenshots, 1 wallpaper guidance README, and architectural diagrams |
| `configs` | 116 | 619.41 KB | 0.60 MB | Sanitized desktop configs (Niri, Kitty, Fuzzel, shell, GTK, 68 SVG assets, systemd units) |
| `docs` | 28 | 139.59 KB | 0.14 MB | 28 forensic audits, profiles, modules, hardware, keybindings, and license documents |
| `packages` | 7 | 5.06 KB | 0.00 MB | Package inventory manifests and declarative group definitions |
| `profiles` | 12 | 4.99 KB | 0.00 MB | Machine-readable profiles (default, minimal, development) with package and module manifests |
| `scripts` | 27 | 33.67 KB | 0.03 MB | Modular installer, orchestrator, 13 deployment modules, validator, and rollback tools |
| `system` | 8 | 4.33 KB | 0.00 MB | System-level configuration templates (/etc, pacman, zram, fstab) |
| `themes` | 1 | 1.44 KB | 0.00 MB | Catppuccin Mocha color palette specifications |
| `upstream` | 16 | 542.62 KB | 0.53 MB | Upstream project registry, Modesty customizations patch, and 11 custom additions |
| **TOTAL INCLUDED** | **247** | **4188.27 KB** | **4.09 MB** | **Clean, verified publication tree** |

---

## 2. Excluded Third-Party Files (Licensing Compliance)

In accordance with strict open-source licensing principles, third-party digital artwork whose provenance and redistribution permissions cannot be verified are **excluded from the public commit** (preserved locally on disk):

| Excluded File Path | Size | Reason for Exclusion | Action Taken |
| :--- | :---: | :--- | :--- |
| `assets/wallpapers/cat-street.jpg` | 42.2 KB | Third-party digital artwork without verified open redistribution license | Preserved locally; omitted from git staging |
| `assets/wallpapers/laundry.jpg` | 314.4 KB | Third-party digital artwork without verified open redistribution license | Preserved locally; omitted from git staging |
| `assets/wallpapers/sushi.jpg` | 452.0 KB | Third-party digital artwork without verified open redistribution license | Preserved locally; omitted from git staging |

*Note: Guidance for providing custom wallpapers is documented in [`assets/wallpapers/README.md`](../assets/wallpapers/README.md).*

---

## 3. General Exclusions & Ignored Patterns (.gitignore)

* **Credentials & Secrets:** `*.key`, `*.pem`, `*.p12`, `*.crt`, `id_rsa`, `id_ed25519`, `*token*`, `*secret*`
* **Logs & Locks:** `*.lock`, `*.log`
* **Environment Overrides:** `.env`, `.env.local`, `*.local`
* **Build & Python Caches:** `__pycache__/`, `*.py[cod]`, `.cache/`, `tmp/`, `node_modules/`
* **Editor Artifacts:** `.DS_Store`, `*.swp`, `*.swo`, `*~`

---

## 4. Licensing Audit & Attribution Summary

* **Modesty Desktop Shell:** Pinned to commit `690af8b` under **GPL-3.0**. All modifications (`modesty-customizations.patch`) and custom additions (`upstream/modesty/additions/`) are licensed under **GPL-3.0**.
* **Catppuccin GTK Theme Assets:** 68 SVG icons in `configs/gtk/assets/` licensed under **GPL-3.0**.
* **Catppuccin Mocha Palette:** `themes/catppuccin-mocha.json` licensed under **MIT**.
* **Compositor & Application Configs:** User-authored configurations for Niri (GPL-3.0), Kitty (GPL-3.0), Fuzzel (MIT), Swaylock (MIT), Thunar (GPL-2.0+), and Brave (MPL-2.0).
* **Repository Automation & Code:** Licensed under **MIT License** (`LICENSE`).

---

## 5. Complete Itemized Inventory of Intended Publication Files

| Relative Path | Size | MIME Type | Publication Status |
| :--- | :---: | :--- | :---: |
| `.gitignore` | 295 B | `text/plain` | **Include** |
| `AGENTS.md` | 3.3 KB | `text/plain` | **Include** |
| `CONTRIBUTING.md` | 497 B | `text/plain` | **Include** |
| `LICENSE` | 1.0 KB | `text/plain` | **Include** |
| `README.md` | 19.2 KB | `text/plain` | **Include** |
| `SECURITY.md` | 537 B | `text/plain` | **Include** |
| `scripts/audit.sh` | 715 B | `text/x-shellscript` | **Include** |
| `scripts/backup.sh` | 655 B | `text/x-shellscript` | **Include** |
| `scripts/bootstrap.sh` | 1.8 KB | `text/x-shellscript` | **Include** |
| `scripts/configure.sh` | 2.4 KB | `text/x-shellscript` | **Include** |
| `scripts/install.sh` | 1.4 KB | `text/x-shellscript` | **Include** |
| `scripts/restore.sh` | 850 B | `text/x-shellscript` | **Include** |
| `scripts/uninstall.sh` | 2.8 KB | `text/x-shellscript` | **Include** |
| `scripts/update.sh` | 293 B | `text/x-shellscript` | **Include** |
| `scripts/validate.sh` | 5.5 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/browsers.sh` | 594 B | `text/x-shellscript` | **Include** |
| `scripts/modules/development.sh` | 449 B | `text/x-shellscript` | **Include** |
| `scripts/modules/environment.sh` | 1001 B | `text/x-shellscript` | **Include** |
| `scripts/modules/file-manager.sh` | 616 B | `text/x-shellscript` | **Include** |
| `scripts/modules/gtk.sh` | 1.1 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/launcher.sh` | 519 B | `text/x-shellscript` | **Include** |
| `scripts/modules/lockscreen.sh` | 1.0 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/modesty.sh` | 2.5 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/niri.sh` | 490 B | `text/x-shellscript` | **Include** |
| `scripts/modules/services.sh` | 1.1 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/shell.sh` | 871 B | `text/x-shellscript` | **Include** |
| `scripts/modules/system.sh` | 1.1 KB | `text/x-shellscript` | **Include** |
| `scripts/modules/terminal.sh` | 507 B | `text/x-shellscript` | **Include** |
| `scripts/lib/backup.sh` | 1.0 KB | `text/x-shellscript` | **Include** |
| `scripts/lib/common.sh` | 1.0 KB | `text/x-shellscript` | **Include** |
| `scripts/lib/packages.sh` | 1008 B | `text/x-shellscript` | **Include** |
| `scripts/lib/paths.sh` | 814 B | `text/x-shellscript` | **Include** |
| `scripts/lib/symlinks.sh` | 1.9 KB | `text/x-shellscript` | **Include** |
| `packages/package-groups.json` | 1.4 KB | `application/json` | **Include** |
| `packages/package-notes.md` | 1.7 KB | `text/plain` | **Include** |
| `packages/packages-development.txt` | 147 B | `text/plain` | **Include** |
| `packages/packages-explicit.txt` | 1.4 KB | `text/plain` | **Include** |
| `packages/packages-flatpak.txt` | 52 B | `text/plain` | **Include** |
| `packages/packages-foreign.txt` | 170 B | `text/plain` | **Include** |
| `packages/packages-system.txt` | 264 B | `text/plain` | **Include** |
| `assets/screenshots/00_desktop_reference.png` | 937.7 KB | `image/png` | **Include** |
| `assets/screenshots/01_desktop_island_collapsed.png` | 22.3 KB | `image/png` | **Include** |
| `assets/screenshots/02_island_hovered_expanded.png` | 39.5 KB | `image/png` | **Include** |
| `assets/screenshots/03_clock_pill_expanded.png` | 29.2 KB | `image/png` | **Include** |
| `assets/screenshots/04_right_pill_expanded.png` | 39.8 KB | `image/png` | **Include** |
| `assets/screenshots/05_quicksettings_main.png` | 73.2 KB | `image/png` | **Include** |
| `assets/screenshots/06_wifi_submenu.png` | 50.1 KB | `image/png` | **Include** |
| `assets/screenshots/07_bluetooth_submenu.png` | 62.8 KB | `image/png` | **Include** |
| `assets/screenshots/08_sound_submenu.png` | 59.8 KB | `image/png` | **Include** |
| `assets/screenshots/09_display_submenu.png` | 65.2 KB | `image/png` | **Include** |
| `assets/screenshots/10_power_submenu.png` | 37.2 KB | `image/png` | **Include** |
| `assets/screenshots/11_media_player_expanded.png` | 103.5 KB | `image/png` | **Include** |
| `assets/screenshots/12_calendar_expanded.png` | 57.3 KB | `image/png` | **Include** |
| `assets/screenshots/13_settings_appearance.png` | 144.2 KB | `image/png` | **Include** |
| `assets/screenshots/14_settings_layout.png` | 137.9 KB | `image/png` | **Include** |
| `assets/screenshots/15_settings_notifications.png` | 121.8 KB | `image/png` | **Include** |
| `assets/screenshots/16_notification_popup.png` | 120.3 KB | `image/png` | **Include** |
| `assets/screenshots/17_quick_notes.png` | 119.9 KB | `image/png` | **Include** |
| `assets/screenshots/18_command_canvas.png` | 134.1 KB | `image/png` | **Include** |
| `assets/screenshots/19_application_launcher.png` | 120.9 KB | `image/png` | **Include** |
| `assets/screenshots/20_regular_window_foreground.png` | 121.9 KB | `image/png` | **Include** |
| `assets/screenshots/21_maximized_window.png` | 110.9 KB | `image/png` | **Include** |
| `assets/screenshots/22_fullscreen_window.png` | 101.4 KB | `image/png` | **Include** |
| `assets/diagrams/README.md` | 141 B | `text/plain` | **Include** |
| `assets/wallpapers/README.md` | 762 B | `text/plain` | **Include** |
| `profiles/development/README.md` | 322 B | `text/plain` | **Include** |
| `profiles/development/modules.txt` | 114 B | `text/plain` | **Include** |
| `profiles/development/packages.txt` | 851 B | `text/plain` | **Include** |
| `profiles/development/profile.json` | 638 B | `application/json` | **Include** |
| `profiles/minimal/README.md` | 320 B | `text/plain` | **Include** |
| `profiles/minimal/modules.txt` | 48 B | `text/plain` | **Include** |
| `profiles/minimal/packages.txt` | 375 B | `text/plain` | **Include** |
| `profiles/minimal/profile.json` | 491 B | `application/json` | **Include** |
| `profiles/default/README.md` | 471 B | `text/plain` | **Include** |
| `profiles/default/modules.txt` | 102 B | `text/plain` | **Include** |
| `profiles/default/packages.txt` | 751 B | `text/plain` | **Include** |
| `profiles/default/profile.json` | 627 B | `application/json` | **Include** |
| `upstream/README.md` | 1.0 KB | `text/plain` | **Include** |
| `upstream/projects.json` | 1.8 KB | `application/json` | **Include** |
| `upstream/modesty/README.md` | 1.8 KB | `text/plain` | **Include** |
| `upstream/modesty/upstream.json` | 478 B | `application/json` | **Include** |
| `upstream/modesty/additions/scripts/ai-agent-status.py` | 12.8 KB | `text/x-script.python` | **Include** |
| `upstream/modesty/additions/scripts/sync_shortcuts.py` | 92.4 KB | `text/x-script.python` | **Include** |
| `upstream/modesty/additions/modules/island/AiAgentPill.qml` | 19.8 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/modules/shortcuts/ShortcutReference.qml` | 36.8 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/config/shortcuts/shortcut_registry.json` | 118.0 KB | `application/json` | **Include** |
| `upstream/modesty/additions/integrations/compositor/CompositorAdapter.qml` | 1.3 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/integrations/compositor/NiriAdapter.qml` | 5.5 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/integrations/compositor/capabilities.json` | 1.1 KB | `application/json` | **Include** |
| `upstream/modesty/additions/services/CommandHistory.qml` | 2.2 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/services/CommandProviders.js` | 12.3 KB | `text/plain` | **Include** |
| `upstream/modesty/additions/services/Compositor.qml` | 773 B | `text/plain` | **Include** |
| `upstream/modesty/patches/modesty-customizations.patch` | 234.7 KB | `text/x-diff` | **Include** |
| `docs/CHANGELOG.md` | 644 B | `text/plain` | **Include** |
| `docs/CUSTOMIZATIONS.md` | 1.5 KB | `text/plain` | **Include** |
| `docs/DEPENDENCY_MAP.md` | 1.1 KB | `text/plain` | **Include** |
| `docs/DEPLOYMENT_SIMULATION_REPORT.md` | 12.2 KB | `text/plain` | **Include** |
| `docs/DISPLAY_CONFIGURATION.md` | 1.3 KB | `text/plain` | **Include** |
| `docs/DOTFILES_INVENTORY.md` | 3.9 KB | `text/plain` | **Include** |
| `docs/ENVIRONMENT_VARIABLES.md` | 994 B | `text/plain` | **Include** |
| `docs/HARDWARE.md` | 2.6 KB | `text/plain` | **Include** |
| `docs/INITIAL_COMMIT_MANIFEST.md` | 24.1 KB | `text/plain` | **Include** |
| `docs/KEYBINDINGS.md` | 2.8 KB | `text/plain` | **Include** |
| `docs/MODULES.md` | 4.6 KB | `text/plain` | **Include** |
| `docs/PACKAGE_INVENTORY.md` | 1.4 KB | `text/plain` | **Include** |
| `docs/PRE_COMMIT_AUDIT_REPORT.md` | 8.7 KB | `text/plain` | **Include** |
| `docs/PROFILES.md` | 6.8 KB | `text/plain` | **Include** |
| `docs/RELEASE_READINESS_REPORT.md` | 11.6 KB | `text/plain` | **Include** |
| `docs/REMEDIATION_REPORT.md` | 9.7 KB | `text/plain` | **Include** |
| `docs/REPOSITORY_VERIFICATION_REPORT.md` | 18.7 KB | `text/plain` | **Include** |
| `docs/SCREENSHOT_CATALOG.md` | 2.8 KB | `text/plain` | **Include** |
| `docs/SECURITY_AND_PORTABILITY.md` | 1.5 KB | `text/plain` | **Include** |
| `docs/SERVICES.md` | 2.2 KB | `text/plain` | **Include** |
| `docs/SOFTWARE_INVENTORY.md` | 3.2 KB | `text/plain` | **Include** |
| `docs/SYSTEM_AUDIT.md` | 1.1 KB | `text/plain` | **Include** |
| `docs/SYSTEM_CONFIGURATIONS.md` | 883 B | `text/plain` | **Include** |
| `docs/SYSTEM_OVERVIEW.md` | 2.0 KB | `text/plain` | **Include** |
| `docs/THEME_AND_APPEARANCE.md` | 1.2 KB | `text/plain` | **Include** |
| `docs/THIRD_PARTY_LICENSES.md` | 5.5 KB | `text/plain` | **Include** |
| `docs/TROUBLESHOOTING.md` | 5.6 KB | `text/plain` | **Include** |
| `docs/UPSTREAM_PROJECTS.md` | 1017 B | `text/plain` | **Include** |
| `themes/catppuccin/README.md` | 1.4 KB | `text/plain` | **Include** |
| `.github/workflows/ci.yml` | 414 B | `text/plain` | **Include** |
| `system/sysctl/README.md` | 141 B | `text/plain` | **Include** |
| `system/other/fstab.template` | 427 B | `text/plain` | **Include** |
| `system/kernel/README.md` | 253 B | `text/plain` | **Include** |
| `system/environment/README.md` | 225 B | `text/plain` | **Include** |
| `system/pacman/pacman.conf` | 2.9 KB | `text/plain` | **Include** |
| `system/boot/README.md` | 267 B | `text/plain` | **Include** |
| `system/services/zram-generator.conf` | 37 B | `text/plain` | **Include** |
| `system/udev/README.md` | 157 B | `text/plain` | **Include** |
| `configs/qt/README.md` | 384 B | `text/plain` | **Include** |
| `configs/icons/README.md` | 366 B | `text/plain` | **Include** |
| `configs/waybar/config.jsonc` | 2.9 KB | `text/plain` | **Include** |
| `configs/waybar/style.css` | 3.1 KB | `text/plain` | **Include** |
| `configs/audio/README.md` | 337 B | `text/plain` | **Include** |
| `configs/launcher/fuzzel.ini` | 1.1 KB | `text/plain` | **Include** |
| `configs/wallpaper/README.md` | 343 B | `text/plain` | **Include** |
| `configs/file-manager/accels.scm` | 8.4 KB | `text/plain` | **Include** |
| `configs/file-manager/uca.xml` | 419 B | `text/xml` | **Include** |
| `configs/niri/config.kdl` | 29.1 KB | `text/plain` | **Include** |
| `configs/theme/README.md` | 235 B | `text/plain` | **Include** |
| `configs/browsers/brave-flags.conf` | 243 B | `text/plain` | **Include** |
| `configs/browsers/mimeapps.list` | 536 B | `text/plain` | **Include** |
| `configs/lockscreen/lock-session.sh` | 1.1 KB | `text/x-shellscript` | **Include** |
| `configs/lockscreen/swaylock.conf` | 977 B | `text/plain` | **Include** |
| `configs/misc/swayidle/config` | 1.0 KB | `text/plain` | **Include** |
| `configs/misc/bin/desktop-power-menu` | 461 B | `text/x-shellscript` | **Include** |
| `configs/misc/bin/desktop-quick-settings` | 4.4 KB | `text/x-shellscript` | **Include** |
| `configs/misc/bin/modesty-clipboard` | 849 B | `text/x-shellscript` | **Include** |
| `configs/misc/bin/modesty-clipboard-clear` | 763 B | `text/x-shellscript` | **Include** |
| `configs/misc/bin/session-inactivity-manager` | 7.3 KB | `text/x-shellscript` | **Include** |
| `configs/misc/xdg-desktop-portal/niri-portals.conf` | 163 B | `text/plain` | **Include** |
| `configs/misc/xdg-desktop-portal/portals.conf` | 163 B | `text/plain` | **Include** |
| `configs/misc/systemd-user/cliphist.service` | 387 B | `text/plain` | **Include** |
| `configs/misc/systemd-user/localsearch-3.service` | 0 B | `inode/symlink` | **Include** |
| `configs/misc/systemd-user/localsearch-control-3.service` | 0 B | `inode/symlink` | **Include** |
| `configs/misc/systemd-user/localsearch-writeback-3.service` | 0 B | `inode/symlink` | **Include** |
| `configs/misc/systemd-user/quickshell.service` | 537 B | `text/plain` | **Include** |
| `configs/misc/systemd-user/swaybg.service` | 302 B | `text/plain` | **Include** |
| `configs/misc/systemd-user/swayidle.service` | 517 B | `text/plain` | **Include** |
| `configs/misc/environment.d/10-local-libs.conf` | 35 B | `text/plain` | **Include** |
| `configs/misc/environment.d/10-theme.conf` | 198 B | `text/plain` | **Include** |
| `configs/networking/README.md` | 315 B | `text/plain` | **Include** |
| `configs/notifications/README.md` | 251 B | `text/plain` | **Include** |
| `configs/shell/bash_profile` | 133 B | `text/plain` | **Include** |
| `configs/shell/bashrc` | 492 B | `text/plain` | **Include** |
| `configs/shell/gitconfig.template` | 57 B | `text/plain` | **Include** |
| `configs/shell/zshrc` | 2.8 KB | `text/plain` | **Include** |
| `configs/fonts/README.md` | 248 B | `text/plain` | **Include** |
| `configs/terminal/kitty.conf` | 1.6 KB | `text/plain` | **Include** |
| `configs/gtk/gtk3-settings.ini` | 218 B | `text/plain` | **Include** |
| `configs/gtk/gtk3.css` | 255.2 KB | `text/plain` | **Include** |
| `configs/gtk/gtk4-settings.ini` | 218 B | `text/plain` | **Include** |
| `configs/gtk/gtk4.css` | 232.3 KB | `text/plain` | **Include** |
| `configs/gtk/xsettingsd.conf` | 266 B | `text/plain` | **Include** |
| `configs/gtk/assets/checkbox-checked-symbolic.svg` | 2.0 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/checkbox-checked-symbolic@2.svg` | 2.0 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/checkbox-mixed-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/checkbox-mixed-symbolic@2.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/close-symbolic.svg` | 1.6 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/close-symbolic@2.svg` | 647 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/cursor-handle-symbolic.svg` | 111 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/maximize-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/maximize-symbolic@2.svg` | 350 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/menu-radio-symbolic.svg` | 186 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/menu-radio-symbolic@2.svg` | 187 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/minimize-symbolic.svg` | 1.1 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/minimize-symbolic@2.svg` | 195 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/radio-checked-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/radio-checked-symbolic@2.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/radio-mixed-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/radio-mixed-symbolic@2.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-dark.svg` | 796 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-dark@2.svg` | 782 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-disabled-dark.svg` | 814 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-disabled-dark@2.svg` | 800 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-disabled.svg` | 858 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider-disabled@2.svg` | 838 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider.svg` | 839 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-after-slider@2.svg` | 811 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-dark.svg` | 766 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-dark@2.svg` | 767 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-disabled-dark.svg` | 784 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-disabled-dark@2.svg` | 785 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-disabled.svg` | 824 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider-disabled@2.svg` | 825 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider.svg` | 805 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-horz-marks-before-slider@2.svg` | 806 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-dark.svg` | 795 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-dark@2.svg` | 780 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-disabled-dark.svg` | 813 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-disabled-dark@2.svg` | 798 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-disabled.svg` | 853 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider-disabled@2.svg` | 838 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider.svg` | 834 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-after-slider@2.svg` | 819 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-dark.svg` | 796 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-dark@2.svg` | 780 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-disabled-dark.svg` | 814 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-disabled-dark@2.svg` | 798 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-disabled.svg` | 856 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider-disabled@2.svg` | 836 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider.svg` | 837 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/scale-vert-marks-before-slider@2.svg` | 817 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-checked-dark.svg` | 273 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-checked-dark@2.svg` | 287 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-checked.svg` | 273 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-checked@2.svg` | 287 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-unchecked-dark.svg` | 282 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-unchecked-dark@2.svg` | 262 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-unchecked.svg` | 282 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/selectionmode-checkbox-unchecked@2.svg` | 262 B | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-checkbox-checked-symbolic.svg` | 1.6 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-checkbox-checked-symbolic@2.svg` | 1.6 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-checkbox-mixed-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-checkbox-mixed-symbolic@2.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-radio-checked-symbolic.svg` | 1.2 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-radio-checked-symbolic@2.svg` | 1.2 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-radio-mixed-symbolic.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/small-radio-mixed-symbolic@2.svg` | 1.3 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/unmaximize-symbolic.svg` | 1.6 KB | `image/svg+xml` | **Include** |
| `configs/gtk/assets/unmaximize-symbolic@2.svg` | 540 B | `image/svg+xml` | **Include** |
| `configs/bluetooth/README.md` | 279 B | `text/plain` | **Include** |
| `configs/modesty/cava.conf` | 135 B | `text/plain` | **Include** |
| `configs/modesty/session.json` | 477 B | `application/json` | **Include** |
| `configs/cursor/README.md` | 238 B | `text/plain` | **Include** |