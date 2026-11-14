#!/usr/bin/env bash
# Backup and safety restore helpers
set -euo pipefail

create_target_backup() {
    local backup_dir="${USER_HOME}/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    log_info "Creating pre-deployment safety backup in: $backup_dir"

    local targets=(
        ".config/niri"
        ".config/kitty"
        ".config/fuzzel"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".config/xsettingsd"
        ".config/swaylock"
        ".config/swayidle"
        ".config/Thunar"
        ".config/environment.d"
        ".config/xdg-desktop-portal"
        ".config/systemd/user"
        ".zshrc"
        ".bashrc"
        ".bash_profile"
        ".local/bin"
    )

    for item in "${targets[@]}"; do
        if [[ -e "$USER_HOME/$item" ]]; then
            mkdir -p "$backup_dir/$(dirname "$item")"
            cp -a "$USER_HOME/$item" "$backup_dir/$item"
            log_info "Backed up: $item"
        fi
    done
    log_success "Safety backup created at $backup_dir"
    echo "$backup_dir"
}
