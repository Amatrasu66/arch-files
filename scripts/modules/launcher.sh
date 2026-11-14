#!/usr/bin/env bash
# Deploy Fuzzel application launcher and dmenu configuration
set -euo pipefail

deploy_launcher() {
    log_info "Deploying Fuzzel launcher configuration..."
    safe_link "$CONFIGS_DIR/launcher/fuzzel.ini" "$XDG_CONFIG_HOME/fuzzel/fuzzel.ini"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_launcher
fi
