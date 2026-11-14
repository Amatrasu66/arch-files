#!/usr/bin/env bash
# Deploy Swaylock, Swayidle, and default wallpaper
set -euo pipefail

deploy_lockscreen() {
    log_info "Deploying lockscreen and power idle configurations..."
    safe_link "$CONFIGS_DIR/lockscreen/swaylock.conf" "$XDG_CONFIG_HOME/swaylock/config"
    safe_link "$CONFIGS_DIR/misc/swayidle/config" "$XDG_CONFIG_HOME/swayidle/config"
    
    # Deploy active wallpaper
    if [[ -f "$REPO_ROOT/assets/wallpapers/laundry.jpg" ]]; then
        mkdir -p "$XDG_CONFIG_HOME/backgrounds"
        safe_copy "$REPO_ROOT/assets/wallpapers/laundry.jpg" "$XDG_CONFIG_HOME/backgrounds/wallpaper.jpg"
    fi

    # Deploy lock-session helper
    if [[ -f "$CONFIGS_DIR/lockscreen/lock-session.sh" ]]; then
        safe_link "$CONFIGS_DIR/lockscreen/lock-session.sh" "$USER_HOME/.local/bin/lock-session"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_lockscreen
fi
