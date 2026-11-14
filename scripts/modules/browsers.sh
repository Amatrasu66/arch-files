#!/usr/bin/env bash
# Deploy browser flags and default MIME associations
set -euo pipefail

deploy_browsers() {
    log_info "Deploying browser configurations..."
    safe_link "$CONFIGS_DIR/browsers/brave-flags.conf" "$XDG_CONFIG_HOME/brave-flags.conf"
    safe_link "$CONFIGS_DIR/browsers/mimeapps.list" "$XDG_CONFIG_HOME/mimeapps.list"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_browsers
fi
