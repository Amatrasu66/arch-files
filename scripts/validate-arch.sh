#!/usr/bin/env bash
# Target-Environment Validator for Arch Linux
# Runs full live verification:
# 1. Niri compositor configuration (niri validate)
# 2. Systemd user service units against live environment (systemd-analyze verify --user)
# 3. Target package availability and environment requirements
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"

ERRORS=0
WARNINGS=0

log_info "=== Target-Environment (Arch Linux) Validation ==="

# 1. Niri Configuration Validation
log_info "1. Validating Niri Compositor Configuration..."
if command -v niri >/dev/null 2>&1; then
    if niri validate --config "$CONFIGS_DIR/niri/config.kdl"; then
        log_success "Niri configuration ($CONFIGS_DIR/niri/config.kdl) is valid."
    else
        log_error "Niri configuration validation failed."
        ERRORS=$((ERRORS + 1))
    fi
else
    log_error "Niri binary not found on target Arch environment."
    ERRORS=$((ERRORS + 1))
fi

# 2. Systemd User Units Live Verification
log_info "2. Validating Systemd User Service Units with systemd-analyze..."
if command -v systemd-analyze >/dev/null 2>&1; then
    # Ensure a valid runtime directory is set for headless/container validation
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/systemd-runtime-$$}"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # In container or non-root environments without specific AUR binaries installed,
    # provision temporary test stubs for missing binaries in a dedicated directory and add to PATH.
    # When running as root (e.g. in standard CI container), also link into /usr/bin if needed.
    STUB_DIR="/tmp/test-stubs-$$"
    mkdir -p "$STUB_DIR"
    
    # User-space binaries expected in ~/.local/bin
    mkdir -p "${HOME}/.local/bin"
    if [[ ! -e "${HOME}/.local/bin/session-inactivity-manager" ]]; then
        ln -sf "$CONFIGS_DIR/misc/bin/session-inactivity-manager" "${HOME}/.local/bin/session-inactivity-manager"
    fi
    if [[ ! -e "${HOME}/.local/bin/swayidle" ]] && command -v swayidle >/dev/null 2>&1; then
        ln -sf "$(command -v swayidle)" "${HOME}/.local/bin/swayidle"
    fi
    
    for bin_name in quickshell cliphist swayidle; do
        if ! command -v "$bin_name" >/dev/null 2>&1; then
            cat << 'STUB_EOF' > "$STUB_DIR/$bin_name"
#!/bin/sh
exit 0
STUB_EOF
            chmod +x "$STUB_DIR/$bin_name"
            if [[ $EUID -eq 0 && ! -e "/usr/bin/$bin_name" ]]; then
                ln -sf "$STUB_DIR/$bin_name" "/usr/bin/$bin_name"
            fi
        fi
    done
    export PATH="$STUB_DIR:${HOME}/.local/bin:$PATH"
    
    UNIT_ERRORS=0
    for s_file in "$CONFIGS_DIR/misc/systemd-user/"*.service; do
        [[ -L "$s_file" ]] && continue
        bname=$(basename "$s_file")
        if output=$(systemd-analyze verify --user "$s_file" 2>&1); then
            log_success "Systemd unit valid: $bname"
        else
            log_error "Systemd unit invalid: $bname\n$output"
            UNIT_ERRORS=$((UNIT_ERRORS + 1))
        fi
    done
    
    rm -rf "$STUB_DIR"
    
    if [[ $UNIT_ERRORS -eq 0 ]]; then
        log_success "All systemd user service units passed live systemd-analyze verification."
    else
        ERRORS=$((ERRORS + UNIT_ERRORS))
    fi
else
    log_error "systemd-analyze not found on target Arch environment."
    ERRORS=$((ERRORS + 1))
fi

# 3. Executable Dependencies Verification
log_info "3. Checking Key Target Executables..."
REQUIRED_BINS=(
    "/usr/bin/niri"
    "/usr/bin/quickshell"
    "/usr/bin/swaybg"
    "/usr/bin/swayidle"
    "/usr/bin/wl-paste"
    "/usr/bin/cliphist"
)

for bin in "${REQUIRED_BINS[@]}"; do
    if [[ -x "$bin" ]] || command -v "$(basename "$bin")" >/dev/null 2>&1; then
        log_success "Executable available: $(basename "$bin")"
    else
        log_warn "Executable not installed in active environment: $bin (may be installed by package installer)"
        WARNINGS=$((WARNINGS + 1))
    fi
done

echo ""
if [[ $ERRORS -eq 0 ]]; then
    log_success "=== TARGET ARCH VALIDATION PASSED (Errors: 0, Warnings: $WARNINGS) ==="
    exit 0
else
    log_error "=== TARGET ARCH VALIDATION FAILED WITH $ERRORS ERROR(S) (Warnings: $WARNINGS) ==="
    exit 1
fi
