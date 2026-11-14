#!/usr/bin/env bash
# Deploy Thunar custom actions and keyboard accelerators
set -euo pipefail

deploy_file_manager() {
    log_info "Deploying Thunar file manager configurations..."
    safe_link "$CONFIGS_DIR/file-manager/uca.xml" "$XDG_CONFIG_HOME/Thunar/uca.xml"
    safe_link "$CONFIGS_DIR/file-manager/accels.scm" "$XDG_CONFIG_HOME/Thunar/accels.scm"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_file_manager
fi
