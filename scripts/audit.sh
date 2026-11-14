#!/usr/bin/env bash
# Non-destructive hardware and environment auditor for target systems

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

log_info "=== Target Machine Forensic Audit ==="
detect_hardware

echo ""
log_info "Checking Display Server & Compositor:"
echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-unknown}"
echo "CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP:-unknown}"

echo ""
log_info "Checking Package Manager:"
which pacman >/dev/null && log_success "pacman is available" || log_error "pacman NOT found"
which yay >/dev/null && log_success "yay AUR helper is available" || log_warn "yay NOT found (will bootstrap if needed)"

echo ""
log_info "Audit complete."
