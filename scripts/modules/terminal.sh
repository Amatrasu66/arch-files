#!/usr/bin/env bash
# Deploy Kitty glassmorphic terminal configuration
set -euo pipefail

deploy_terminal() {
    log_info "Deploying Kitty terminal configuration..."
    safe_link "$CONFIGS_DIR/terminal/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_terminal
fi
