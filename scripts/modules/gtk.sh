#!/usr/bin/env bash
# Deploy GTK 3, GTK 4, XSettingsd, and Catppuccin SVG assets
set -euo pipefail

deploy_gtk() {
    log_info "Deploying GTK themes, CSS, and SVG icon assets..."

    # Settings
    safe_link "$CONFIGS_DIR/gtk/gtk3-settings.ini" "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    safe_link "$CONFIGS_DIR/gtk/gtk4-settings.ini" "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"
    safe_link "$CONFIGS_DIR/gtk/gtk3.css" "$XDG_CONFIG_HOME/gtk-3.0/gtk.css"
    safe_link "$CONFIGS_DIR/gtk/gtk4.css" "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    safe_link "$CONFIGS_DIR/gtk/xsettingsd.conf" "$XDG_CONFIG_HOME/xsettingsd/xsettingsd.conf"

    # SVG Assets
    if [[ -d "$CONFIGS_DIR/gtk/assets" ]]; then
        safe_link "$CONFIGS_DIR/gtk/assets" "$XDG_CONFIG_HOME/gtk-3.0/assets"
        safe_link "$CONFIGS_DIR/gtk/assets" "$XDG_CONFIG_HOME/gtk-4.0/assets"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_gtk
fi
