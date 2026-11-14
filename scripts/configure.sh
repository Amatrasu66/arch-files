#!/usr/bin/env bash
# Central configuration deployment orchestrator supporting profiles and modular execution
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"
source "$SCRIPT_DIR/lib/symlinks.sh"
source "$SCRIPT_DIR/lib/backup.sh"

PROFILE="default"
MODULE=""
export DRY_RUN="${DRY_RUN:-0}"

usage() {
    cat << HELP
Usage: $(basename "$0") [OPTIONS]

Options:
  --profile <name>   Deploy modules matching specified profile (default, minimal, development) [Default: default]
  --module <name>    Deploy only a specific module (e.g. niri, modesty, kitty, gtk, shell, lockscreen)
  --dry-run          Preview all link and copy operations without making changes
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
        --module)
            MODULE="$2"
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
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

log_info "=== arch-files Configuration Deployment ==="
if [[ "$DRY_RUN" == "1" ]]; then
    log_warn "DRY-RUN MODE: No files will be modified."
else
    create_target_backup > /dev/null || true
fi

if [[ -n "$MODULE" ]]; then
    mod_script="$REPO_ROOT/scripts/modules/${MODULE}.sh"
    if [[ ! -f "$mod_script" ]]; then
        log_error "Module script not found: $mod_script"
        exit 1
    fi
    log_info "Executing specific module: $MODULE"
    bash "$mod_script"
    log_success "Module $MODULE deployment completed."
    exit 0
fi

# Profile-based execution
profile_dir="$PROFILES_DIR/$PROFILE"
if [[ ! -d "$profile_dir" || ! -f "$profile_dir/modules.txt" ]]; then
    log_error "Invalid or missing profile: $PROFILE"
    exit 1
fi

log_info "Deploying profile: $PROFILE"
while read -r mod; do
    [[ -z "$mod" || "$mod" =~ ^# ]] && continue
    mod_script="$REPO_ROOT/scripts/modules/${mod}.sh"
    if [[ -f "$mod_script" ]]; then
        log_info "Running module: $mod"
        bash "$mod_script"
    else
        log_warn "Module definition file not found: $mod_script (skipping)"
    fi
done < "$profile_dir/modules.txt"

log_success "Profile '$PROFILE' deployed successfully!"
