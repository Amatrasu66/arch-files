#!/usr/bin/env bash
# Deploy ~/.local/bin custom scripts and systemd user units
set -euo pipefail

deploy_services() {
    local dry_run="${DRY_RUN:-0}"
    log_info "Deploying helper scripts to ~/.local/bin and systemd user services..."

    # Helper scripts
    mkdir -p "$USER_BIN_DIR"
    for s in "$CONFIGS_DIR"/misc/bin/*; do
        if [[ -f "$s" ]]; then
            base=$(basename "$s")
            safe_link "$s" "$USER_BIN_DIR/$base"
            if [[ "$dry_run" == "0" ]]; then
                chmod +x "$USER_BIN_DIR/$base"
            fi
        fi
    done

    # Systemd user services
    mkdir -p "$USER_SYSTEMD_DIR"
    for u in "$CONFIGS_DIR"/misc/systemd-user/*; do
        if [[ -f "$u" ]]; then
            base=$(basename "$u")
            safe_link "$u" "$USER_SYSTEMD_DIR/$base"
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_services
fi
