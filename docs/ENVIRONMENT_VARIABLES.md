# Environment Variables & Session Configuration

## System-Wide Environment (`~/.config/environment.d/*.conf`)
Parsed automatically by `systemd --user` on login:

```ini
# 10-local-libs.conf
LD_LIBRARY_PATH=${HOME}/.local/lib

# 10-theme.conf
GTK_THEME=catppuccin-mocha-mauve-standard+default
XCURSOR_THEME=catppuccin-mocha-mauve-cursors
XCURSOR_SIZE=24
QT_QPA_PLATFORM=wayland
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
QT_STYLE_OVERRIDE=Fusion
```

## Interactive Shell Exports (`~/.zshrc`)
```bash
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH
export ANDROID_HOME="$HOME/Android/Sdk"
export GTK_THEME="catppuccin-mocha-mauve-standard+default"
export XCURSOR_THEME="catppuccin-mocha-mauve-cursors"
export XCURSOR_SIZE="24"
export QT_QPA_PLATFORM="wayland"
export QT_STYLE_OVERRIDE="Fusion"
```

## Security & Secrets Policy
- No access tokens, API keys, or private SSH keys are stored in environment files.
- Configuration templates use placeholders (e.g. `YOUR_API_KEY_HERE`).
