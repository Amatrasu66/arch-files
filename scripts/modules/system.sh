#!/usr/bin/env bash
# System configuration checks (pacman, zram) and user helper scripts
set -euo pipefail

deploy_system() {
    log_info "Verifying system-level configuration templates..."
    if [[ -f "$SYSTEM_DIR/pacman/pacman.conf" ]]; then
        log_info "Pacman reference available at: $SYSTEM_DIR/pacman/pacman.conf"
    fi
    if [[ -f "$SYSTEM_DIR/services/zram-generator.conf" ]]; then
        log_info "zram reference available at: $SYSTEM_DIR/services/zram-generator.conf"
    fi

    # Deploy helper scripts to ~/.local/bin
    if [[ -d "$CONFIGS_DIR/misc/bin" ]]; then
        log_info "Deploying system utility scripts to ~/.local/bin..."
        mkdir -p "$USER_HOME/.local/bin"
        for s in "$CONFIGS_DIR/misc/bin"/*; do
            if [[ -f "$s" ]]; then
                base=$(basename "$s")
                safe_link "$s" "$USER_HOME/.local/bin/$base"
            fi
        done
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_system
fi
