# Catppuccin Mocha Palette & Implementation

The entire desktop environment is styled consistently in **Catppuccin Mocha** with **Mauve** accents.

## Palette Specification
- **Base**: `#1e1e2e` (Primary window and UI background)
- **Mantle**: `#181825` (Darker surfaces, tab bars, sidebars)
- **Crust**: `#11111b` (Deepest background elements)
- **Surface0**: `#313244` (Selection backgrounds, borders, inactive tabs)
- **Surface1**: `#45475a`
- **Surface2**: `#585b70` (Muted indicators, subtle text)
- **Text**: `#cdd6f4` (Primary foreground text)
- **Subtext0**: `#a6adc8`
- **Subtext1**: `#bac2de`
- **Mauve**: `#cba6f7` (Primary accent color: focus rings, prompts, active tabs)
- **Blue**: `#89b4fa` (Secondary accent: cursor trail, verification rings)
- **Green**: `#a6e3a1` (Success, media play indicators)
- **Red**: `#f38ba8` (Errors, urgency, close buttons)
- **Yellow**: `#f9e2af` (Warnings, notifications)

## Applied Across Components
1. **Niri**: Focus ring `#cba6f788` (mauve with 50% alpha), gaps 16px.
2. **Kitty**: Glassmorphic terminal with `background_opacity 0.82`, `background_blur 1`, cursor `#f5e0dc`, trail `#89b4fa`.
3. **Fuzzel**: Matching background `#1e1e2eff`, border and prompt `#cba6f7ff`, selection `#313244ff`.
4. **Modesty (QuickShell)**: Integrated Dynamic Island with matching QML theme palette.
5. **GTK 3 & 4**: `catppuccin-mocha-mauve-standard+default`.
6. **Icons & Cursors**: `Papirus-Dark` and `catppuccin-mocha-mauve-cursors`.
