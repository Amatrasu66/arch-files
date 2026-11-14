#!/usr/bin/env bash
# Package installation orchestrator supporting profiles
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"
source "$SCRIPT_DIR/lib/packages.sh"

PROFILE="default"
export DRY_RUN="${DRY_RUN:-0}"

usage() {
    cat << HELP
Usage: $(basename "$0") [OPTIONS]

Options:
  --profile <name>   Install packages for profile (default, minimal, development) [Default: default]
  --dry-run          Simulate package installation without modifying packages
  -h, --help         Show this help message
HELP
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --dry-run)
            export DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            PROFILE="$1"
            shift
            ;;
    esac
done

log_info "=== arch-files Package Installer ==="
detect_hardware

profile_pkg_file="$PROFILES_DIR/$PROFILE/packages.txt"
if [[ ! -f "$profile_pkg_file" ]]; then
    log_error "Package list for profile '$PROFILE' not found at: $profile_pkg_file"
    exit 1
fi

log_info "Installing package set for profile: $PROFILE"
install_packages_from_file "$profile_pkg_file"

log_success "Package installation completed for profile '$PROFILE'."
