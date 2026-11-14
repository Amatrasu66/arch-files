# Third-Party Licenses & Project Attribution

This document provides a comprehensive inventory of all third-party software, themes, assets, and reference implementations integrated into or referenced by the `arch-files` configuration project.

---

## 1. Upstream Desktop Shell: Modesty

* **Project Name:** Modesty (Dynamic Island Wayland Desktop Shell)
* **Upstream Author:** Sandeep Bist (`sandeepbist`)
* **Upstream Repository:** [https://github.com/sandeepbist/Modesty.git](https://github.com/sandeepbist/Modesty.git)
* **Pinned Base Commit:** `690af8b5905b166997ae0c6c57c44e7ad1f7aef6`
* **License:** GNU General Public License v3.0 (GPL-3.0)
* **Role:** Primary Wayland desktop shell, dynamic status island, quick settings control center, lock screen, and application launcher framework built on QuickShell / QtQuick / QML.
* **Modifications & Additions:**
  * Custom modifications are encapsulated in `upstream/modesty/patches/modesty-customizations.patch` (38 files modified).
  * 11 custom additions are stored in `upstream/modesty/additions/` (`AiAgentPill.qml`, `ShortcutReference.qml`, `ai-agent-status.py`, `sync_shortcuts.py`, `CommandHistory.qml`, `CommandProviders.js`, `Compositor.qml`, `CompositorAdapter.qml`, `NiriAdapter.qml`, `shortcut_registry.json`, `capabilities.json`).
* **License Compliance:** In accordance with the GNU General Public License v3.0, all modifications and additions to Modesty are licensed under the GPL-3.0. Full source code of the patches and additions is provided in this repository.

---

## 2. Theme & Color Palette: Catppuccin Mocha

* **Project Name:** Catppuccin
* **Upstream Authors:** Catppuccin Org and Contributors
* **Upstream Repository:** [https://github.com/catppuccin/catppuccin](https://github.com/catppuccin/catppuccin)
* **License:** MIT License
* **Role:** Core color palette for the entire desktop environment (Rosewater, Flamingo, Pink, Mauve, Red, Maroon, Peach, Yellow, Green, Teal, Sky, Sapphire, Blue, Lavender, Text, Subtext, Surface, Base, Mantle, Crust).
* **Reference Specifications:** `themes/catppuccin-mocha.json`

---

## 3. GTK Theme & Symbolic Assets

* **Project Name:** Catppuccin GTK Theme
* **Upstream Repository:** [https://github.com/catppuccin/gtk](https://github.com/catppuccin/gtk) / [https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme](https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme)
* **License:** GNU General Public License v3.0 (GPL-3.0)
* **Bundled Assets:** 68 symbolic SVG icons stored in `configs/gtk/assets/` referenced by `gtk3.css` and `gtk4.css`.
* **License Compliance:** The GTK CSS style sheets and SVG symbolic assets are distributed under the terms of the GNU General Public License v3.0.

---

## 4. Compositor & Application Configurations

The following components are configured using user-authored configuration files designed for upstream software:

| Component | Upstream Project | Upstream License | Repository Path |
| :--- | :--- | :--- | :--- |
| **Niri** | [YaLTeR/niri](https://github.com/YaLTeR/niri) | GPL-3.0 | `configs/niri/config.kdl` |
| **Kitty** | [kovidgoyal/kitty](https://github.com/kovidgoyal/kitty) | GPL-3.0 | `configs/terminal/kitty.conf` |
| **Fuzzel** | [dnkl/fuzzel](https://codeberg.org/dnkl/fuzzel) | MIT License | `configs/launcher/fuzzel.ini` |
| **Swaylock** | [swaywm/swaylock](https://github.com/swaywm/swaylock) | MIT License | `configs/lockscreen/swaylock.conf` |
| **Swayidle** | [swaywm/swayidle](https://github.com/swaywm/swayidle) | MIT License | `configs/misc/swayidle/config` |
| **Thunar** | [xfce-mirror/thunar](https://gitlab.xfce.org/xfce/thunar) | GPL-2.0+ | `configs/file-manager/thunar-uca.xml` |
| **Brave** | [brave/brave-browser](https://github.com/brave/brave-browser) | MPL-2.0 | `configs/browsers/brave-flags.conf` |

---

## 5. Desktop Wallpapers & Artistic Assets

* **Files Inspected:**
  * `assets/wallpapers/cat-street.jpg`
  * `assets/wallpapers/laundry.jpg` (Active reference wallpaper)
  * `assets/wallpapers/sushi.jpg`
* **Source & Provenance:** Third-party digital artwork circulating in desktop customization communities (e.g. r/unixporn, Wallhaven). Original artists are unverified and no verifiable Creative Commons or public domain license is attached.
* **Redistribution Policy:** Under open-source licensing standards, disclaimers or opt-out notices do not confer redistribution rights. Consequently, **these third-party wallpaper files are flagged and excluded from the public Git release**.
* **User Guidance:** Users provide their own wallpaper by placing any image at `~/.config/backgrounds/wallpaper.jpg`. See [`assets/wallpapers/README.md`](../assets/wallpapers/README.md).

---

## 6. Historical Reference Implementations

* **Dynamic Island Hyprland:** [St0rmosu/dynamic-island-hyprland](https://github.com/St0rmosu/dynamic-island-hyprland) (MIT License). Served as reference architecture for Dynamic Island geometry and lock screen PAM integration.
* **Waybar:** [Alexays/Waybar](https://github.com/Alexays/Waybar) (MIT License). Legacy status bar migrated to Modesty. Historical configs preserved in `configs/waybar/`.
* **Hyprdots:** [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots) (GPL-3.0). Historical theming reference.

---

## 7. Project Code License

The automation scripts, deployment modules, manifests, validators, and original documentation authored specifically for the `arch-files` project are licensed under the **MIT License** as detailed in [LICENSE](../LICENSE).
Third-party components and derivative modifications retain their respective upstream licenses.
