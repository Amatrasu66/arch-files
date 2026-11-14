#!/usr/bin/env bash
# Deploy Niri scrollable-tiling compositor configuration
set -euo pipefail

deploy_niri() {
    log_info "Deploying Niri configuration..."
    safe_link "$CONFIGS_DIR/niri/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_niri
fi
