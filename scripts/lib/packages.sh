#!/usr/bin/env bash
# Package management and AUR detection
set -euo pipefail

get_aur_helper() {
    if command -v yay >/dev/null 2>&1; then
        echo "yay"
    elif command -v paru >/dev/null 2>&1; then
        echo "paru"
    else
        echo ""
    fi
}

install_packages_from_file() {
    local file="$1"
    local dry_run="${DRY_RUN:-0}"

    if [[ ! -f "$file" ]]; then
        log_error "Package list file not found: $file"
        return 1
    fi

    local pkgs
    pkgs=$(grep -v '^#' "$file" | grep -v '^$' | tr '\n' ' ')
    if [[ -z "$pkgs" ]]; then
        return 0
    fi

    local helper
    helper=$(get_aur_helper)
    if [[ -z "$helper" ]]; then
        log_error "No AUR helper (yay or paru) detected. Run scripts/bootstrap.sh first."
        return 1
    fi

    if [[ "$dry_run" == "1" ]]; then
        log_info "[DRY-RUN] $helper -S --needed $pkgs"
    else
        log_info "Installing packages from $(basename "$file")..."
        $helper -S --needed --noconfirm $pkgs
    fi
}
