#!/usr/bin/env bash
# Safe uninstaller: removes only managed symlinks and provides dry-run protection
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"

CONFIRM=0
DRY_RUN=1

usage() {
    cat << HELP
Usage: $(basename "$0") [OPTIONS]

Options:
  --confirm   Perform actual unlinking (Default is dry-run for safety)
  --dry-run   Preview which symlinks would be removed without deleting anything
  -h, --help  Show this message
HELP
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --confirm)
            CONFIRM=1
            DRY_RUN=0
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

log_info "=== arch-files Safe Uninstaller ==="

TARGET_LINKS=(
    "$XDG_CONFIG_HOME/niri/config.kdl"
    "$XDG_CONFIG_HOME/kitty/kitty.conf"
    "$XDG_CONFIG_HOME/fuzzel/fuzzel.ini"
    "$XDG_CONFIG_HOME/quickshell"
    "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"
    "$XDG_CONFIG_HOME/gtk-3.0/gtk.css"
    "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    "$XDG_CONFIG_HOME/gtk-3.0/assets"
    "$XDG_CONFIG_HOME/gtk-4.0/assets"
    "$XDG_CONFIG_HOME/xsettingsd/xsettingsd.conf"
    "$XDG_CONFIG_HOME/swaylock/config"
    "$XDG_CONFIG_HOME/swayidle/config"
    "$XDG_CONFIG_HOME/Thunar/uca.xml"
    "$XDG_CONFIG_HOME/Thunar/accels.scm"
    "$XDG_CONFIG_HOME/brave-flags.conf"
    "$XDG_CONFIG_HOME/mimeapps.list"
    "$USER_HOME/.zshrc"
    "$USER_HOME/.bashrc"
    "$USER_HOME/.bash_profile"
    "$USER_BIN_DIR/lock-session"
)

# Add helper scripts and systemd units
for s in "$CONFIGS_DIR"/misc/bin/*; do
    [[ -f "$s" ]] && TARGET_LINKS+=("$USER_BIN_DIR/$(basename "$s")")
done
for u in "$CONFIGS_DIR"/misc/systemd-user/*; do
    [[ -f "$u" ]] && TARGET_LINKS+=("$USER_SYSTEMD_DIR/$(basename "$u")")
done

REMOVED=0
FOUND=0

for link in "${TARGET_LINKS[@]}"; do
    if [[ -L "$link" ]]; then
        target=$(readlink "$link" || echo "")
        # Verify link points into our repository or App directory
        if [[ "$target" =~ arch-files || "$target" =~ App/Modesty ]]; then
            FOUND=$((FOUND + 1))
            if [[ "$DRY_RUN" == "1" ]]; then
                log_info "[DRY-RUN] Would remove symlink: $link -> $target"
            else
                rm "$link"
                log_success "Removed symlink: $link"
                REMOVED=$((REMOVED + 1))
            fi
        fi
    fi
done

if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Dry-run complete. $FOUND managed symlink(s) identified."
    log_warn "To remove these symlinks, re-run with: $(basename "$0") --confirm"
else
    log_success "Uninstallation complete. $REMOVED symlink(s) removed cleanly."
fi
