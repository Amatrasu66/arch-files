#!/usr/bin/env bash
# Deploy Zsh and Bash configurations
set -euo pipefail

deploy_shell() {
    log_info "Deploying shell configurations..."
    safe_link "$CONFIGS_DIR/shell/zshrc" "$USER_HOME/.zshrc"
    safe_link "$CONFIGS_DIR/shell/bashrc" "$USER_HOME/.bashrc"
    safe_link "$CONFIGS_DIR/shell/bash_profile" "$USER_HOME/.bash_profile"
    if [[ ! -f "$USER_HOME/.gitconfig" && -f "$CONFIGS_DIR/shell/gitconfig.template" ]]; then
        safe_copy "$CONFIGS_DIR/shell/gitconfig.template" "$USER_HOME/.gitconfig"
        log_warn "Created ~/.gitconfig from template. Please update with your author details."
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_shell
fi
