# Theme & Visual Customization Guide

## Visual Philosophy
The desktop utilizes a unified **Catppuccin Mocha** dark aesthetic, characterized by:
- **Consistent dark background** (`#1e1e2e`).
- **Mauve highlights** (`#cba6f7`) for active focus and interactive elements.
- **Controlled transparency**: Glassmorphism is enabled **only** in Kitty terminal (`background_opacity 0.82`, `background_blur 1`). Windows, dialogs, and panels use solid or subtle alpha layers to prevent visual fatigue.

## Component Implementation Matrix
- **Window Borders**: Niri focus ring `width 2`, `active-color "#cba6f788"`, `gaps 16`.
- **Modesty Dynamic Island**: Custom QML shell with dynamic sizing and fluid animations.
- **GTK Applications**: `catppuccin-mocha-mauve-standard+default` theme applied across GTK 3 and GTK 4 via `settings.ini` and CSS overrides.
- **Icons**: `Papirus-Dark`.
- **Cursors**: `catppuccin-mocha-mauve-cursors` (24px).
- **Fonts**:
  - UI Font: `Adwaita Sans 11`
  - Terminal Font: `Adwaita Mono 11.5` / `JetBrainsMono Nerd Font`
  - Launcher Font: `Inter Variable 12` + `JetBrainsMono Nerd Font 11`
- **Wallpaper**: `~/Pictures/Wallpapers/laundry.jpg` centered with fill mode.
