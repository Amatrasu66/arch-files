#!/usr/bin/env bash
# Robust symlink and file deployment helper
set -euo pipefail

record_deployment() {
    local type="$1"
    local path="$2"
    mkdir -p "$(dirname "$MANIFEST_FILE")"
    echo "${type}|${path}|$(date -Iseconds)" >> "$MANIFEST_FILE"
}

safe_link() {
    local src="$1"
    local dest="$2"
    local dry_run="${DRY_RUN:-0}"

    if [[ "$dry_run" == "1" ]]; then
        log_info "[DRY-RUN] Link: $src -> $dest"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        local current_target
        current_target=$(readlink "$dest")
        if [[ "$current_target" == "$src" ]]; then
            log_info "Already linked: $dest -> $src"
            record_deployment "symlink" "$dest"
            return 0
        fi
        log_warn "Replacing existing symlink $dest (pointed to $current_target)"
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        local backup="${dest}.bak.$(date +%Y%m%d_%H%M%S)"
        log_warn "Existing file at $dest. Backing up to $backup"
        mv "$dest" "$backup"
        record_deployment "backup" "$backup"
    fi

    ln -s "$src" "$dest"
    record_deployment "symlink" "$dest"
    log_success "Linked: $dest -> $src"
}

safe_copy() {
    local src="$1"
    local dest="$2"
    local dry_run="${DRY_RUN:-0}"

    if [[ "$dry_run" == "1" ]]; then
        log_info "[DRY-RUN] Copy: $src -> $dest"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        if cmp -s "$src" "$dest"; then
            record_deployment "file" "$dest"
            return 0
        fi
        local backup="${dest}.bak.$(date +%Y%m%d_%H%M%S)"
        log_warn "Existing file at $dest. Backing up to $backup"
        mv "$dest" "$backup"
        record_deployment "backup" "$backup"
    fi

    cp -a "$src" "$dest"
    record_deployment "file" "$dest"
    log_success "Copied: $dest"
}
