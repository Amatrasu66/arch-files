# Qt Wayland Configuration

Qt application theming is configured via environment variables deployed to `~/.config/environment.d/10-theme.conf`:
- `QT_QPA_PLATFORM=wayland`
- `QT_STYLE_OVERRIDE=Fusion`
- `QT_WAYLAND_DISABLE_WINDOWDECORATION=1`

This ensures Qt applications render with native Wayland buffers and match the dark palette without requiring heavy KDE daemon dependencies.
