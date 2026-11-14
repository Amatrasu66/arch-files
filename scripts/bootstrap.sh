#!/usr/bin/env bash
# System bootstrapper: prerequisites, base-devel, and yay AUR helper
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

export DRY_RUN="${DRY_RUN:-0}"

log_info "=== Arch Linux System Bootstrap ==="

if ! command -v pacman >/dev/null 2>&1; then
    log_error "This script requires an Arch Linux installation with pacman."
    exit 1
fi

# 1. Check prerequisites: base-devel and git
MISSING_PREREQS=()
for pkg in base-devel git; do
    if ! pacman -Qq "$pkg" >/dev/null 2>&1; then
        MISSING_PREREQS+=("$pkg")
    fi
done

if [[ ${#MISSING_PREREQS[@]} -gt 0 ]]; then
    log_warn "Missing required base packages: ${MISSING_PREREQS[*]}"
    if [[ "$DRY_RUN" == "1" ]]; then
        log_info "[DRY-RUN] Would install: sudo pacman -S --needed ${MISSING_PREREQS[*]}"
    else
        log_info "Installing prerequisites..."
        sudo pacman -S --needed --noconfirm "${MISSING_PREREQS[@]}"
    fi
else
    log_success "Prerequisites (base-devel, git) are satisfied."
fi

# 2. Check for existing AUR helper
if command -v yay >/dev/null 2>&1; then
    log_success "AUR helper 'yay' is already installed."
    exit 0
elif command -v paru >/dev/null 2>&1; then
    log_success "AUR helper 'paru' is already installed."
    exit 0
fi

# 3. Bootstrap yay-bin from AUR
log_info "No AUR helper found. Bootstrapping yay-bin from AUR..."
if [[ "$DRY_RUN" == "1" ]]; then
    log_info "[DRY-RUN] Would clone https://aur.archlinux.org/yay-bin.git and run makepkg -si"
else
    TMP_DIR=$(mktemp -d /tmp/yay_bootstrap_XXXXXX)
    trap 'rm -rf "$TMP_DIR"' EXIT
    git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"
    (cd "$TMP_DIR/yay-bin" && makepkg -si --noconfirm)
    log_success "yay installed successfully!"
fi
