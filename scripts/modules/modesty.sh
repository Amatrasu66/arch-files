#!/usr/bin/env bash
# Deploy Modesty Dynamic Island shell (via QuickShell)
set -euo pipefail

deploy_modesty() {
    local dry_run="${DRY_RUN:-0}"
    local target_clone="${USER_HOME}/App/Modesty"
    local quickshell_symlink="${XDG_CONFIG_HOME}/quickshell"
    local upstream_json="$UPSTREAM_DIR/modesty/upstream.json"
    local patch_file="$UPSTREAM_DIR/modesty/patches/modesty-customizations.patch"
    local additions_dir="$UPSTREAM_DIR/modesty/additions"

    log_info "Deploying Modesty Dynamic Island Desktop Shell..."

    if [[ "$dry_run" == "1" ]]; then
        log_info "[DRY-RUN] Modesty: Verify clone at $target_clone, apply patch, copy additions, and link to $quickshell_symlink"
        return 0
    fi

    # Check if Modesty source exists
    if [[ ! -d "$target_clone/.git" ]]; then
        mkdir -p "$(dirname "$target_clone")"
        local repo_source="${MODESTY_REPO_URL:-https://github.com/sandeepbist/Modesty.git}"
        if [[ -n "${MODESTY_SOURCE_OVERRIDE:-}" && -d "$MODESTY_SOURCE_OVERRIDE/.git" ]]; then
            repo_source="$MODESTY_SOURCE_OVERRIDE"
            log_info "Cloning Modesty from local reference: $repo_source"
        else
            log_info "Cloning upstream Modesty from: $repo_source"
        fi
        git clone "$repo_source" "$target_clone"
        (cd "$target_clone" && git checkout 690af8b -f)
        
        log_info "Applying local customizations patch..."
        (cd "$target_clone" && git apply "$patch_file")
    fi

    # Copy / update custom additions into target_clone
    if [[ -d "$additions_dir" ]]; then
        log_info "Synchronizing custom additions into Modesty tree..."
        cp -a "$additions_dir"/. "$target_clone"/
    fi

    # Deploy symlink ~/.config/quickshell -> target_clone
    safe_link "$target_clone" "$quickshell_symlink"

    # Deploy session and cava configs
    if [[ -f "$CONFIGS_DIR/modesty/cava.conf" ]]; then
        mkdir -p "$XDG_CONFIG_HOME/modesty"
        safe_copy "$CONFIGS_DIR/modesty/cava.conf" "$XDG_CONFIG_HOME/modesty/cava.conf"
    fi
    if [[ -f "$CONFIGS_DIR/modesty/session.json" ]]; then
        mkdir -p "$XDG_CONFIG_HOME/modesty"
        safe_copy "$CONFIGS_DIR/modesty/session.json" "$XDG_CONFIG_HOME/modesty/session.json"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
    source "$(dirname "${BASH_SOURCE[0]}")/../lib/symlinks.sh"
    deploy_modesty
fi
