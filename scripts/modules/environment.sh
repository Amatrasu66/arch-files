#!/usr/bin/env bash
# Deploy environment.d variables and XDG desktop portals configuration
set -euo pipefail

deploy_environment() {
    log_info "Deploying environment.d and XDG portal configurations..."
    mkdir -p "$XDG_CONFIG_HOME/environment.d"
    for conf in "$CONFIGS_DIR"/misc/environment.d/*.conf; do
        if [[ -f "$conf" ]]; then
            base=$(basename "$conf")
            safe_link "$conf" "$XDG_CONFIG_HOME/environment.d/$base"
        fi
    done

    mkdir -p "$XDG_CONFIG_HOME/xdg-desktop-portal"
    for p in "$CONFIGS_DIR"/misc/xdg-desktop-portal/*.conf; do
        if [[ -f "$p" ]]; then
            base=$(basename "$p")
            safe_link "$p" "$XDG_CONFIG_HOME/xdg-desktop-portal/$base"
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_environment
fi
